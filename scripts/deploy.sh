#!/bin/sh

## Script used to deploy after merging all the changes
## Description: Script used to deploy after merging all the changes
## Usage: Called from Git CLI
## Author : Bhoopesh Chauhan - Cognizant         Version :1.0  	Last Modified Date : 16/02/2016 


## Get status of the branch 
git status
echo started
## Prompt to choose whether to proceed to commmit or not
while true; do
    read -p "Do you wish to continue to commit (y/n) " yn
    case $yn in
        [Yy]* ) echo "Commit will begin";
                git add --all
                
				## Prompt to enter commit message
				read -p "Enter commit message: " cmtMsg
				git commit -m " $cmtMsg "
                git push
                break;;
        [Nn]* ) echo "Commit Process Aborted";exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
