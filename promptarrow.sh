#!/bin/sh

# PROMPT_DIRTRIM=4
INVARROW="🭨" # inverse arrow
ARROW="🭬" # regular arrow

TOPLEVEL=$(git rev-parse --show-toplevel 2> /dev/null)
if [ "$TOPLEVEL" = "$HOME" ]; then
  PS1_BRANCH=""
else
  PS1_BRANCH=$(git symbolic-ref --short HEAD 2> /dev/null)
fi

if [ -n "$NIX_GCROOT" ]; then
  # $(echo $n $NIX_GCROOT | cut -c 12-22)
  PS1_NIX="NIXDEV${NIX_SHELL_DEPTH_PS1}: ${name}"
else
  # Adjust PS1 for when inside a 'nix shell'
  case "$PATH" in
    */nix/store/*)
      PS1_NIX="NIXSHELL${NIX_SHELL_DEPTH_PS1}: ${NIX_SHELL_HASH}"
      ;;
  esac
fi

# COLOR1=10
if [ -z "$PS1_NIX" ]; then
  COLOR1=6 # user@host
  COLOR2=12 # pwd
  COLOR3=3 # nix
  COLOR4=3 # git
else
  COLOR1=185
  COLOR2=107
  COLOR3=3
  COLOR4=10
fi

PS1=""

# xterm title
PS1+="\[\e]0;\u@\h: \w\a\]"

if [ -n "${PS1_NIX}" ]; then
  PS1+='\['$(tput setaf 16 setab "${COLOR3}" bold)'\]'
  PS1+="${PS1_NIX}"
  PS1+='\['$(tput sgr0)'\]'
  PS1+="\n"
  PS1+='\['$(tput setaf 16 setab "${COLOR3}" bold)'\]'
  PS1+=" NIX "
  PS1+='\['$(tput sgr0 setaf "${COLOR1}" setab "${COLOR3}")'\]'
  PS1+="${INVARROW}"
fi
PS1+='\['$(tput setaf 16 setab "${COLOR1}" bold)'\]'
PS1+='\u@\h '
PS1+='\['$(tput sgr0 setaf "${COLOR2}" setab "${COLOR1}" bold)'\]'
PS1+=${INVARROW}
PS1+='\['$(tput setaf 16 setab "${COLOR2}" bold)'\]'
PS1+='\w '
if [ -n "${PS1_BRANCH}" ]; then
  PS1+='\['$(tput setaf "${COLOR4}")'\]'
  PS1+="${PS1_BRANCH} "
fi
PS1+='\['$(tput setaf 16 setab "${COLOR2}")'\]'
PS1+="${INVARROW}"
PS1+='\['$(tput sgr0)'\]'
PS1+=' '

echo -n -e "${PS1}"

# EOF #
