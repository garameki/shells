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

LATEST_HASH=`git log --pretty=format:'%h' -n 1`

QUESTION_FLAG="${GREEN}"
WARNING_FLAG="${YELLOW}"
NOTICE_FLAG="${CYAN}"

ADJUSTMENTS_MSG="${QUESTION_FLAG} ${CYAN}Now you can make adjustments to ${WHITE}CHANGELOG.md${CYAN}. Then press enter to continue."
BRANCHING_MSG="${NOTICE_FLAG} creating new version release branch to the ${WHITE}origin${CYAN}..."

if [ -f VERSION ]; then
	BASE_STRING=`cat VERSION`
	BASE_LIST=(`echo $BASE_STRING | tr '.' ' '`) #c.f.   BASE_LIST=$(echo $BASE_STRING | tr '.' ' ')
	V_MAJOR=${BASE_LIST[0]}
	V_MINOR=${BASE_LIST[1]}
	V_PATCH=${BASE_LIST[2]}
		echo "git status"
	git status
	echo -ne "${NOTICE_FLAG} YOU ARE CREATING A NEW RELEASE BRANCH OK?"
	read any
		echo "git checkout master"
	git checkout master
	echo -e "${NOTICE_FLAG} Current version: ${WHITE}$BASE_STRING"
	echo -e "${NOTICE_FLAG} Latest commit hash: ${WHITE}$LATEST_HASH"

	V_PRE_MAJOR=$V_MAJOR
	V_PRE_MINOR=$V_MINOR
	V_PRE_PATCH=$V_PATCH


	V_MINOR=$((V_MINOR + 1))
	V_PATCH=0
	SUGGESTED_VERSION="$V_MAJOR.$V_MINOR"
	echo -ne "${QUESTION_FLAG} ${CYAN}Enter a version number [${WHITE}$SUGGESTED_VERSION${CYAN}]:" #""の中の${}は{}の中身を解釈した結果に置換される
	read INPUT_STRING
	if [ "$INPUT_STRING" = "" ]; then
		INPUT_STRING=$SUGGESTED_VERSION
	else
		V_PATCH="0"
	fi

	V_PRE_MM=$V_PRE_MAJOR.$V_PRE_MINOR
	V_PRE_MMP=$V_PRE_MAJOR.$V_PRE_MINOR.$V_PRE_PATCH
	V_NEW_MM=$INPUT_STRING
	V_NEW_MMP=$INPUT_STRING.$V_PATCH

#developにマージ

	echo ""
	echo -e "${NOTICE_FLAG}Will merge to ${WHITE}develop"
		echo ""
		echo "git checkout master"
	git checkout develop
		echo ""
		echo "git merge --no-ff -m 'Merge from the branch release-$V_PRE_MM' release-$V_PRE_MM"
	git merge --no-ff -m "Merge from the branch release-$V_PRE_MM" release-$V_PRE_MM



#新しいreleaseブランチを作成

	RELEASE_BRANCH=release-$V_NEW_MM
	echo ""
	echo -e "${NOTICE_FLAG}Will create new release branch to be ${WHITE}$RELEASE_BRANCH"
		echo ""
		echo "git checkout -b $RELEASE_BRANCH develop"
	git checkout -b $RELEASE_BRANCH develop

	echo "$INPUT_STRING.0" > VERSION
	echo "## $INPUT_STRING ($NOW)" > tmpfile
		echo ""
		echo "git log --pretty=format:'  - %s  v$BASE_STRING...HEAD'  >> tmpfile"
echo HEAD = $HEAD
	git log --pretty=format:"  - %s  v$BASE_STRING...HEAD"  >> tmpfile
	echo "" >> tmpfile
	echo "" >> tmpfile
	cat CHANGELOG.md >> tmpfile
	mv tmpfile CHANGELOG.md #ファイルが存在しても上書き
#	echo -e "$ADJUSTMENTS_MSG"
#	read
	echo -e "$BRANCHING_MSG"
		echo ""
		echo "git add CHANGELOG.md VERSION"
	git add CHANGELOG.md VERSION
		echo ""
		echo "git commit -m 'Create new ${RELEASE_BRANCH} branch'"
	git commit -m "Create new ${RELEASE_BRANCH} branch"
		echo ""
		echo "git tag -a -m 'Tag version ${V_NEW_MMP}.' 'v${iV_NEW_MMP}'"
	git tag -a -m "Tag version ${V_NEW_MMP}." "v${V_NEW_MMP}"
		echo ""
		echo "git push --set-upstream origin '$RELEASE_BRANCH'"
	git push --set-upstream origin $RELEASE_BRANCH






#masterにマージ

	echo ""
	echo -e "${NOTICE_FLAG}Will merge to ${WHITE}master "
		echo ""
		echo "git checkout master"
	git checkout master
		echo ""
		echo "git merge --no-ff -m 'Merge from the branch release-$V_NEW_MM' release-$V_NEW_MM"
	git merge --no-ff -m "Merge from the branch release-$V_NEW_MM" release-$V_NEW_MM
		echo ""
		echo "git tag -a ${V_NEW_MMP} -m '${V_NEW_MMP}'"
	git tag -a $V_NEW_MMP -m "${V_NEW_MMP}"

	git checkout release-$V_NEW_MM



else
    echo -e "${WARNING_FLAG} Could not find a VERSION file."
fi
