#!/bin/bash

dir=~/.dotfiles
files="bashrc bash_aliases bash_profile inputrc screenrc urxvt vimrc vim xmodmaprc xsessionrc Xresources"

for file in $files; do
	ln -s $dir/$file ~/.$file
done
