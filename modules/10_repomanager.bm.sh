#!/bin/bash
# Local Repository Manager, Made by Citrizon

# Configuration
PREFERRED_CODE_BIN="nevi";

# Prepare
export XDG_REPOS_DIR="$XDG_DOCUMENTS_DIR/repos";
if [ -z "$XDG_DOCUMENTS_DIR" ]; then
    export XDG_REPOS_DIR="$HOME/.repos";
fi;

mkdir -p "$XDG_REPOS_DIR";

function repomk(){ for var in "$@"; do mkdir "$XDG_REPOS_DIR/$var"; echo "Created Repository '$var'"; done; }
function reporm(){ for var in "$@"; do rm -rf "$XDG_REPOS_DIR/$var"; echo "Deleted Repository '$var'"; done; }
function repos(){ ls "$XDG_REPOS_DIR"; }
function repocd(){ cd "$XDG_REPOS_DIR/$@"; }
function repoed(){ $PREFERRED_CODE_BIN "$XDG_REPOS_DIR/$@"; }

# autocomplete
_repofiles()
{
    local cmd=$1 cur=$2 pre=$3
    local arr i file

    arr=( $( cd "$XDG_REPOS_DIR" && compgen -f -- "$cur" ) )
    COMPREPLY=()
    for ((i = 0; i < ${#arr[@]}; ++i)); do
        file=${arr[i]}
        if [[ -d $XDG_REPOS_DIR/$file ]]; then
            file=$file/
        fi
        COMPREPLY[i]=$file
    done
}
complete -F _repofiles -o nospace repocd
complete -F _repofiles -o nospace repoed
