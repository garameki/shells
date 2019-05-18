#!/bin/bash

echo "All tag and its hash"
TAGS=()
COMMITS=()
LIST_TAG=$(git tag)
for ele in ${LIST_TAG//\n/ }; do

	LIST=$(git show $ele | grep -E "^tag")
	if [[ $LIST =~ [[:blank:]](.+)$ ]]; then
		TAGS+=(${BASH_REMATCH[1]})
		echo ${BASH_REMATCH[1]}

		LIST=$(git show $ele | grep -E "^commit")
		if [[ $LIST =~ ([[:alnum:]]+)$ ]]; then
			COMMITS+=(${BASH_REMATCH[1]})
			echo ${BASH_REMATCH[1]}
		fi
	fi

done

ALL_COMMITS=$(git log --pretty=format:%H)
for ele in ${ALL_COMMITS//\n/ }; do
	ii=0
	for ele2 in ${COMMITS[@]}; do

		if [ $ele == $ele2 ]; then
			unset COMMITS[ii]
			unset TAGS[ii]
		fi
		let ii++

	done
done

TAGS=(${TAGS[@]})

echo ""
echo "tags to be removed"
for tag in ${TAGS[@]}; do
	echo $tag
	#git tag -d $tag
	#git push origin :refs/tags/$tag
done

echo "checkoutしたコミットよりも先のタグをリモートとローカルから削除するにはコメントアウトを外してください"
