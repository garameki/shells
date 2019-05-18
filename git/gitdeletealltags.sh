#!/bin/bash

TAGS=()
LIST=$(git tag)
echo $LIST
for ele in ${LIST// / }; do
	git tag -d $ele
done
git tag
