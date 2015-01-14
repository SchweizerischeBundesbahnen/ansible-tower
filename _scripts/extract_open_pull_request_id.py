#!/usr/bin/python
####################################################################################
##BLOCK STASH REPOSITORIES
####################################################################################
#This script blocks the develop branch of a various number of Stash Repositories
#under a given project.
####################################################################################
#Workflow of restricting mavendemo in kd_wzu
####################################################################################
#1. GET  https://code.sbb.ch/rest/branch-permissions/1.0/projects/KD_WZU/repos/mavendemo/restricted
#RETURN: {"size":7,"limit":100,"isLastPage":true,"values":[{"id":222,"type":"BRANCH","value":"refs/heads/develop","branch":{"id":"refs/heads/develop","displayId":"develop","latestChangeset":"fab9a73f5368f4a68ad80fc6025317dc2046ae1d","isDefault":true}},{"id":223,"type":"BRANCH","value":"refs/heads/master","branch":{"id":"refs/heads/master","displayId":"master","latestChangeset":"f11590c20b3397fffc3d6fc27d45a33677033ede","isDefault":false}},{"id":357,"type":"PATTERN","value":"*"},{"id":359,"type":"PATTERN","value":"feature/**"},{"id":358,"type":"PATTERN","value":"hotfix/**"},{"id":361,"type":"PATTERN","value":"release/**"},{"id":360,"type":"PATTERN","value":"tags/**"}],"start":0,"filter":null}
#ID to Lock: 222
#2. PUT https://code.sbb.ch/rest/branch-permissions/1.0/projects/KD_WZU/repos/mavendemo/restricted/222
#CONTENT: {"type": "BRANCH","value": "refs/heads/develop","users": ["release"]}
####################################################################################
#USAGE:
####################################################################################
#python blocker.py u123456 PASS PROJECT [release|automerge] REPO1 REPO2 REPO3
####################################################################################

import httplib
import base64
import string
import json
import sys
import urllib
#general settings
host = 'code.sbb.ch'
feature_branch = str(sys.argv[1])
commit_hash = str(sys.argv[2])
userid = 'release'
passwd = 'release'
auth = 'Basic ' + string.strip(base64.encodestring(userid + ':' + passwd))

#construct the REST URL
getUrl = '/rest/api/1.0/projects/kd_wzu/repos/wzu-docker/pull-requests?direction=OUTGOING&state=open&order=newest&withAttributes=false&withProperties=false&at=' + urllib.quote_plus( feature_branch )

#getting the permissions for each repos...
c=httplib.HTTPSConnection(host)
c.putrequest('GET', getUrl)
c.putheader('Authorization', auth )
c.endheaders()
response = c.getresponse()
c.close()
print response.status, response.reason
data = response.read()
values = json.loads(data).get("values")

print getUrl
print json.dumps(values, sort_keys=True, indent=4)

#...and find the id of the develop branch
for value in values:
    the_id = value["id"]

print the_id


