.DEFAULT_GOAL = setup

# Helpful stuff
APT_ADD     := sudo add-apt-repository -y
APT_INSTALL := sudo apt install -y
APT_UPDATE  := sudo apt update -y
APT_UPGRADE := sudo apt upgrade -y

.PHONY: setup
setup: \
  packages \
  fonts \
  jetbrains \
  omz \
  omz-theme \
  sway \
  zsh \
  zsh-plugins \
  1pass \
  files \

.PHONY: packages
packages:
	@echo 'CONFIGURING packages'
	$(APT_UPDATE)
	$(APT_UPDGRADE)
	$(APT_INSTALL) \
	  curl \
	  fzf \
	  git \
	  kitty \

.PHONY: fonts
fonts:
	gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
	gsettings set org.gnome.settings-daemon.plugins.xsettings hinting 'full'
	$(APT_INSTALL) \
	  fonts-cantarell \
	  fonts-font-awesome \
	  fonts-inconsolata \
	  fonts-source-code-pro-ttf \

.PHONY: jetbrains
jetbrains:
	curl -L https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.21.9712.tar.gz \
		-o ~/Downloads/jetbrains-toolbox-1.21.9712.tar.gz
	mkdir -p /tmp/jetbrains-toolbox
	tar zxvf ~/Downloads/jetbrains-toolbox-1.21.9712.tar.gz \
		-C /tmp/jetbrains-toolbox \
		--strip-components=1

.PHONY: sway
sway:
	@echo 'CONFIGURING sway'
	$(APT_INSTALL) \
	  sway \
	  swaylock \
	  waybar \
	  wl-clipboard \
	  wofi \

.PHONY: omz
omz: ~/.oh-my-zsh

~/.oh-my-zsh:
	@echo 'CONFIGURING omz'
	sh -c "$$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

.PHONY: omz-theme
omz-theme:
	rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
		~/.oh-my-zsh/custom/themes/powerlevel10k

.PHONY: zsh
zsh:
	@echo 'CONFIGURING zsh'
	$(APT_INSTALL) zsh
	echo $$SHELL | grep -q zsh && echo 'zsh already configured' || chsh -s $$(which zsh)

.PHONY: zsh-plugins
zsh-plugins:
	test -d ~/.fzf \
		|| (git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install)
	test -d ~/.oh-my-zsh/custom/plugins/zsh-z \
		|| git clone https://github.com/agkozak/zsh-z ~/.oh-my-zsh/custom/plugins/zsh-z

.PHONY: 1pass
1pass:
	curl -sS https://downloads.1password.com/linux/keys/1password.asc \
	  | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
	echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' \
	  | sudo tee /etc/apt/sources.list.d/1password.list
	sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
	curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol \
	  | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
	sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
	curl -sS https://downloads.1password.com/linux/keys/1password.asc \
	  | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
	sudo apt update && sudo apt install 1password

.PHONY:
files:
	@echo 'CONFIGURING FILESYSTEM'
	ln -sfv $(CURDIR)/root/.scripts       ~/.scripts
	ln -sfv $(CURDIR)/root/.config/kitty  ~/.config/kitty
	ln -sfv $(CURDIR)/root/.config/sway   ~/.config/sway
	ln -sfv $(CURDIR)/root/.config/waybar ~/.config/waybar
	ln -sfv $(CURDIR)/root/.zshrc         ~/.zshrc
	ln -sfv $(CURDIR)/root/.config/zsh    ~/.config/zsh
