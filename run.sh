#!/bin/bash
 
# install dev tools
if [[ -f /etc/redhat-release ]]; then
    sudo yum install -y gedit vim git git-lfs curl wget zsh gcc make perl build-essential screen fzf tmux ncdu
    mkdir -p ~/.local/bin

    # install pipx
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath

    # install bat
    wget -O bat.zip https://github.com/sharkdp/bat/releases/download/v0.7.1/bat-v0.7.1-x86_64-unknown-linux-musl.tar.gz
    tar -xvzf bat.zip -C ~/.local/bin
    cd ~/.local/bin && mv bat-v0.7.1-x86_64-unknown-linux-musl bat
    cd ~ && rm bat.zip

    # install nodejs
    curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
    sudo yum install -y nodejs
 
elif cat /etc/issue | grep -qiE "Mint|Ubuntu"; then
    sudo apt update
    sudo apt install -y gedit vim git git-lfs curl wget zsh gcc make perl build-essential libfuse2 python3-pip screen fzf tmux ncdu bat pipx

    # create a symlink for batcat to bat
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat

    # install nodejs
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs
 
elif cat /etc/issue | grep -qiE "Manjaro"; then
    sudo pacman -Sy gedit vim git git-lfs curl wget zsh gcc make perl base-devel binutils yay nodejs npm screen fzf tmux ncdu bat python-pipx
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

mv ~/temp.zshrc ~/.zshrc

# Disable oh-my-zsh auto update notification
echo "DISABLE_UPDATE_PROMPT=true" >> ~/.zshrc

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

# setup go
wget -q -O - https://git.io/vQhTU | bash

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

# setup GoLang environment variables (which is only set for bash in previous)
echo '# GoLang' >> ~/.zshrc
echo 'export GOROOT=$HOME/.go' >> ~/.zshrc
echo 'export PATH=$GOROOT/bin:$PATH' >> ~/.zshrc
echo 'export GOPATH=$HOME/go' >> ~/.zshrc
echo 'export PATH=$GOPATH/bin:$PATH' >> ~/.zshrc

# try to apply the changes to the current shell (bash), there will be a problem from omz, but can be ignored
source ~/.zshrc

# setup LunarVim
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) -y

# use faster libmamba solver for conda
~/miniconda3/bin/conda install -n base -y conda-libmamba-solver
~/miniconda3/bin/conda config --set solver libmamba

# install lsd with alias to ls
cargo install lsd
echo "alias ls='lsd'" >> ~/.zshrc

# install git-delta
cargo install git-delta

# add duf as the alias to df
go install github.com/muesli/duf@latest
echo "alias df='duf'" >> ~/.zshrc

# add dust as the alias to du
cargo install du-dust
echo "alias du='dust'" >> ~/.zshrc

# add fd as the alias to find
cargo install fd-find
echo "alias find='fd'" >> ~/.zshrc

# add riggrep as the alias to grep
cargo install ripgrep
echo "alias grep='rg'" >> ~/.zshrc

# install bottom
cargo install bottom

# install nvitop
pipx install nvitop

# install gping as the alias to ping
cargo install gping
echo "alias ping='gping'" >> ~/.zshrc

# install procs as the alias to ps
cargo install procs
echo "alias ps='procs'" >> ~/.zshrc

# install xh
cargo install xh

# change to zsh and apply theme
zsh
