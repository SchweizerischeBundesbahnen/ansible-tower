#!/bin/bash

commit_hash="`git rev-parse HEAD`"
echo "commit_hash=$commit_hash"

feature_branch="`git rev-parse --symbolic-full-name HEAD`"
echo "feature_branch=$feature_branch"



# for testing...
feature_branch="refs/heads/feature/WZU-2994"

# if we're not on a feature branch...
if  [[ $feature_branch == *feature* ]]
then
    python extract_open_pull_request_id.py ${feature_branch} ${commit_hash}
fi




