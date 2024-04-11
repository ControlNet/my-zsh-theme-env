#!/bin/bash
 
# install dev tools
mkdir -p ~/.local/bin
# if fedora or centos
if [[ -f /etc/redhat-release ]]; then

    # if fedora
    if cat /etc/redhat-release | grep -qiE "Fedora"; then
        sudo dnf install -y python3 pipx gedit vim git git-lfs curl wget zsh gcc make perl screen fzf tmux ncdu xsel unzip bat neofetch
    # if centos
    else
        sudo yum install -y python3 dnf gedit vim git git-lfs curl wget zsh gcc make perl build-essential screen fzf tmux ncdu xsel unzip
        # install pipx
        python3 -m pip install --user pipx
        python3 -m pipx ensurepath

        # install bat
        wget -O bat.zip https://github.com/sharkdp/bat/releases/download/v0.7.1/bat-v0.7.1-x86_64-unknown-linux-musl.tar.gz
        tar -xvzf bat.zip -C ~/.local/bin
        cd ~/.local/bin && mv bat-v0.7.1-x86_64-unknown-linux-musl/bat . && rm -r bat-v0.7.1-x86_64-unknown-linux-musl
        cd ~ && rm bat.zip
        
        # install neofetch
        sudo curl -o /etc/yum.repos.d/konimex-neofetch-epel-7.repo https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo
        sudo yum install -y neofetch
    fi

    # install ctop
    sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
    sudo chmod +x /usr/local/bin/ctop

    # install vnc
    sudo dnf install -y tigervnc-server

    # install gitkraken
    wget https://release.gitkraken.com/linux/gitkraken-amd64.rpm
    sudo dnf install ./gitkraken-amd64.rpm
    rm gitkraken-amd64.rpm

# if ubuntu or mint
elif cat /etc/issue | grep -qiE "Mint|Ubuntu|Pop\!_OS"; then
    # update and install
    sudo apt update
    sudo apt install -y iputils-ping net-tools python3-venv apt-utils make openssh-server gedit vim git git-lfs curl wget zsh gcc make perl build-essential libfuse2 python3-pip screen fzf tmux ncdu bat pipx xsel neofetch p7zip-full unzip

    # create a symlink for batcat to bat
    ln -s /usr/bin/batcat ~/.local/bin/bat

    # install ctop
    sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
    sudo chmod +x /usr/local/bin/ctop

    # install vnc
    sudo apt install -y tigervnc-standalone-server tigervnc-common tigervnc-xorg-extension

    # install gitkraken
    wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
    sudo apt install -y ./gitkraken-amd64.deb
    rm gitkraken-amd64.deb

# if openSUSE
elif cat /etc/os-release | grep -qiE "openSUSE"; then
    sudo zypper install -y python3 python3-pip gedit vim git git-lfs curl wget zsh gcc make perl screen fzf tmux ncdu bat xsel neofetch p7zip unzip

    # install ctop
    sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
    sudo chmod +x /usr/local/bin/ctop

    # install vnc
    sudo zypper install -y tigervnc

    # install gitkraken
    wget https://release.gitkraken.com/linux/gitkraken-amd64.rpm
    sudo zypper install --allow-unsigned-rpm -y ./gitkraken-amd64.rpm
    rm gitkraken-amd64.rpm

# if manjaro
elif cat /etc/issue | grep -qiE "Manjaro"; then
    sudo pacman -Sy --noconfirm gedit vim git git-lfs curl wget zsh gcc make perl base-devel binutils screen fzf tmux ncdu bat python-pipx xsel ctop neofetch p7zip unzip yay 

    # install vncserver
    sudo pacman -Sy --noconfirm tigervnc

    # install gitkraken
    yay -Sy --noconfirm gitkraken

# if arch
elif cat /etc/issue | grep -qiE "Arch"; then
    sudo pacman -Sy --noconfirm gedit vim git git-lfs curl wget zsh gcc make perl base-devel binutils screen fzf tmux ncdu bat python-pipx xsel ctop neofetch p7zip unzip tigervnc
    # install yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay

    # install gitkraken
    yay -Sy --noconfirm gitkraken

# if endeavour os
elif cat /etc/issue | grep -qiE "EndeavourOS"; then
    sudo pacman -Sy --noconfirm gedit vim git git-lfs curl wget zsh gcc make perl base-devel binutils screen fzf tmux ncdu bat python-pipx xsel ctop neofetch p7zip unzip

    # install gitkraken
    yay -Sy --noconfirm gitkraken

else
    echo "Not implemented for the current distro."
    exit
fi

# update pciids
sudo update-pciids

# install nvm for nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# set tmux color
echo "set -g default-terminal \"screen-256color\"" >> ~/.tmux.conf

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# change default shell
sudo chsh --shell $(which zsh) $(whoami)

# download theme
curl -fsSL https://raw.githubusercontent.com/ControlNet/my-zsh-theme-env/main/files/mzz-ys.zsh-theme > ~/.oh-my-zsh/themes/mzz-ys.zsh-theme

# modify the .zshrc file to change the theme and add plugins
cat ~/.zshrc | sed 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"mzz-ys\"\nZSH_DISABLE_COMPFIX=\"true\"/' \
    | sed 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' \
    | sed 's/# export PATH=$HOME\/bin:\/usr\/local\/bin:$PATH/export PATH=$HOME\/.cargo\/bin:$HOME\/.local\/bin:$HOME\/bin:\/usr\/local\/bin:$PATH/' \
    > ~/temp.zshrc

mv ~/temp.zshrc ~/.zshrc

# Disable oh-my-zsh auto update notification
echo "export DISABLE_UPDATE_PROMPT=true" >> ~/.zshrc

# install other plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# setup git history visualization
git config --global alias.lsd "log --graph --decorate --pretty=oneline --abbrev-commit --all"

# setup git credential
git config --global credential.helper store

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
install lazygit ~/.local/bin/lazygit
rm lazygit.tar.gz lazygit

# setup neovim
curl -LO https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
tar -xzf nvim-linux64.tar.gz
mv nvim-linux64 ~/.nvim
ln -s $HOME/.nvim/bin/nvim $HOME/.local/bin/nvim
rm nvim-linux64.tar.gz

# setup GoLang environment variables (which is only set for bash in previous)
echo '# GoLang' >> ~/.zshrc
echo 'export GOROOT=$HOME/.go' >> ~/.zshrc
echo 'export PATH=$GOROOT/bin:$PATH' >> ~/.zshrc
echo 'export GOPATH=$HOME/go' >> ~/.zshrc
echo 'export PATH=$GOPATH/bin:$PATH' >> ~/.zshrc

# setup nvm environment variables
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc

# setup fzf environment variables
echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh' >> ~/.zshrc

# try to apply the changes to the current shell (bash), there will be a problem from omz, but can be ignored
source ~/.zshrc

# install nodejs
nvm install 20

# setup LunarVim
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) -y
~/miniconda3/bin/python -m pip install neovim

# use faster libmamba solver for conda
~/miniconda3/bin/conda install -n base -y conda-libmamba-solver
~/miniconda3/bin/conda config --set solver libmamba

# install Meslo font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
mkdir -p .local/share/fonts
unzip Meslo.zip -d .local/share/fonts
cd .local/share/fonts
rm *Windows*
cd ~
rm Meslo.zip
fc-cache -fv

# install docker
sh -c "$(curl -fsSL https://get.docker.com)"
sudo groupadd docker
sudo usermod -aG docker $USER

# setup lazydocker
go install github.com/jesseduffield/lazydocker@latest

# install lemonade for neovim/lunarvim clipboard for SSH
go install github.com/lemonade-command/lemonade@latest

# install zerotier
curl -s https://install.zerotier.com | sudo bash

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
cargo install --features "pcre2" ripgrep
echo "alias grep='rg'" >> ~/.zshrc

# install gping as the alias to ping
cargo install gping
echo "alias ping='gping'" >> ~/.zshrc

# install procs as the alias to ps
cargo install procs
echo "alias ps='procs'" >> ~/.zshrc

# install xh (http client)
cargo install xh

# install uv (faster pip)
pipx install uv

# install speedtest-cli (internet speed test)
pipx install speedtest-cli

# install gdown (google drive downloader)
pipx install gdown

# install zoxide (better cd)
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc

# install micro (better nano)
curl https://getmic.ro | bash
mv micro ~/.local/bin
echo "alias nano='micro'" >> ~/.zshrc

# install scc (code counter)
go install github.com/boyter/scc/v3@latest

# install viu (image viewer)
cargo install viu

# install pm2
npm config set prefix '~/.local/'
npm install -g pm2

# Monitoring tools

# install bottom (system monitoring)
cargo install bottom

# install nvitop (nvidia gpu monitoring)
pipx install nvitop

# install bpytop (better htop)
pipx install bpytop
echo "alias top='bpytop'" >> ~/.zshrc

# install bandwhich (bandwidth monitoring)
cargo install bandwhich
sudo install $HOME/.cargo/bin/bandwhich /usr/local/bin

# change to zsh and apply theme
zsh
