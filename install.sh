# #!/usr/bin/env bash
# Installation script for setV
#
# License: GNU GPL v3, See LICENSE file
#

# TODO: define colors
BOLD_GREEN="\033[1m"
RED="\e[0;31m"
BLUE="\e[0;34m"
RESET="\e[0m"

echo -e "${RED}"* "${RESET}""${BOLD_GREEN}"Creating directory to hold all Python virtual environments"${RESET}"
mkdir -p "${HOME}"/virtualenvs

# TODO: download actual file as ${HOME}/.virtual.sh
echo -e "${RED}"* "${RESET}""${BOLD_GREEN}"Downloading setV"${RESET}"
curl -# https://raw.githubusercontent.com/psachin/setV/master/virtual.sh -o ${HOME}/.virtual.sh

# TODO: append "source ${HOME}/.virtual.sh" to ~/.bashrc or ~/.bash_profile
if [ -e "${HOME}/.bashrc" ];
then
    echo -e "${RED}"* "${RESET}""${BOLD_GREEN}"Appending "${BLUE}"~/.bashrc"${RESET}"
    echo "source ~/.virtual.sh" >> ${HOME}/.bashrc
elif [ -e "${HOME}/.bash_profile" ];
then
    echo "${RED}"* "${RESET}""${BOLD_GREEN}"Appending "${BLUE}"~/.bash_profile"${RESET}"
    echo "source ~/.virtual.sh" >> ${HOME}/.bash_profile
fi

# TODO: source
source ~/.virtual.sh

# TODO: verify

# Done installing
echo -e "${RED}"* "${RESET}""${BOLD_GREEN}"Installation done!"${RESET}"

# TODO: print usage
echo -e "${RED}"===================="${RESET}"
echo -e "${BOLD_GREEN}"Usage: setv VIRTUAL_ENVIRONMENT_NAME"${RESET}"