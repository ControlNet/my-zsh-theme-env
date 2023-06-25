#!/bin/bash
 
# install dev tools
if [[ -f /etc/redhat-release ]]; then
    sudo yum install -y gedit vim git git-lfs curl wget zsh gcc make perl build-essential screen fzf tmux
    curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
    sudo yum install -y nodejs
 
elif cat /etc/issue | grep -qiE "Mint|Ubuntu"; then
    sudo apt update
    sudo apt install -y gedit vim git curl wget zsh gcc make perl build-essential libfuse2 python3-pip screen fzf tmux
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs
 
elif cat /etc/issue | grep -qiE "Manjaro"; then
    sudo pacman -Sy gedit vim git curl wget zsh gcc make perl base-devel binutils yay nodejs npm screen fzf tmux
fi

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# change default shell
chsh --shell $(which zsh) $(whoami)

# download theme
curl -fsSL https://raw.githubusercontent.com/ControlNet/my-zsh-theme-env/main/files/mzz-ys.zsh-theme > ~/.oh-my-zsh/themes/mzz-ys.zsh-theme

# modify the .zshrc file to change the theme and add plugins
cat ~/.zshrc | sed 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"mzz-ys\"\nZSH_DISABLE_COMPFIX=\"true\"/' \
    | sed 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' \
    | sed 's/# export PATH=$HOME\/bin:\/usr\/local\/bin:$PATH/export PATH=$HOME\/.cargo\/bin:$HOME\/.local\/bin:$HOME\/bin:\/usr\/local\/bin:$PATH/' \
    > ~/temp.zshrc

echo "alias vim=lvim" >> ~/temp.zshrc

mv ~/temp.zshrc ~/.zshrc

# install other plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# setup git history visualization
git config --global alias.lsd "log --graph --decorate --pretty=oneline --abbrev-commit --all"

# install miniconda
curl -s -L -o miniconda_installer.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash miniconda_installer.sh -b
rm miniconda_installer.sh

# initialize conda
~/miniconda3/bin/conda init zsh

# hide conda prefix
echo "changeps1: false" >> ~/.condarc

# setup cargo
curl https://sh.rustup.rs -sSf | sh -s -- -y

# setup lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit

# setup neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
sudo install nvim.appimage /usr/local/bin
sudo ln -s /usr/local/bin/nvim.appimage /usr/local/bin/nvim
rm nvim.appimage

# change to zsh and apply theme
zsh
source ~/.zshrc

# setup LunarVim
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) -y
