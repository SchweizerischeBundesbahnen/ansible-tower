#!/bin/bash

feature_branch="`git rev-parse --abbrev-ref HEAD`"
commit_hash="`git rev-parse HEAD`"

# for testing...
feature_branch="refs/heads/feature/WZU-2994"

# if we're not on a feature branch...
#if  [[ $feature_branch != *feature* ]]
#then
    python extract_open_pull_request_id.py ${feature_branch} ${commit_hash}
#fi




