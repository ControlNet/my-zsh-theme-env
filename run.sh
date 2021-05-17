#!/bin/bash

# install dev tools
sudo apt update
sudo apt install -y gedit vim git curl wget zsh

# install oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > ~/install.sh
sh ~/install.sh --unattended
rm ~/install.sh

# change default shell
chsh --shell $(which zsh) $(whoami)

# download theme
curl -fsSL https://raw.githubusercontent.com/ControlNet/my-zsh-theme-env/main/files/mzz-ys.zsh-theme > ~/.oh-my-zsh/themes/mzz-ys.zsh-theme

# modify the 
cat ~/.zshrc | sed 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"mzz-ys\"\nZSH_DISABLE_COMPFIX=\"true\"/' \
    | sed 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' > ~/temp.zshrc

mv ~/temp.zshrc ~/.zshrc

# install other plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# hide conda prefix
echo "changeps1: false" >> ~/.condarc

# change to zsh and apply theme
zsh
source ~/.zshrc