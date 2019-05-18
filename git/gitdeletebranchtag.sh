#!/bin/bash


if [ $# -ne 0 ]; then
	LIST=$(git log --pretty=format:"%H")
	count=0
	for ele in ${LIST// / }; do

		if [[ $ele =~ ^$1 ]]; then
			let count++
			echo $ele
		fi

	done
	if [ count = 0]; then
		echo "一致するハッシュがありません"
		echo "No hash exist corresponding to the hash inputed."
	elif [ count -gt 1 ]; then
		echo "一致するハッシュが複数あります"
		echo "Too many hashes was found."
	else




		#master branch以外削除(ローカル) delete all branches except for master in local repository

		git checkout master
		LIST=$(git branch | tr -d '* ')
		for ele in ${LIST//* / }; do
			if [ $ele != "master" ]; then
				echo "git branch -D $ele"
				git branch -D $ele
			fi
		done
		git checkout $ele
		git checkout -b master02900141-temporary
		git branch -D master
		git checkout -b master
		git branch -D master02900141-temporary







		#master branch以外削除(リモート) delete all branches except for master in remote repository

		LIST=$(git branch -r)
		for ele in ${LIST// / }; do
			if [[ ${ele} =~ origin/master ]] || [[ ${ele} =~ raspi/ ]]; then
				echo ""
			else
				#echo ${ele//\// }
				echo -ne "$ele is about to delete from remote repository. OK?[yes]"
				read ANS
				if [ $ANS = "yes" ]; then
					echo ""
					echo "git push --delete ${ele//\// }"
					git push --delete  ${ele//\// }
				fi
			fi
		done






		#HEADより先にある全タグ削除 delete all tags in front of HEAD

		echo "All tag and its hash"
		TAGS=()
		COMMITS=()
		LIST_TAG=$(git tag)
		for ele in ${LIST_TAG[@]}; do
echo $ele
			LIST=$(git show $ele | grep -E "^commit")
			for ele2 in ${LIST[@]}; do
				if [[ $LIST =~ ^commit(.+)$ ]]; then
					COMMITS+=(${BASH_REMATCH[1]})
					echo ${BASH_REMATCH[1]}
					TAGS+=($ele)
					break
				fi
			done

		done

		DELETES=()
		ALL_COMMITS=$(git log --pretty=format:%H)
		for ele in ${ALL_COMMITS[@]}; do
			ii=0
			for ele2 in ${COMMITS[@]}; do
				if [ "${ele}" == "${ele2}" ]; then
					DELETES+=($ii)
				fi
				let ii++
			done
		done

		for ii in ${DELETES[@]}; do

			unset TAGS[$ii]

		done

		echo ""
		echo "tags to be removed"
		for tag in ${TAGS[@]}; do
			echo $tag
			#git tag -d $tag
			#git push origin :refs/tags/$tag
		done
		echo "checkoutしたコミットよりも先のタグをリモートとローカルから削除するにはコメントアウトを外してください"




		#リモートリポジトリにも反映 push edited histroy to remote repository

		echo "git push -f origin master"
		git push -f origin master
	fi
else
	echo -e "引数（ハッシュまたは正規表現）を指定してください。"
	echo -e "expect hash or regexp as argument"
fi
