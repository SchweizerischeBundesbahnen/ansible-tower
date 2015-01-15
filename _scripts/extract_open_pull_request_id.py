#!/usr/bin/python
####################################################################################
##Get pull request id for
####################################################################################
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
getUrl = '/rest/api/1.0/projects/kd_wzu/repos/wzu-docker/pull-requests?direction=INCOMING&state=open&order=newest&withAttributes=false&withProperties=false&at=' + urllib.quote_plus( feature_branch )



#getting the permissions for each repos...
c=httplib.HTTPSConnection(host)
c.putrequest('GET', getUrl)
c.putheader('Authorization', auth )
c.endheaders()
response = c.getresponse()
c.close()
#print response.status, response.reason
data = response.read()
values = json.loads(data).get("values")

#print getUrl
print json.dumps(values, sort_keys=True, indent=4)

# Find the id of the pull request open on the branch corresponding to the commit_hash
for value in values:
    if ["latestChangeset"] == commit_hash:
        the_id = value["id"]
print the_id


