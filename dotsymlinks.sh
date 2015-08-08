#!/bin/bash

dir=~/.dotfiles
backup_dir=~/.dotfiles.bak
files="bashrc bash_aliases bash_profile inputrc screenrc urxvt vimrc vim xmodmaprc Xresources"

mkdir -p $backup_dir

for file in $files; do
	mv ~/.$file $backup_dir
	ln -s $dir/$file ~/.$file
done
