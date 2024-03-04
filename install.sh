#!/bin/bash
echo "BashMod (Bash Modules Manager) Installer"
echo "Made by Citrizon, Open-Source Project."
echo ""

C_ANSI_RSTC="\e[0m"
C_ANSI_FRED="\e[31m"
C_ANSI_FGRN="\e[32m"
C_ANSI_FBLU="\e[36m"
C_ANSI_BRED="\e[41m"
C_ANSI_BGRN="\e[42m"
C_ANSI_BBLU="\e[46m"

function log_fatal () { echo -e "${C_ANSI_BRED}  FATAL  ${C_ANSI_RSTC} $@"; }
function log_error () { echo -e "${C_ANSI_BRED}  ERROR  ${C_ANSI_RSTC} $@"; }
function log_silly () { echo -e "${C_ANSI_BBLU}  SILLY  ${C_ANSI_RSTC} $@"; }
function log_scess () { echo -e "${C_ANSI_BGRN}   YES   ${C_ANSI_RSTC} $@"; }
function log_instl () { echo -e "${C_ANSI_BGRN} INSTALL ${C_ANSI_RSTC} $@"; }

if [ "$EUID" -ne 0 ]; then
    log_fatal "Please run as root"
    exit
fi

if grep -q "BashMod" "/etc/bash.bashrc"; then
    log_silly "BashMod is already installed, Exiting."
    exit
fi

tee -a /etc/bash.bashrc > /dev/null <<EOT
BASHMOD_LOAD_LIST=1
# DO NOT CHANGE ANYTHING IN THIS AREA -------------------------------------

    # -> BashMod
    #    by Citrizon

    # XDG Directories, if exists
    if [ -f \$HOME/.config/user-dirs.dirs ]; then
        source "\$HOME/.config/user-dirs.dirs";
    fi

    # Preload Bash Config, if exists
    if [ -f \$HOME/.bash_preload ]; then
        . "\$HOME/.bash_preload";
    fi

    # Load Modules, if exists
    if [ -n "\$(ls -A /etc/bashmod.d/*.bm.sh 2>/dev/null)" ]; then for modfile in /etc/bashmod.d/*.bm.sh; do
        source \$modfile;
    done; fi;

    if [ -n "\$(ls -A \$HOME/.bash_modules/*.bm.sh 2>/dev/null)" ]; then for modfile in \$HOME/.bash_modules/*.bm.sh; do
        source \$modfile;
    done; fi;

# -------------------------------------------------------------------------
EOT
log_instl "BashMod @ /etc/bash.bashrc"

mkdir -p /etc/bashmod.d
log_scess "MKDIR /etc/bashmod.d"

echo "All done, Have fun!"
