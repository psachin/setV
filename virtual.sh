#!/usr/bin/env bash
# setV - Lightweight Python virtual environment manager.
# Author: Sachin (psachin) <iclcoolster@gmail.com>
# Author's URL: psachin.github.io/about
#
# License: GNU GPL v3, See LICENSE file
#
# Configure(Optional):
# Set `VIRTUAL_DIR_PATH` value to your virtual environments
# directory-path. By default it is set to '~/virtualenvs/'
#
# Usage:
# Manual install: Added below line to your .bashrc or any local rc script():
# ---
# source /path/to/virtual.sh
# ---
#
# Now you can 'activate' the virtual environment by typing
# $ setv <YOUR VIRTUAL ENVIRONMENT NAME>
#
# For example:
# $ setv rango
#
# or type:
# setv [TAB] [TAB]  (to list all virtual envs)
#
# To list all your virtual environments:
# $ setv --list
#
# To create new virtual environment:
# $ setv --new new_virtualenv_name
#
# To delete existing virtual environment:
# $ setv --delete existing_virtualenv_name
#
# To deactivate, type:
# $ deactivate

# Path to virtual environment directory
VIRTUAL_DIR_PATH="$HOME/virtualenvs/"

function _setvcomplete_()
{
    # Bash-autocompletion.
    # This ensures Tab-auto-completions work for virtual environment names.
    local cmd="${1##*/}" # to handle command(s).
                         # Not necessary as such. 'setv' is the only command

    local word=${COMP_WORDS[COMP_CWORD]} # Words thats being completed
    local xpat='${word}'		 # Filter pattern. Include
					 # only words in variable '$names'
    local names=$(ls -l "${VIRTUAL_DIR_PATH}" | egrep '^d' | awk -F " " '{print $NF}') # Virtual environment names

    COMPREPLY=($(compgen -W "$names" -X "$xpat" -- "$word")) # 'compgen
							     # generates
							     # the
							     # results'
}

function _setv_help_() {
    # Echo help/usage message
    echo "Usage: setv [OPTIONS] [NAME]"
    echo -e "NAME                       Activate virtual env."
    echo -e "-l, --list                 List all virtual envs."
    echo -e "-n, --new NAME             Create virtual env."
    echo -e "-d, --delete NAME          Delete existing virtual env."
}

function _setv_create()
{
    # Creates new virtual environment if ran with -n|--new flag
    if [ -z ${1} ];
    then
	echo "You need to pass virtual environment name"
	_setv_help_
    else
	echo "Creating new virtual environment with the name: $1"
	virtualenv -p $(which python) ${VIRTUAL_DIR_PATH}${1}
	echo "You can activate the environment by typing: setv ${1}"
    fi
}

function _setv_delete()
{
    # Deletes virtual environment if ran with -d|--delete flag
    # TODO: Refactor
    if [ -z ${1} ];
    then
	echo "You need to pass virtual environment name"
	_setv_help_
    else
	if [ -d ${VIRTUAL_DIR_PATH}${1} ];
	then
	    rm -rvf ${VIRTUAL_DIR_PATH}${1}
	else
	    echo "No virtual environment with name: ${1}"
	fi
    fi
}

function _setv_list()
{
    # Lists all virtual environments if ran with -l|--list flag
    echo -e "List of virtual environments you have under ${VIRTUAL_DIR_PATH}:\n"
    for virt in $(ls -l "${VIRTUAL_DIR_PATH}" | egrep '^d' | awk -F " " '{print $NF}')
    do
	echo ${virt}
    done
}

function setv() {
    # Main function
    if [ $# -eq 0 ];
    then
	_setv_help_
    else
	case "${1}" in
	    -n|--new) _setv_create ${2};;
	    -d|--delete) _setv_delete ${2};;
	    -l|--list) _setv_list;;
	    *) if [ -d ${VIRTUAL_DIR_PATH}${1} ];
	       then
		   # Activate the virtual environment
		   source ${VIRTUAL_DIR_PATH}${1}/bin/activate
	       else
		   # Else throw an error message
		   echo "Sorry, you don't have any virtual environment with the name: ${1}"
		   _setv_help_
	       fi
	       ;;
	esac
    fi
}

# Calls bash-complete. The compgen command accepts most of the same
# options that complete does but it generates results rather than just
# storing the rules for future use.
complete  -F _setvcomplete_ setv
