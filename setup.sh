#!/usr/bin/env bash
set -ue

#ln -sf ~/dotfiles/ ~/

#bash
ln -sf ~/dotfiles/.bash_logout ~/.bash_logout
ln -sf ~/dotfiles/bashrc ~/.bashrc
ln -sf ~/dotfiles/.profile ~/.profile

#git
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

#gnupg
ln -sf ~/dotfiles/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
ln -sf ~/dotfiles/.gnupg/gpg.conf ~/.gnupg/gpg.conf

#zsh
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh

#vim
ln -sf ~/dotfiles/.vimrc ~/.vimrc

#.ssh
if [ ! -e ~/.ssh/authorized_keys ]; then
    wget https://github.com/d3v4jp.keys -qO - >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi
