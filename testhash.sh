#!/bin/bash

if [ $# -ne 0 ]; then
	LIST=$(git log --pretty=format:"%H")
	for ele in ${LIST// / }; do

		if [[ $ele =~ ^$1 ]]; then
			echo $ele
		fi

	done
else
	echo -e "引数（ハッシュまたは正規表現）を指定してください。"
	echo -e "expect hash or regexp as argument"
fi
