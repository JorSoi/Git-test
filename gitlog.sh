#!/bin/bash

# -----------------------------------------------------------

# Author:        Andreas Soika
# Created:       06.04.2022
# Updated:       29.10.2022
# Version:       v5.0

# Description:   Git tutorial: demonstrating the most commen 
#                              Git - Usecases

# Usage:         Start this script in a Git-bash terminal windows 
#                  within an empty directory

# Prerequisites: The Git-bash must be available and must be
#                  working with GitLab.

# History:	 v1.0:  First version published
#                v2.0:  Highly improved formatting/layout
#                v3.0:  Draft: added remote repo operation
#                v4.0:  revised table listing show_status()
#                v5.0:  renamed showme -> gitlog

# -----------------------------------------------------------

# Please ignore this section - it's just the definition of some helper functions

function graphnp() {
  git --no-pager log --graph --decorate --all
}

gitcat() {
  git cat-file -p $1  > /dev/null 2> /dev/null
  if [ $? -eq 0 ]
  then
    #git cat-file -p $1
    printf "%-21s" $(git cat-file -p $1)
  else
    #/bin/echo -n '-'
    printf "%-21s" '-'
  fi
}

catcat() {
  if [ -f $1 ]
  then
    grep '<<<<<<<' $1 > /dev/null 2> /dev/null         # files with merge conflicts start with "<<<<<<<"
    if [ $? -eq 0 ]
    then
      printf "%-21s" 'Merge Conflict' 
      #/bin/echo 'Merge Conf.'
    else
      #cat $1
      printf "%-21s" $(cat $1)
    fi
  else
    #/bin/echo -n '-'
    printf "%-21s" '-'
  fi
}

printRemoteFiles() {
  mkdir remotefiles
  cd remotefiles
  remoteOriginURL=$(git config --get remote.origin.url)
  git clone -q --depth 1 $remoteOriginURL > /dev/null 2> /dev/null
  if [ $? -eq 0 ]
  then
    repoNameWithDotGit=${remoteOriginURL##*/}
    repoName=${repoNameWithDotGit%.git}
    echo "origin/Head:    $(catcat ${repoName}/myfile) $(catcat ${repoName}/yourfile) $(catcat ${repoName}/otherfile)"
  else
    echo "origin/Head:    $(catcat x) $(catcat x) $(catcat x)"
  fi
  cd ..
  rm -rf remotefiles
}

gitlog() {
  echo "..........................................................................."
  echo "                myfile                yourfile               otherfile"
  printRemoteFiles
  echo "HEAD:           $(gitcat HEAD:myfile) $(gitcat HEAD:yourfile) $(gitcat HEAD:otherfile)"
  echo "Stage:          $(gitcat :myfile) $(gitcat :yourfile) $(gitcat :otherfile)"
  echo "Worktree:       $(catcat myfile) $(catcat yourfile) $(catcat otherfile)"
  echo "..........................................................................."
  git --no-pager log --decorate --oneline --graph --all
  echo "..........................................................................."
}

echoline() {
  echo "---------------------------------------------------------------------------"
}

# Define the character sequence used later on in printf-statements to draw a red line
RED='\033[0;31m'
NC='\033[0m' # No Color
REDLINE="${RED}---------------------------------------------------------------------------${NC}\n"

