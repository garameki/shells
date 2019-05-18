#!/bin/bash


NOW="$(date +'%B %d,%Y')"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

QUESTION_FLAG="${GREEN}"
WARNING_FLAG="${YELLOW}"
NOTICE_FLAG="${CYAN}"

BRANCHING_MSG="${NOTICE_FLAG} creating new version release branch to the ${WHITE}origin${CYAN}..."

if [ -f VERSION ]; then
	echo "It has already begun."
else
	git branch -vv
	git remote -v
	echo -e "${WARNING_FLAG}You must be in master branch"
	echo -e "${WARNING_FLAG}And you must make origin your ref you want to push by 'git remote add origin ~'"
	read any
    echo -ne "${QUESTION_FLAG} ${CYAN}Do you want to create a version file, develop branch and release blanch and then start from scratch? [${WHITE}y${CYAN}]: "
    read RESPONSE
    if [ "$RESPONSE" = "" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "Y" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "Yes" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "yes" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "YES" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "y" ]; then



	SUGGESTED_VERSION="0.1"
	echo -ne "${QUESTION_FLAG} ${CYAN}Enter a version number [${WHITE}$SUGGESTED_VERSION${CYAN}]:" #""の中の${}は{}の中身を解釈した結果に置換される
	read INPUT_STRING
	if [ "$INPUT_STRING" = "" ]; then
		INPUT_STRING=$SUGGESTED_VERSION
	fi



	
		echo ""
	    	echo "git checkout -b master"
    	git checkout -b master
		echo ""
		echo "git push --set-upstream origin master"
	git push --set-upstream origin master
		echo ""
	    	echo "git checkout -b develop master"
    	git checkout -b develop master
		echo ""
		echo "git push --set-upstream origin develop"
	git push --set-upstream origin develop
		echo ""
		echo "git checkout -b release-$INPUT_STRING develop"
	git checkout -b release-$INPUT_STRING develop
		echo ""
		echo "git push origin release-$INPUT_STRING"
	git push origin release-$INPUT_STRING

        echo "$INPUT_STRING.0" > VERSION
        echo "## $INPUT_STRING.0 ($NOW)" > CHANGELOG.md
        git log --pretty=format:"  - %s" >> CHANGELOG.md > /dev/null
        echo "" >> CHANGELOG.md
        echo "" >> CHANGELOG.md
        echo -e "$PUSHING_MSG"
		echo ""
	        echo "git add VERSION CHANGELOG.md"
        git add VERSION CHANGELOG.md
		echo ""
	        echo "git commit -m "Add VERSION and CHANGELOG.md files, Bump version to v$INPUT_STRING.0.""
        git commit -m "Add VERSION and CHANGELOG.md files, Bump version to v$INPUT_STRING.0."
		echo ""
	        echo "git tag -a -m "Tag version $INPUT_STRING.0." "v$INPUT_STRING.0""
        git tag -a -m "Tag version $INPUT_STRING.0." "v$INPUT_STRING.0"
		echo ""
		echo "git branch --set-upstream-to=origin/master master"
	git branch --set-upstream-to=origin/master master
		echo ""
		echo "git branch --set-upstream-to=origin/develop develop"
	git branch --set-upstream-to=origin/develop develop
		echo ""
		echo "git branch --set-upstream-to=origin/release-$INPUT_STRING release-$INPUT_STRING"
	git branch --set-upstream-to=origin/release-$INPUT_STRING release-$INPUT_STRING
		echo ""
		echo "git push"
        git push

    fi
fi
