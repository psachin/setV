#!/usr/bin/env bash
# setV - Light-weight Python virtual environment manager.
# Author: psachin.github.io/about
#
# License: GNU GPL v3, See LICENSE file
#
# Configure:
# Set `VIRTUAL_DIR_PATH` value to your virtual environments
# directory-path. By default it is set to '~/virtualenvs/'
#
# Usage:
# Added this line to your .bashrc or any local rc script.
# $ source /path/to/virtual.sh
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
# $ setv -l
#
# To create new virtual environment:
# $ setv -n new_virtualenv_name
#
# To delete existing virtual environment:
# $ setv -d existing_virtualenv_name
#
# To deactivate, type:
# $ deactivate

# TODO (Testing):
# - Create virtualenv with command something like: setv -n new_virt_name
# - Delete virtualenv with command something like: setv -d old_virt_name

# ChangeLog :
# Fri Apr 25 12:41:40 IST 2014: TAB completion
# Mon Nov 02 12:51:54 IST 2015: Create/delete virtual environment

# Path to virtual environment directory
VIRTUAL_DIR_PATH="$HOME/virtualenvs/"
LIST_OF_VIRTUALENVS=$(ls -l "${VIRTUAL_DIR_PATH}" | egrep '^d' | awk -F " " '{print $NF}')

function _setvcomplete_()
{
    # bash-completion
    local cmd="${1##*/}" # to handle command(s).
                         # Not necessary as such. 'setv' is the only command

    local word=${COMP_WORDS[COMP_CWORD]} # Words thats being completed
    local xpat='${word}'		 # Filter pattern. Include
					 # only words in variable '$names'
    local names=${LIST_OF_VIRTUALENVS} # Virtual environment names

    COMPREPLY=($(compgen -W "$names" -X "$xpat" -- "$word")) # 'compgen
							     # generates
							     # the
							     # results'
}

function _setv_help_() {
    # Echo help
    echo "Help: "
    echo -e "setv [-l] \t\t\t to list all virtual envs."
    echo -e "setv [Virtual_env_name] \t to set virtual env."
    echo -e "setv -n [New virtual_env_name] \t to create virtual env(NEW)."
    echo -e "setv -d [virtual_env_name] \t to delete existing virtual env(NEW)."
}

function _setv_create()
{
    if [ -z ${1} ];
    then
	echo "You need to pass virtual environment name"
	_setv_help_
    else
	echo "Creating new virtual environment with the name: $1"
	virtualenv -p $(which python) ${VIRTUAL_DIR_PATH}${1}
	# TODO: source ${VIRTUAL_DIR_PATH}
    fi
}

function _setv_delete()
{
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

function _setv_list() {
    echo -e "List of virtual environments you have under ${VIRTUAL_DIR_PATH}:\n"
    for virt in ${LIST_OF_VIRTUALENVS}
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
	    '-n') _setv_create ${2}
		;;

	    '-d') _setv_delete ${2}
		;;

	    '-l') _setv_list
		;;

	    *) if [ -d ${VIRTUAL_DIR_PATH}${1} ];
	       then
		   # Activate the virtual environment
		   source ${VIRTUAL_DIR_PATH}${1}/bin/activate
	       else
		   # Else throw an error message
		   echo "Sorry, you don't have any virtual environment with that name"
		   _setv_help_
	       fi
	       ;;
	esac
    fi
}

complete  -F _setvcomplete_ setv # call bash-complete. The compgen
				 # command accepts most of the same
				 # options that complete does but it
				 # generates results rather than just
				 # storing the rules for future use.
