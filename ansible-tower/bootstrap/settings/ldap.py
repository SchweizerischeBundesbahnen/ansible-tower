###############################################################################
# LDAP AUTHENTICATION SETTINGS
###############################################################################

# Ansible Tower can be configured to centrally use LDAP as a source for
# authentication information.  When so configured, a user who logs in with
# a LDAP username and password will automatically get an account created for
# them, and they can be automatically placed into multiple organizations as
# either regular users or organization administrators.  If users are created
# via an LDAP login, by default they cannot change their username, firstname,
# lastname, or set a local password for themselves. This is also tunable
# to restrict editing of other field names.


# For more information about these various settings, advanced users may refer
# to django-auth-ldap docs, though this should not be neccessary for most
# users: http://pythonhosted.org/django-auth-ldap/authentication.html

# Imports needed for LDAP configuration.
# do not alter this section

import ldap
from django_auth_ldap.config import LDAPSearch, LDAPSearchUnion
from django_auth_ldap.config import GroupOfNamesType
#from django_auth_ldap.config import ActiveDirectoryGroupType

# LDAP server URI, such as "ldap://ldap.example.com:389" (non-SSL) or
# "ldaps://ldap.example.com:636" (SSL).  LDAP authentication is disabled if
# this parameter is empty or your license does not enable LDAP support.

AUTH_LDAP_SERVER_URI = 'ldap://ldapi.sbb.ch:389'

# DN (Distinguished Name) of user to bind for all search queries. Normally in the format
# "CN=Some User,OU=Users,DC=example,DC=com" but may also be specified as
# "DOMAIN\username" for Active Directory. This is the system user account
# we will use to login to query LDAP for other user information.

AUTH_LDAP_BIND_DN = 'cn=Directory Reader,dc=SBB,dc=ch'

# Password using to bind above user account.

AUTH_LDAP_BIND_PASSWORD = 'dirxread'

# Whether to enable TLS when the LDAP connection is not using SSL.

AUTH_LDAP_START_TLS = False

# Additional options to set for the LDAP connection.  LDAP referrals are
# disabled by default (to prevent certain LDAP queries from hanging with AD).

AUTH_LDAP_CONNECTION_OPTIONS = {
    ldap.OPT_REFERRALS: 0,
}

# LDAP search query to find users.  Any user that matches the pattern
# below will be able to login to Tower.  The user should also be mapped
# into an Tower organization (as defined later on in this file).  If multiple
# search queries need to be supported use of "LDAPUnion" is possible. See
# python-ldap documentation as linked at the top of this section.

AUTH_LDAP_USER_SEARCH = LDAPSearch(
    'dc=SBB,dc=ch',   # Base DN
    ldap.SCOPE_SUBTREE,             # SCOPE_BASE, SCOPE_ONELEVEL, SCOPE_SUBTREE
    '(& (cn=%(user)s)(objectclass=organizationalPerson)(| (!(sbbActiveState=*)) (!(sbbActiveState=inactive))))' # Query
)

# Alternative to user search, if user DNs are all of the same format. This will be
# more efficient for lookups than the above system if it is usable in your organizational
# environment. If this setting has a value it will be used instead of AUTH_LDAP_USER_SEARCH
# above.

#AUTH_LDAP_USER_DN_TEMPLATE = 'uid=%(user)s,OU=Users,DC=example,DC=com'

# Mapping of LDAP user schema to Tower API user atrributes (key is user attribute name, value is LDAP
# attribute name).  The default setting in this configuration file is valid for ActiveDirectory but
# users with other LDAP configurations may need to change the values (not the keys) of the dictionary/hash-table
# below.

AUTH_LDAP_USER_ATTR_MAP = {
    'first_name': 'givenName',
    'last_name': 'sn',
    'email': 'mail',
}

# Users in Tower are mapped to organizations based on their membership in LDAP groups.  The following setting defines
# the LDAP search query to find groups. Note that this, unlike the user search above, does not support LDAPSearchUnion.

AUTH_LDAP_GROUP_SEARCH = LDAPSearch(
    'dc=SBB,dc=ch',    # Base DN
    ldap.SCOPE_SUBTREE,     # SCOPE_BASE, SCOPE_ONELEVEL, SCOPE_SUBTREE
    '(&((cn=companytrusted_users))(objectClass=groupOfNames))',
)

# The group type import may need to be changed based on the type of the LDAP server.
# Values are listed at: http://pythonhosted.org/django-auth-ldap/groups.html#types-of-groups


#AUTH_LDAP_GROUP_TYPE = '*:cn'
AUTH_LDAP_GROUP_TYPE = GroupOfNamesType()
#AUTH_LDAP_GROUP_TYPE = ActiveDirectoryGroupType()

# Group DN required to login. If specified, user must be a member of this
# group to login via LDAP.  If not set, everyone in LDAP that matches the
# user search defined above will be able to login via Tower.  Only one
# require group is supported.

#AUTH_LDAP_REQUIRE_GROUP = ''

# Group DN denied from login. If specified, user will not be allowed to login
# if a member of this group.  Only one deny group is supported.

#AUTH_LDAP_DENY_GROUP = ''

# User profile flags updated from group membership (key is user attribute name,
# value is group DN).  These are boolean fields that are matched based on
# whether the user is a member of the given group.  So far only is_superuser
# is settable via this method.  This flag is set both true and false at login
# time based on current LDAP settings.

AUTH_LDAP_USER_FLAGS_BY_GROUP = {
    #'is_superuser': ['cn=administrator,ou=applrollen,ou=wast,ou=applikationen,dc=sbb,dc=ch','cn=wzuself_admin,ou=applrollen,ou=wzuself,ou=applikationen,dc=sbb,dc=ch'],
    'is_superuser': ['cn=administrator,ou=applrollen,ou=wast,ou=applikationen,dc=sbb,dc=ch'],
    #'is_superuser': 'CN=Domain Admins,CN=Users,DC=example,DC=com',
}

# Mapping between organization admins/users and LDAP groups. This controls what
# users are placed into what Tower organizations relative to their LDAP group
# memberships. Keys are organization names.  Organizations will be created if not present.
# Values are dictionaries defining the options for each organization's membership.  For each organization
# it is possible to specify what groups are automatically users of the organization and also what
# groups can administer the organization.
#
# - admins: None, True/False, string or list/tuple of strings.
#   If None, organization admins will not be updated based on LDAP values.
#   If True, all users in LDAP will automatically be added as admins of the organization.
#   If False, no LDAP users will be automatically added as admins of the organiation.
#   If a string or list of strings, specifies the group DN(s) that will be added of the organization if they match
#   any of the specified groups.
# - remove_admins: True/False. Defaults to False.
#   If True, a user who is not an member of the given groups will be removed from the organization's administrative list.
# - users: None, True/False, string or list/tuple of strings. Same rules apply
#   as for admins.
# - remove_users: True/False. Defaults to False. Same rules as apply for remove_admins
#
#AUTH_LDAP_ORGANIZATION_MAP = {
#    'WZUSelf': {
#        'admins': 'cn=WZUSelf_Admin,ou=ApplRollen,ou=WZUSelf,ou=Applikationen,dc=sbb,dc=CH',
#        'users': ['cn=WZUSelf_User,ou=ApplRollen,ou=WZUSelf,ou=Applikationen,dc=sbb,dc=CH'],
#        'remove_users' : False,
#        'remove_admins' : False,
#    }
#}

# Mapping between team members (users) and LDAP groups. Keys are team names
# (will be created if not present). Values are dictionaries of options for
# each team's membership, where each can contain the following parameters:
# - organization: string. The name of the organization to which the team
#   belongs.  The team will be created if the combination of organization and
#   team name does not exist.  The organization will first be created if it
#   does not exist.
# - users: None, True/False, string or list/tuple of strings.
#   If None, team members will not be updated.
#   If True/False, all LDAP users will be added/removed as team members.
#   If a string or list of strings, specifies the group DN(s). User will be
#   added as a team member if the user is a member of ANY of these groups.
# - remove: True/False. Defaults to False. If True, a user who is not a member
#   of the given groups will be removed from the team.

#AUTH_LDAP_TEAM_MAP = {
#    'WZUSelf_Admin': {
#        'organization': 'wzuself admin team',
#        'users': ['cn=WZUSelf_Admin,ou=ApplRollen,ou=WZUSelf,ou=Applikationen,dc=sbb,dc=CH'],
#        'remove': True,
#    },
#    'WZUSelf_User': {
#        'organization': 'wzuself user team',
#        'users': 'cn=WZUSelf_User,ou=ApplRollen,ou=WZUSelf,ou=Applikationen,dc=sbb,dc=CH',
#        'remove': False,
#    }
#}
#AUTH_LDAP_ALWAYS_UPDATE_USER = True
#AUTH_LDAP_MIRROR_GROUPS = True
#
#LOGGING = {
#    'version': 1,
#   'disable_existing_loggers': False,
#    'handlers': {
#        'file': {
#            'level': 'DEBUG',
#            'class': 'logging.FileHandler',
#            'filename': '/var/log/tower/tower_debug.log',
#        },
#    },
#    'loggers': {
#        '': {
#            'handlers': ['file'],
#            'level': 'DEBUG',
#            'propagate': True,
#        },
#    },
#}
#
#import logging, logging.handlers
#logfile = "/var/log/tower/django-ldap-debug.log"
#my_logger = logging.getLogger('django_auth_ldap')
#my_logger.setLevel(logging.DEBUG)
#handler = logging.handlers.RotatingFileHandler(logfile, maxBytes=1024 * 500, backupCount=5)
#my_logger.addHandler(handler)
