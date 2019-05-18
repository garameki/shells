#!/bin/bash

echo ?Input Release BRANCH number [*.*.*]:
read VERSION
i=0
numbers=()
for ele in ${VERSION//\./ }; do
	numbers[i]=$ele
	let i++
done
vera=${numbers[0]}.${numbers[1]}
verb=$vera.${numbers[2]}
git checkout develop
git merge --no-ff -m "Merge from the branch release-${vera}" release-$vera
git push
git checkout release-$vera
