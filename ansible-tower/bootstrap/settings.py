# AWX settings file
# marker
###############################################################################
# MISC PROJECT SETTINGS
###############################################################################

ADMINS = (
   #('Joe Admin', 'joeadmin@example.com'),
)

STATIC_ROOT = '/var/lib/awx/public/static'

PROJECTS_ROOT = '/var/lib/awx/projects'

JOBOUTPUT_ROOT = '/var/lib/awx/job_status'

SECRET_KEY = file('/etc/tower/SECRET_KEY', 'rb').read().strip()

ALLOWED_HOSTS = ['*']

INTERNAL_API_URL = 'https://deploy-t.sbb.ch:443'


AWX_TASK_ENV['HOME'] = '/var/lib/awx'
AWX_TASK_ENV['USER'] = 'awx'
AWX_TASK_ENV['http_proxy'] = 'http://fsvctip:sommer11@webproxy.sbb.ch:8080'
AWX_TASK_ENV['https_proxy'] = 'http://fsvctip:sommer11@webproxy.sbb.ch:8080'


ACTIVITY_STREAM_ENABLED = True
ACTIVITY_STREAM_ENABLED_FOR_INVENTORY_SYNC = True

SOCKETIO_LISTEN_PORT=11230

###############################################################################
# PROOT SETTINGS
###############################################################################

# Enable proot support for running jobs (playbook runs only).
AWX_PROOT_ENABLED = True

# Additional paths to hide from jobs using proot.
AWX_PROOT_HIDE_PATHS = []

# Additional paths to show for jobs using proot.
AWX_PROOT_SHOW_PATHS = []

###############################################################################
# EMAIL SETTINGS
###############################################################################

SERVER_EMAIL = 'root@localhost'
DEFAULT_FROM_EMAIL = 'webmaster@localhost'
EMAIL_SUBJECT_PREFIX = '[AWX] '

EMAIL_HOST = 'localhost'
EMAIL_PORT = 25
EMAIL_HOST_USER = ''
EMAIL_HOST_PASSWORD = ''
EMAIL_USE_TLS = False

###############################################################################
# LOGGING SETTINGS
###############################################################################

PENDO_TRACKING_STATE = 'detailed'


#LOGGING = {
#    'version': 1,
#    'disable_existing_loggers': True,
#    'handlers': {
#        'console': {
#            'level': 'INFO',
#            'class': 'logging.StreamHandler',
#            'strm': sys.stdout,
#            'formatter': 'simple'  
#        },
#    },
#    'loggers': {
#        '': {
#            'handlers': ['console'],
#            'level': 'INFO',
#            'propagate': True,
#        },
#    },
#}


