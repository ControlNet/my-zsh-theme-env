#!/bin/bash
 
# install dev tools
mkdir -p ~/.local/bin
# install pipx
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# install bat
wget -O bat.zip https://github.com/sharkdp/bat/releases/download/v0.7.1/bat-v0.7.1-x86_64-unknown-linux-musl.tar.gz
tar -xvzf bat.zip -C ~/.local/bin
cd ~/.local/bin && mv bat-v0.7.1-x86_64-unknown-linux-musl/bat . && rm -r bat-v0.7.1-x86_64-unknown-linux-musl
cd ~ && rm bat.zip

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# install neofetch
git clone --depth 1 --branch "7.1.0" https://github.com/dylanaraps/neofetch ~/neofetch
cd ~/neofetch && make PREFIX=~/.local install
cd ~ && rm -rf ~/neofetch

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# install ncdu
wget https://dev.yorhel.nl/download/ncdu-2.3-linux-x86_64.tar.gz
tar -xvzf ncdu-2.3-linux-x86_64.tar.gz -C ~/.local/bin
rm ncdu-2.3-linux-x86_64.tar.gz

# install gitkraken
wget https://release.gitkraken.com/linux/gitkraken-amd64.tar.gz
tar -xvzf gitkraken-amd64.tar.gz
mv gitkraken ~/.gitkraken
rm gitkraken-amd64.tar.gz
ln -s ~/.gitkraken/gitkraken ~/.local/bin/gitkraken

# set tmux color
echo "set -g default-terminal \"screen-256color\"" >> ~/.tmux.conf

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# change default shell
chsh --shell $(which zsh) $(whoami)

# download theme
curl -fsSL https://raw.githubusercontent.com/ControlNet/my-zsh-theme-env/main/files/mzz-ys.zsh-theme > ~/.oh-my-zsh/themes/mzz-ys.zsh-theme

# modify the .zshrc file to change the theme and add plugins
cat ~/.zshrc | sed 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"mzz-ys\"\nZSH_DISABLE_COMPFIX=\"true\"/' \
    | sed 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' \
    | sed 's/# export PATH=$HOME\/bin:$HOME\/.local\/bin:\/usr\/local\/bin:$PATH/export PATH=$HOME\/.cargo\/bin:$HOME\/.local\/bin:$HOME\/bin:\/usr\/local\/bin:$PATH/' \
    > ~/temp.zshrc

mv ~/temp.zshrc ~/.zshrc

# Disable oh-my-zsh auto update notification
echo "export DISABLE_UPDATE_PROMPT=true" | cat - ~/.zshrc > temp && mv temp ~/.zshrc

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

# setup lazydocker
go install github.com/jesseduffield/lazydocker@latest

# install lemonade for neovim/lunarvim clipboard for SSH
go install github.com/lemonade-command/lemonade@latest

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

# install archey4
pipx install archey4

# install genact
cargo install genact

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

# install dive (docker image explorer)
go install github.com/wagoodman/dive@latest

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

# install syncthing (file sync)
curl -sS https://webinstall.dev/syncthing | bash
mkdir -p ~/.config/systemd/user
wget https://raw.githubusercontent.com/ControlNet/my-zsh-theme-env/main/files/syncthing.service -O ~/.config/systemd/user/syncthing.service
systemctl --user enable syncthing.service
systemctl --user start syncthing.service

# change to zsh and apply theme
zsh
