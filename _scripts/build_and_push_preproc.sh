#!/bin/bash

feature_branch="`git rev-parse --abbrev-ref HEAD`"
commit_hash="`git rev-parse HEAD`"

# for testing...
feature_branch="refs/heads/feature/WZU-2994

# if we're on develop or master, we have to extract the open feature branch...
python extract_open_pull_request_id.py ${feature_branch} ${commit_hash}


