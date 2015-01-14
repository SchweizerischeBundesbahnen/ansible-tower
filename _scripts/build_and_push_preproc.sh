#!/bin/bash

branch=$1

commit_hash="`git rev-parse HEAD`"
echo "commit_hash=$commit_hash"
echo "branch=$branch"

# for testing...
feature_branch="refs/heads/$branch"

# if we're not on a feature branch...
if  [[ $feature_branch != *feature* ]]
then
    python extract_open_pull_request_id.py ${feature_branch} ${commit_hash}
fi




