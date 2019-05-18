#!/bin/bash

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
			echo "git push --delete  ${ele//\// }"
			git push --delete  ${ele//\// }
		fi
	fi
done
