# my-zsh-theme-env
A script to fast build my zsh theme environment

It supports the following distributions:
- Ubuntu and Mint
- Redhat, CentOS, ...
- Manjaro

What tools will be installed:
- The basic development tools (vim, wget, git, ...)
- Install zsh as the default shell
- A theme (modified mzz-ys) for zsh with oh-my-zsh
- Frequently used languages and package managers (python with conda, nodejs, rust, golang, ...)
- Modern linux terminal tools (exa, bat, fd, ripgrep, lazygit, lunarvim, ...) with alias

## How to use it
```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ControlNet/my-zsh-theme-env/main/run.sh)"
```

### For docker

```dockerfile
# Setup environment
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting

# download theme
RUN curl -fsSL https://raw.githubusercontent.com/ControlNet/my-zsh-theme-env/main/files/mzz-ys.zsh-theme > /root/.oh-my-zsh/themes/mzz-ys.zsh-theme

# modify the .zshrc file to change the theme and add plugins
RUN cat /root/.zshrc | sed 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"mzz-ys\"\nZSH_DISABLE_COMPFIX=\"true\"/' \
    | sed 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' > /root/temp.zshrc
RUN mv /root/temp.zshrc /root/.zshrc

# setup git alias
RUN git config --global alias.lsd "log --graph --decorate --pretty=oneline --abbrev-commit --all"

# hide conda prefix
RUN echo "changeps1: false" >> /root/.condarc
```