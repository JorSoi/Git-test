#!/bin/bash

# -----------------------------------------------------------

# Author:        Andreas Soika
# Created:       06.04.2022
# Updated:       18.11.2022
# Version:       v7.0

# Description:   Git tutorial: demonstrating the most commen Git - Usecases

# Usage:         Start this script in a Git-bash terminal windows 
#                  within an empty directory

# Prerequisites: The Git-bash must be available and must be
#                  working with GitLab.

# History:	 v1.0:  First version published
#                v2.0:  Highly improved formatting/layout
#                v3.0:  Draft: added remote repo operation
#                v4.0:  revised table listing gitlog()
#                v5.0:  Added usecase for pulling and pushing
#                v6.0:  Improved the design
#                v7.0:  Added usecase without and with merge conflicts

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
  mkdir .remotefiles 2> /dev/null
  cd .remotefiles
  remoteOriginURL=$(git config --get remote.origin.url)
  repoNameWithDotGit=${remoteOriginURL##*/}
  repoName=${repoNameWithDotGit%.git}

  if [ -d $repoName ]
  then
    cd $repoName
    $(git pull > /dev/null  2> /dev/null)
    cd ..
  else
    git clone -q --depth 1 $remoteOriginURL > /dev/null 2> /dev/null
  fi

  if [ $? -eq 0 ]
  then
    echo "origin/HEAD:    $(catcat ${repoName}/myfile) $(catcat ${repoName}/yourfile) $(catcat ${repoName}/otherfile)"
  else
    echo "origin/HEAD:    $(catcat x) $(catcat x) $(catcat x)"
  fi
  cd ..
  #rm -rf .remotefiles
}

printHEADptr() {
  a=$(git log --oneline --decorate HEAD -1)
  #echo $a
  b=${a#*\(}
  #echo $b
  c=${b%\)*}
  #echo $c
  d=${c%%,*}
  #echo $d
  e=${d/ -> /->}
  printf "%-15s" ${e}:
}

gitlog() {
  echo "..........................................................................."
  echo
  echo "                myfile                yourfile              otherfile"
  printRemoteFiles
  echo "$(printHEADptr) $(gitcat HEAD:myfile) $(gitcat HEAD:yourfile) $(gitcat HEAD:otherfile)"
  echo "Stage:          $(gitcat :myfile) $(gitcat :yourfile) $(gitcat :otherfile)"
  echo "Worktree:       $(catcat myfile) $(catcat yourfile) $(catcat otherfile)"
  echo
  echo "..........................................................................."
  echo
  git --no-pager log --decorate --oneline --graph --all
  echo
  echo "..........................................................................."
}

echoline() {
  echo "---------------------------------------------------------------------------"
}

# Define the character sequence used later on in printf-statements to draw a red line
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
REDLINE="${RED}---------------------------------------------------------------------------${NC}\n"
BLUELINE="${BLUE}---------------------------------------------------------------------------${NC}\n"

rm -rf remotefiles

clear
echo
echo "==========================================================================="
echo "                                                             Intro  1/3    "
echo " Learning Git Basics "
echo
echo " A shell script based Git-tutorial by Andreas Soika "
echo
echo "==========================================================================="
read -p "Press enter to continue"





clear
echo
echo "==========================================================================="
echo "                                                             Intro  2/3    "
echo " How to use this tutorial script:                                          "
echo "                                                                           "
echo "    1.) Create your own fork from the original 'tws-git' project:          "
echo "        (make sure, your fork resides in your personal namespace)          "
echo "                                                                           "
echo "        original:                                                          "
echo "           https://gitlab.devops.telekom.de/net4f/a4u/tws-git              "
echo "                                                                           "
echo "        fork    :                                                          "
echo "           https://gitlab.devops.telekom.de/max.mayer/tws-git-mmayer       "
echo "                                                                           "
echo "    2.) Clone your fork to your own local machine, e.g.:                   "
echo "        git clone git@gitlab.devops.telekom.de:max.mayer/tws-git-mmayer.git"
echo "                                                                           "
echo "    3.) Open 2 unix-based terminal windows and one browser window:         "
echo "                                                                           "
echo "             - one terminal to run the present gitdemo.sh tutorial         "
echo "                                                                           "
echo "             - another terminal to try out the learned commands            "
echo "               (run 'source gitlog.sh' to get function 'gitlog')           "
echo "                                                                           "
echo "             - the third window is a  browser window with this cheat sheet:"
echo "               https://marklodato.github.io/visual-git-guide/index-en.html "
echo "                                                                           "
echo "    4.) Start 'gitdemo.sh' in your first terminal and step through         "
echo "        the usecases. In parallel, you can experiment with git in the      "
echo "        second terminal (especially with file 'otherfile').                "
echo "                                                                           "
echo "==========================================================================="
read -p "Press enter to continue"
echo
echo





clear
echo
echo "==========================================================================="
echo "                                                              Intro 3/3    "
echo "                      OVERVIEW - TABLE OF CONTENT                          "
echo "                                                                           "
echo " This script will show how to solve common Git usecases like:              "
echo "                                                                           "
echo "  1. Git-Initialization - setting up a local Git repo                      "
echo "  2. Put files under Git control - do your first commit                    "
echo "  3. Creating branches - working in a separate stream                      "
echo "  4. Rolling back files from the index - fix your mistakes                 "
echo "  5. Rolling back files from the local repository                          "
echo "  6. Rolling back files from old commits                                   "
echo "  7. Compare files between working dir, index, commits                     "
echo "  8. Commit all files from the index into the main branch                  "
echo "  9. Working on a branch - checkout branch and commit changes              "
echo " 10. Merging - merge your branch into the main branch                      "
echo " 11. Link a local repo to a remote servers repo and sync these repos       "
echo " 12. Pushing changes to the remote repository                              "
echo " 13. Teamwork - pushing changes simultaneously without merge conflicts     "
echo " 14. Teamwork - pushing changes simultaneously and solving merge conflicts "
echo
echo "==========================================================================="
read -p "Press enter to continue"




clear
echo
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 1:  We want to put our project-files in a certain directory under   "
echo "            control of Git in order to be able to:                          "
echo "                                                                            "
echo "            - track changes                                                 "
echo "            - recover old versions of your files                            "
echo "            - work on different features of your project in parallel        "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Let's initialize a local git-repository (no remote server yet) "
echo "                                                                           " 
echo "            (Please note: if the current directory is already initialized  "
echo "                          (e.g. if it was cloned from the GitLab server)   "
echo "                          this step will be skipped here.                  "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"
# We use set -x to switch on printing of commands in this bash skript
if [ ! -d .git ]
then
  printf $BLUELINE
  printf $BLUE
  set -x
  git init
  { set +x; } 2> /dev/null
  printf $NC
  printf $BLUELINE
else
  echo
  echo
  printf $BLUELINE
  printf $BLUE
  echo "           A directory .git already exists. It indicates, that the       "
  echo "           the current directory is already under control of Git.        "
  echo "           (e.g. the directory was created by cloning our repository)    "
  echo "           That's why Git initialization can be skipped.                 "
  echo "           (otherwise we would have to do 'git init' for initialization) "
  printf $NC
  printf $BLUELINE
fi
{ set +x; } 2> /dev/null
# We use set +x to switch off printing of commands in this bash skript
# In order to avoid "set +x" being printed (as set -x is still turned
# on at this moment), we have to use this tricky expression:
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            In order to exclude some files from being checked in to        "
echo "            the repository, we create a .gitignore file and put all        "
echo "            filenames to be excluded in this .gitignore file.              "
echo "            Regex-patterns are also allowed.                               "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


# We use set -x to switch on printing of commands in this bash skript
echo
echo
printf $BLUELINE
printf $BLUE
echo "gitdemo.sh"      >  .gitignore
echo '+ echo "gitdemo.sh" >  .gitignore'
echo "gitlog.sh"      >>  .gitignore
echo '+ echo "gitlog.sh" >  .gitignore'
echo "hide.sh"        >> .gitignore
echo '+ echo "hide.sh"     >> .gitignore'
echo "*.swp"          >> .gitignore
echo '+ echo "*.swp"       >> .gitignore'
echo ".remotefiles/"  >> .gitignore
echo '+ echo ".remotefiles/"  >> .gitignore'
set -x
cat .gitignore
git add .gitignore
{ set +x; } 2> /dev/null
printf $BLUE
printf $BLUELINE
# We use set +x to switch off printing of commands in this bash skript
# In order to avoid "set +x" being printed (as set -x is still turned
# on at this moment), we have to use this tricky expression:
read -p "Press enter to continue"




echo
echo
echo
echo
echo
clear
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 2:  We want to create 3 files (myfile, yourfile, otherfile)         "
echo "            and save these files in our local git-repository in order       "
echo "            to be able to recover the files later on when needed            "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Create 3 files in your working dir                             "
echo "            (filenames: myfile, yourfile, otherfile)                       "
echo "            (we will use these files in the rest of this tutorial          "
echo "             to experiment with git                               )        "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo 1 > myfile
echo '+ echo 1 > myfile'
echo 1 > yourfile
echo '+ echo 1 > yourfile'
echo 1 > otherfile
echo '+ echo 1 > otherfile'
printf ${NC}
printf ${BLUELINE}


echo
echo
echo "---------------------------------------------------------------------------"
echo "Small breakout:                                                            "
echo "                                                                           "
echo "            In order to see, how our commands affect the 3 files           "
echo "            and how commit history is affected, we print a kind of         "
echo "            'status overview' using a shell function 'gitlog'.             "
echo "                                                                           "
echo "            'gitlog' is no native shell command, it is provided by         "
echo "            the author of this tutorial via file gitlog.sh.                "
echo "                                                                           "
echo "            You can use 'gitlog' also as a stand-alone function:           "
echo "            just execute 'source gitlog.sh' once to be able to use the     "
echo "            function 'gitlog' in your current shell - you will love it\!   " 
echo "                                                                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo "+ gitlog"
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Add the 3 files 'myfile', 'yourfile', 'otherfile'              "
echo "            to our index (also called "stage" or "staging area").          "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"
echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git add myfile yourfile otherfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Do your first commit (comment it 'version 1')  "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"

echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git commit -m "version 1"
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"

# echo
# echo "---------------------------------------------------------------------------"
# echo "That's how the commit log looks like:"
# echo "---------------------------------------------------------------------------"
# read -p "Press enter to continue"
# set -x
# git --no-pager log --graph --decorate --all
# { set +x; } 2> /dev/null
# read -p "Press enter to continue"


echo
echo
echo
echo
echo
clear
#echo "---------------------------------------------------------------------------"
printf $REDLINE
echo "Usecase 3:  Later on, you need to develop a feature without interfering     "
echo "            with other project members. Take some precautions now.          "
printf $REDLINE
#echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            A branch can be used to separate your work on a feature        "
echo "            from the rest of the development. So let's create a           "
echo "            feature-branch named 'b1' (we will use this branch a bit       "
echo "            later within the actual tutorial)                              "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"

echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git branch b1
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Print the actual commit log to check the main and b1 pointers: "
echo "            (please note: HEAD is still pointing to main)"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager log --graph --decorate --all
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            To simulate some work in the main branch, we change the content"
echo "            of myfile (1 -> 2)"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo 2 > myfile
echo '+ echo 2 > myfile'
printf ${NC}
printf ${BLUELINE}
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            ... and we stage myfile"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git add myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            ... and finally, we commit the change to our local repo        "
echo "            (please note: the changes are NOT stacked on top of branch b1  "
echo "             but on top of branch main\!                                 ) "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git commit -m "version 2" 
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo
echo
echo
clear
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 4:  We made a mistake in our working directory.                     "
echo "            Fortunately, the mistake is not staged yet                      "
echo "                                                                            " 
echo "            How do we recover/replace a modified file                       "
echo "            (or even all modified files) in our working                     "
echo "            directory by the corresponding                                  "
echo "            file/s from our index?                                          "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            First, let us simulate the mistake, by changing  2 files -     "
echo "            namely \"myfile\" and \"yourfile\"                             "
echo "            (writing \"0\" in these files symbolizes an error here)         "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"

echo
echo
printf ${NC}
printf ${BLUELINE}
echo "0" > myfile
echo '+ echo "0" > myfile'
echo "0" > yourfile
echo '+ echo "0" > yourfile'
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Now, lets recover file 'myfile' from our index                 "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"

echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git checkout -- myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Now, let us recover all (modified or even deleted) files from  "
echo "            our index (new files in our working dir remain untouched).     "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"

echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git checkout -- .
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo
echo
echo
clear
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 5:  Bad things happen - we do make a mistake during staging:       "
echo "            Accidentally we staged a wrong version of myfile to the index. "
echo "                                                                           "
echo "            Luckily, we did not commit the erroneous file yet.             "
echo "            And - even more important - we do not want to ship this        "
echo "            error prone version/content to our next commit.                "
echo "                                                                           "
echo "            => myfile in index must be replaced with an updated            "
echo "               version of myfile from our working dir.                     "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            First, let make the mistake on purpose:                        "
echo "            Accidentally, we write a '0' to file 'myfile'                  "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo "0" > myfile
echo '+ echo "0" > myfile'
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Then, we make another mistake on purpose:                      "
echo "            We stage 'myfile' accidentally ...:                            "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git add myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo
echo "---------------------------------------------------------------------------"
echo "            Now, let's correct the file content (of myfile)               "
echo "            in the working dir:                                            "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo 3 > myfile
echo '+ echo 3 > myfile'
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Finally, replace the file (myfile) in the index with the       "
echo "            corrected version from your working dir:                       "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git add myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
gitlog
read -p "Press enter to continue"



echo
echo
echo
echo
echo
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 6:  Bad things happen again - imagine, we had to recover a file     "
echo "            (myfile) from an old commit:                                    "
echo "                                                                           "
echo "            Recovery shall happen in our index and our working directory    "
echo "		  simultaneously.                                                 "
echo "                                                                           "
echo "            => myfile in index & working dir must be replaced by a          "
echo "               version of myfile from our last commit                       "
echo "               (bonus: recover myfile from the last but one commit)         "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            First, let's do the mistake on purpose in file 'myfile':       "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo "0" > myfile
echo '+ echo "0" > myfile'
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Next, we stage this file (myfile) accidentally ...:            "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git add myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            At this point, we face the following situation:                "
echo "		                                                                 "
echo "            There is no chance, to recover myfile from the index           "
echo "            because myfile in the index is false too.                      "
echo "            So we have to recover myfile from our local repository.        "
echo "		                                                                 "
echo "            The usual method is to replace myfile in the index and in      "
echo "            the working dir simulaneously by the recovered version from    "
echo "            our last commit:                                               "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"

echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git checkout HEAD -- myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            We find out, that the last commit does not contain the         "
echo "            expected version of myfile and decide to recover from the      "
echo "            last but one commit:                                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git checkout HEAD~1 -- myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"





echo
echo
echo
echo
echo
clear
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 7:  We want to compare our file (myfile) between the different      "
echo "            level of your git workflow (workdir, index, repo):              "
echo "                                                                            "
echo "            7a) Compare file in working dir <-> file in index               "

echo "            7b) Compare file in working dir <-> file in last commit         "
echo "            7c) Compare file in working dir <-> file in different branch    "
echo "            7d) Compare file in index       <-> file in last commit         "
echo "            7e) Compare all files in workdir<-> correspondig files in index "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Preparation: store different versions of 'myfile' and          "
echo "            'yourfile' in working  directory, index and repo:              "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo 3 > myfile
echo '+ echo 3 > myfile'
echo 3 > yourfile
echo '+ echo 3 > yourfile'
set -x
git add myfile yourfile
{ set +x; } 2> /dev/null
echo 4 > myfile
echo '+ echo 4 > myfile'
echo 4 > yourfile
echo '+ echo 4 > yourfile'
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            7a) Compare 'myfile' in working dir <-> 'myfile' in index      "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager diff myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            7b) Compare file in working dir <-> file in last commit        "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager diff HEAD myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo
echo "---------------------------------------------------------------------------"
echo "            7c) Compare file in working dir "
echo "                    <-> file in a different branch (here: b1)"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager diff b1 myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            7d) Compare file in index "
echo "                    <-> file in last commit"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager diff --cached myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            7e) Compare all files in working dir "
echo "                    <-> correspondig files in index"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager diff
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"





echo
echo
echo
echo
echo
clear
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 8:  We want to commit all files from the index into the main branch."
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Simply execute a commit with a decent comment:                 "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git commit -m "version 3"
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            That's how the commit log looks like"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager log --graph --decorate --all
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo
echo
echo
clear
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 9:  We want to work on another part of our project, starting       "
echo "            from a code revision available in branch 'b1'                  "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            At first, we have to switch from main to branch b1:            "
echo "            This time, not everything works as smooth as we expect.        "
echo "            ( see what happens, if either index or working dir is not   )  "
echo "            ( clean - that means: they contain modifications, which are )  "
echo "            ( neither stashed nor committed                             )  "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git checkout b1
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Uhhh - the branch checkout failed.                            "
echo "             In such a case it's always a good idea to consult 'git status'"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git status
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Since our previous command failed, we will try again ...       "
echo "            But first, we check in our latest changes from working dir     "
echo "            into main branch.                                              "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git add .
git commit -m "version 4"
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            As there are no uncommitted changes any more, we can switch    "
echo "            to branch b1 now:                                              "
echo "            (please note: index and working dir are updated to represent   "
echo "                          the state of b1)                                 "
echo "            (please note: new, untracked files in working dir are not      "
echo "                          deleted)                                         "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git checkout b1
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Now we can do some work in our files in the working dir  ...:"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo 1.1 > myfile
echo '+ echo 1.1 > myfile'
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            ... add these changes to the index:"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git add .
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            ... and commit them to  branch b1:"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git commit -m "version 1.1"
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            That's how the commit log looks like                           "
echo "            (please note: HEAD pointer is pointing to branch-pointer b1)   "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager log --graph --decorate --all
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"



echo
echo
echo
echo
echo
clear
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 10: Our work on b1 reached a stable stage and shall now be          "
echo "            merged into the main branch                                     "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            At first, we have to switch from branch b1 to main branch:     "
echo "            ( note: if we want to merge *INTO* the main branch, we have    "
echo "                    to check out main first and subsequently start the     "
echo "                    merging process )                                      "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git checkout main
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            That's how the commit log looks like at this stage:            "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager log --graph --decorate --all
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Start merging now:                                             "
echo "                                                                           " 
echo "            (please note: in most cases of day-to-day work, there happen   "
echo "                          to be no conflicts - however, in our case the    "
echo "                          versions of 'myfile' differ between:             "
echo "                                                                           " 
echo "                            -  b1 and the common ancestor of b1 and main   "
echo "                                  AND between                              "
echo "                            -  main and the common ancestor of b1 and main "
echo "                                                                           " 
echo "                          In such a case, git detects a merge conflict,    "
echo "                          which has to be solved manually.                )" 
echo "                                                                           " 
echo "            (please note: in case of file 'yourfile' there is no conflict  "
echo "                          because the version of yourfile was not          "
echo "                          modified in branch b1.                          )"
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git merge b1
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Please note: the last merge command resulted in a              "
echo "            merge conflict. No commit happened due to the merge conflict.  "
echo "                                                                           "
echo "            Files with merge conflicts are listed and the conflict-        "
echo "            related portions within these files are marked in a special    "
echo "            way (see 'myfile' in our example).                             "
echo "                                                                           "
echo "            That's how the content of 'myfile' looks like                  "
echo "            after the merge command was executed:                          "
echo "                                                                           " 
echo "            ( the upper section in 'myfile' represents the content of      "
echo "               the HEAD version while the lower section represents the     "
echo "               content of the b1 version )                                 "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
cat myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            That's how the git status looks like                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git status
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            That's how the commit log looks like                           "
echo "            (please note: no new commit has happened as the merge conflict "
echo "             is still unsolved)                                            "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager log --graph --decorate --all
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            We have to edit the affected file (myfile) and                 "
echo "            resolve the conflict manually:                                 "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo 4x > myfile
echo '+ echo 4x > myfile'
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            In the next step, we have to add the affected file (myfile)    "
echo "            to the index:                                                  "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git add myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            That's how the latest git status looks like:                   "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git status
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            A final commit will finish and end the failed merge:           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git commit -m "version 4x - merged b1 into main with conflict solving"
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            That's how the git status looks like                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git status
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            That's how the full commit log looks like                      "
echo "            (please note: no new commit has happened as the merge conflict "
echo "             is still unsolved)                                            "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager log --graph --decorate --all
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo
echo
echo
clear
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 11:  We want to synchronize our local git repository with           "
echo "             a GitLab server - ending up with 2 repos - one local           "
echo "             GIT repo and one remote GIT repo.                              "
echo
echo "             As a result, we shall be able to use git push/pull:            "
echo "             'git push' will do:   local repo --sync--> remote repo         "
echo "             'git pull' will do:   local repo <--sync-- remote repo         "
echo
echo "             Please note: 'git pull' will only replace files in your        "
echo "                          repo/index/working if there exists a newer        "
echo "                          version of these files in the remote repo.        "
echo "                          It's kind of fetching the remote files            "
echo "                          into a separate area on your local machine        "
echo "                          followed by merging this separate area into       "
echo "                          your repo/index/working dir.                      "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            At first, we have to create an empty (!) new project/repo      "
echo "            on the GitLab Server.                                          "
echo
echo "            If you do have already a remote repo and the current working   "
echo "            dir was created by cloning, you can ignore the next steps.     "
echo "            Just hit enter until you end up at the next usecase.           "
echo
echo "            If not, make sure to memorize the URL of your empty GitLab-    "
echo "            project/repository: You will find this URL at the top          "
echo "            of your GitHub repositoriy's Quick Setup page:                 "
echo "            Click to copy the remote repository URL (choose the            "
echo "            http-address if you do not have ssh-access).                   "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Next, we have to link the memorized URL of our remote repo     "
echo "            to an 'alias' called 'origin' in our local Git configuration.  "
echo "            'Origin' is the remote repo where your local repo will be      "
echo "            pushed/synced to, e.g.:                                        "
echo ""
echo "               git remote add origin https://g.tel.de/gitlab/a.s/demo2.git "
echo ""
echo "            # Be careful:                                                  "
echo "            # Mac/LMD-Users do NOT take the command which is displayed by  "
echo "            # GitLab after you created an empty repo on the GitLab server \- "
echo "            # it is only valid if you have ssh-access to your GitLab server."
echo "            # That is why LMD-users choose the http://... URL here as they  "
echo "            # work via http. on GitLab "
echo "            # If you accidentally added a wrong URL for your remote repo,  "
echo "            # you can remove the link via: 'git remote remove origin'      "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"



echo
echo
# If we already do have a remote.origin.url
remoteOriginURL=$(git config --get remote.origin.url)
while [ -z $roURL ]
do
 printf ${BLUELINE}
 printf ${BLUE}
 read -p "Enter remote git URL [$remoteOriginURL]: " roURL
 # roURL will be set, if $remoteOriginURL is available and user hits enter
 roURL=${roURL:=$remoteOriginURL}
done
echo "Adapt the following command to point to your remote repo:"
set -x
git remote add origin $roURL
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            Verify the new remote URL                                      "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"
printf ${BLUELINE}
printf ${BLUE}
set -x
git remote -v
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Create an upstream (tracking) reference, which eases later    "
echo "             usage of commands link 'git pull' or 'git push' - you do not  "
echo "             have to specify the target for those commands.                "
echo "             Otherwise you had to do 'git push origin main' resp.        "
echo "             'git pull origin main'                                      "
echo "             Take care: the following command will not only create a       "
echo "             tracking reference, but also push content to the server       "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${NC}
printf ${BLUELINE}
set -x
git push -u origin main   
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"





clear
echo
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 12:  We want to do some changes and push that changes to the        "
echo "             remote repository, in order to share our work with the team    "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             At first, we apply changes to our local files 'myfile'        "
echo "             and yourfile                                                  "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo 5 > myfile
echo 5 > yourfile
echo '+ echo 5 > myfile'
echo '+ echo 5 > yourfile'
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Next, we stage and commit our changes to our local repo       "
echo "             (This time, we do staging and committing in one step          "
echo "              using the commit commands '-a' option.)                      "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git commit -a -m "version 5"
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Finally, we push our changes to the remote repo.              "
echo "             (i.e.: we sync our local repo with the remote one)            "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git push
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "            That's how the full commit log looks like in this stage        "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager log --graph --decorate --all
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"





clear
echo
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 13:  A member of our team applied some changes to 'otherfile' and   "
echo "             pushed these changes to the remote repo.                       "
echo "                                                                           "
echo "             Simultaneously, we apply changes to 'myfile' on our local      "
echo "             machine.                                                       "
echo "                                                                           "
echo "             We want to push our changes to the remote repo without         "
echo "             overwriting our colleagues changes.                            "
echo "                                                                            "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             In order to 'simulate' our colleagues changes, we log into    "
echo "             GitLab via browser, change file 'otherfile' (on behalf of     "
echo "             our colleague) and commit this change:                        "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo "             Here are the single steps to simulate your colleages changes: "
echo "                                                                           "
echo "             1. Log into GibLab                                            "
echo "                                                                           "
echo "             2. Search for your project/repo (e.g. 'tws-git-asoika')     "
echo "                                                                           "
echo "             3. Enter the project/repo and open the repos file list:       "
echo "                  - left menue 'Repository' > 'Files'                      "
echo "                                                                           "
echo "             4. Change 'otherfile': enter number '7.1' in line 1:          "
echo "                  - click on file 'otherfile' > press 'Open in Web IDE'    "
echo "                     and apply your change.                                "
echo "                                                                           "
echo "             5. Finally, commit this change. Do not forget - this change   "
echo "                represents your colleagues change. We are acting on        "
echo "                behalf of him at this point.                               "
echo "                  - click button 'Create commit...'                        "
echo "                  - fill the 'commit message' field: type 'Version 7.1'    "
echo "                  - check 'Commit to main branch'                          "
echo "                  - check in your change by pressing Button 'Commit'       "
echo "                                                                           "
echo "             At this point, we simulated a colleagues commit into our      "
echo "             remote repo. Please note: this commit/change is not yet       "
echo "             incorporated in our own local repo\!                          "
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             In the next step, we make a change in our local file          "
echo "             'myfile' - as requested in the usecase.                       "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo 7.2 > myfile
echo '+ echo 7.2 > myfile'
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Next, we stage and commit our changes to our local repo       "
echo "             (Once again, we do staging and committing in one step        "
echo "              using the commit commands '-a' option.)                     "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git commit -a -m "version 7.2"
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Finally, we try to push our changes to the remote repo.       "
echo "             Please note: at this time, we normally do not know anything   "
echo "             about our colleagues change.                                  "
echo "             (Please note the conflict message returned by git!)           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git push
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             At this point we realize: git refuses to push our last        "
echo "             commit to the remote repo. This usually happens, if the       "
echo "             remote repo incorporates changes, which we do not have        "
echo "             (i.e. a commit happend in the remote repo while we were       "
echo "             working on our local code/files)                              "
echo "                                                                           "
echo "             Since we do not know, what happened to the remote repo,       "
echo "             we decide to pull the remote changes - yet without merging    "
echo "             them into our actual codebase.                                "
echo "                                                                           "
echo "             (Please note, how the git log changes after the fetch)        "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git fetch
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Normally, you do not look at git log after every single       "
echo "             git command, as we do here.                                   "
echo "                                                                           "
echo "             Most of the time, you ask 'git status', to find out, what's   "
echo "             going on.                                                     "
echo "                                                                           "
echo "             Read the message carefully!                                   "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git status
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             From 'git status' we learned:                                 "
echo "             Your branch and 'origin/main' have diverged.                  "
echo "                                                                           "
echo "             That's the reason, why we are not allowed to push our         "
echo "             commit to the remote repo.                                    "
echo "                                                                           "
echo "             In order to do so, we have to incorporate/merge the remote    "
echo "             changes into your codebase first.                             "
echo "             The previous 'git status' command delived some valuable help  "
echo "             what to do ...                                                "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git pull
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             The previous 'git pull' did not only pull down the latest     "
echo "             changes from the remote repo, it also merged these changes    "
echo "             into our codebase (in working directory in our index and      "
echo "             even in our latest commit in our local repo).                 "
echo "                                                                           "
echo "             As our colleague and we ourselves did not change the same     "
echo "             files, we did not see any merge-conflicts in this scenario.   "
echo "                                                                           "
echo "             (Such merge conflicts will be dealt with later on       )     "
echo "             (in this tutorial, as we will demonstrate a usecase,    )     "
echo "             (where our collegue and we ourselves edit the same file )     "
echo "                                                                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git pull
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Although the remote changes are included in your work         "
echo "             by now (indeed, they are included in the working tree,        "
echo "             in the index and in the last commit of our local repo)        "
echo "             the updated  last commit from our local repo is               "
echo "             not synced to the remote repo yet.                            "
echo "             A 'git status' will reveal that:                              "
echo "                                                                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git status
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Due to our last pull command, our local commit-history is in  "
echo "             sync with the remote servers commit history - just our very   "
echo "             last commit resides only in our local commit history and is   "
echo "             not available on the server yet.                              "
echo "                                                                           "
echo "             Having reached this status, we are ready now to do the last   "
echo "             step: we can push the local commit to our server ...          "
echo "                                                                           "
echo "             (Note: our local commit was updated by the last pull command) "
echo "             (      and is based now on the last but one commit, which   ) "
echo "             (      itselves happens to be in sync with the remote server) "
echo "                                                                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git push
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             That's how the full commit log looks like at this stage       "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager log --graph --decorate --all
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"



clear
echo
#echo "==========================================================================="
printf $REDLINE
echo "Usecase 14:  Similar situation like in the last usecase, but this time      "
echo "             our teammate and we ourselves edit the same file: myfile.      "
echo "                                                                            "
echo "             Our teammate applied these changes to 'myfile' and pushed      "
echo "             these changes to the remote repo.                              "
echo "                                                                            "
echo "             Simultaneously, we apply changes to 'myfile' on our local      "
echo "             machine.                                                       "
echo "                                                                            "
echo "             We want to push our changes to the remote repo too.            "
echo "                                                                            "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             In order to 'simulate' our colleagues changes, we log into    "
echo "             GitLab via browser, change file 'myfile' (on behalf of        "
echo "             our colleague) and commit this change:                        "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo "             Here are the single steps to simulate your colleages changes: "
echo "                                                                           "
echo "             1. Log into GibLab                                            "
echo "                                                                           "
echo "             2. Search for your project/repo (e.g. 'tws-git-asoika')       "
echo "                                                                           "
echo "             3. Enter the project/repo and open the repos file list:       "
echo "                  - left menue 'Repository' > 'Files'                      "
echo "                                                                           "
echo "             4. Change 'myfile': enter number '8.1' in line 1:             "
echo "                  - click on file 'otherfile' > press 'Open in Web IDE'    "
echo "                     and apply your change.                                "
echo "                                                                           "
echo "             5. Finally, commit this change. Do not forget - this change   "
echo "                represents your colleagues change. We are acting on        "
echo "                behalf of him at this point.                               "
echo "                  - click button 'Create commit...'                        "
echo "                  - fill the 'commit message' field: type 'Version 8.1'    "
echo "                  - check 'Commit to main branch'                          "
echo "                  - check in your change by pressing Button 'Commit'       "
echo "                                                                           "
echo "             At this point, we simulated a colleagues commit into our      "
echo "             remote repo. Please note: this commit/change is not yet       "
echo "             incorporated in our own local repo\!                          "
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             In the next step, we make a change in our local file          "
echo "             'myfile' - as requested in the usecase.                       "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
echo 8.2 > myfile
echo '+ echo 8.2 > myfile'
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Next, we stage and commit our changes to our local repo       "
echo "             (Once again, we do staging and committing in one step        "
echo "              using the commit commands '-a' option.)                     "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git commit -a -m "version 8.2"
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Finally, we try to push our changes to the remote repo.       "
echo "             Please note: at this time, we normally do not know anything   "
echo "             about our colleagues change.                                  "
echo "             (Please note the conflict message returned by git!)           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git push
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             At this point we realize: git refuses to push our last        "
echo "             commit to the remote repo. This usually happens, if the       "
echo "             remote repo incorporates changes, which we do not have        "
echo "             (i.e. a commit happend in the remote repo while we were       "
echo "             working on our local code/files)                              "
echo "                                                                           "
echo "             Since we do not know, what happened to the remote repo,       "
echo "             we decide to pull the remote changes - yet without merging    "
echo "             them into our actual codebase.                                "
echo "                                                                           "
echo "             (Please note, how the git log changes after the fetch)        "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git fetch
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Normally, you do not look at git log after every single       "
echo "             git command, as we do here.                                   "
echo "                                                                           "
echo "             Most of the time, you ask 'git status', to find out, what's   "
echo "             going on.                                                     "
echo "                                                                           "
echo "             Read the message carefully!                                   "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git status
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             From 'git status' we learned:                                 "
echo "             Your branch and 'origin/main' have diverged.                  "
echo "                                                                           "
echo "             That's the reason, why we are not allowed to push our         "
echo "             commit to the remote repo.                                    "
echo "             Otherwise we would end up in a situation, where we have       "
echo "             two commits (both belonging to branch 'main') with the        "
echo "             same parent commit - thus splitting the main-branch into      "
echo "             two main branches. That's not allowed.                        "
echo "                                                                           "
echo "             Whatever commit we push to the remote server                  "
echo "             the HEAD-commit of the remote server must be the parent       "
echo "             of our commit which is going to be pushed to the server.      "
echo "                                                                           "
echo "             In order to achive that, we have to incorporate/merge         "
echo "             the remote changes into your codebase first.                  "
echo "                                                                           "
echo "             The previous 'git status' command delived some valuable help  "
echo "             what to do ...                                                "
echo "                                                                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git pull
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             The previous 'git pull' did not only pull down the latest     "
echo "             changes from the remote repo, it also tried to merge these    "
echo "             changes into our codebase (in working directory in our index  "
echo "             and even in our latest commit in our local repo).             "
echo "                                                                           "
echo "             As our colleague and we ourselves did change the same         "
echo "             files, we do see merge-conflicts now (bad luck ...).          "
echo "                                                                           "
echo "             At least - git gave us some hints, what to do next ...        "
echo "             We follow these instructions and resolve the merge            "
echo "             conflict in 'myfile' first:                                   "
echo "                                                                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
echo 8.x > myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             A look at 'git status' is always a good idea:                 "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git status
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             From the previous 'git status' we can see: the merge          "
echo "             (actually, it's not a merge, but a rebase) is still in        "
echo "             progress.                                                     "
echo "                                                                           "
echo "             Our next step is to add the file with the fixed confliced     "
echo "             ('myfile') to the index/stage:                                "
echo "                                                                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git add myfile
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             A look at 'git status' is always a good idea:                 "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git status
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             To finish the merge (... well, it's a rebase), we have        "
echo "             to follow git's instruction further on by continuing the      "
echo "             rebase (please edit the rebase-comment to your needs,         "
echo "             save it and close the editor to continue):                    "
echo "                                                                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
GIT_EDITOR=true git rebase --continue
{ set +x; } 2> /dev/null
echo "# please note: the 'GIT_EDITOR=true' is just to suppress the git-comment editor"
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"

echo
echo
echo "---------------------------------------------------------------------------"
echo "             Due to our last rebase command, our local commit-history is in"
echo "             sync with the remote servers commit history - just our very   "
echo "             last commit resides only in our local commit history and is   "
echo "             not available on the server yet.                              "
echo "                                                                           "
echo "             Having reached this status, we are ready now to do the last   "
echo "             step: we can push the local commit to our server ...          "
echo "                                                                           "
echo "             (Note: our local commit was updated by the last pull command) "
echo "             (      and is rebased now on the previous commit, which     ) "
echo "             (      itselves happens to be in sync with the remote server) "
echo "                                                                           "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git push
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
echo
gitlog
read -p "Press enter to continue"


echo
echo
echo "---------------------------------------------------------------------------"
echo "             Congratulations - we solved a difficult merge conflict\!      "
echo "             That's how the full commit log looks like at this stage       "
echo "---------------------------------------------------------------------------"
read -p "Press enter to continue"


echo
echo
printf ${BLUELINE}
printf ${BLUE}
set -x
git --no-pager log --graph --decorate --all
{ set +x; } 2> /dev/null
printf ${NC}
printf ${BLUELINE}
read -p "Press enter to continue"


clear
echo
#echo "==========================================================================="
printf $REDLINE
echo "                                                                            "
echo "THE END:     We reached the end of our script based tutorial.               "
echo "             Hope you enjoyed the usecase-driven approch and                "
echo "             hope you learned some basic git commands.                      "
echo "                                                                            "
echo "             You can find tons of material about Git in the                 "
echo "             internet. Some carefully selected links to extra-              " 
echo "             ordinary good sites are listed in section 'References'         "
echo "             in the handout document 'Workshop-Git.adoc'.                   "
echo "                                                                            "
echo "             Kind regards                                                   "
echo "                                                                            "
echo "             Andreas                                                        "
echo "                                                                            "
echo "                                                                            "
echo "    PS.:     Found typos, errors, mistakes, improveable sections            "
echo "             in this tutorial?  You could do me a great favour, if          "
echo "             you open your own branch in the original project               "
echo "             'tws-git', apply your changes and commit them into             "
echo "             your branch. Finally, please send me a merge request           "
echo "             an I will revise and merge your changes into the project.      "
echo "                                                                            "
printf $REDLINE
#echo "==========================================================================="
read -p "Press enter to continue"

