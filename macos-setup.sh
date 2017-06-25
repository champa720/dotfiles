#!/bin/bash

##################
# Code # Color   #
##################
#  00  # Off     #
#  30  # Black   #
#  31  # Red     #
#  32  # Green   #
#  33  # Yellow  #
#  34  # Blue    #
#  35  # Magenta #
#  36  # Cyan    #
#  37  # White   #
##################

# helpers
function print { echo -e "\033[1;35m=> $1 \033[0m"; }
function echo_ok { echo -e "\033[1;35m✔ $1 \033[0m"; }
function echo_warn { echo -e "\033[1;33m!!! $1 \033[0m"; }
function echo_error { echo -e "\033[1;31m✖ Error: $1 \033[0m"; }

print "Install starting. You may be asked for your password."

# requires xcode and tools!
if xcode-select -p; then
	echo_ok "Xcode already installed"
else
	exit echo_error "XCode must be installed! (use the app store)"
fi

# homebrew
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
if hash brew &> /dev/null; then
	echo_ok "Homebrew already installed, check for updates:"
	brew update && brew upgrade
else
  echo_warn "Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# tap homebrew
taps=(
  caskroom/cask
#  caskroom/fonts
)
brew tap ${taps[@]}
echo_ok "Homebrew taps:"
brew tap

# install homebrew packages
echo_warn "Installing homebrew/packages..."
packages=(
	cmatrix
  git
  openshift-cli
  nvm
  rbenv
	ruby-build
  yarn
  wget
)

brew install ${packages[@]}
echo_ok "Homebrew packages installed:"
brew list

# install homebrew/casks
echo_warn "Installing homebrew/casks..."
casks=(
# adobe-acrobat
#	adobe-creative-cloud
  atom
	avast-mac-security
	github-desktop
#	xquartz
#	inkscape
 	flux
	google-chrome
#	google-play-music-desktop-player
# microsoft-office
  spectacle
	webcatalog
)

brew cask install ${casks[@]}
echo_ok "Homebrew casks installed:"
brew cask list

# Ruby
echo_warn "Configuring ruby..."
# Add rbenv to bash so that it loads every time you open a terminal
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
source ~/.bash_profile
rbenv install 2.3.3
rbenv global 2.3.3

echo_ok "Ruby config:"
gem env

# Gems
echo_warn "Installing gems..."
echo "gem: --no-document" >> ~/.gemrc
gem install bundler
gem install nokogiri

echo_ok "Gems installed:"
gem list

# node
echo_warn "Configuring node,js..."
nvm install v4.2

echo_ok "Node,js config:"
nvm --version
node --version

# Git credentials
#GIT_AUTHOR_NAME="Jason Kilpatrick"
#GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
#git config --global user.name "$GIT_AUTHOR_NAME"
#GIT_AUTHOR_EMAIL="champa720@gmail.com"
#GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
#git config --global user.email "$GIT_AUTHOR_EMAIL"

# RVM
#if hash rvm &> /dev/null; then
#	echo_ok "RVM already installed, check for updates:"
#	rvm get stable
#	rvm use ruby-2.3.3
#else
#	echo_warn "Installing RVM..."
#	curl -sSL https://get.rvm.io | bash -s stable --ruby
#fi

# cleanup homebrew
brew cleanup && brew cask cleanup

# cleanup gems
gem cleanup

# cleanup launchpad
defaults write com.apple.dock ResetLaunchPad -bool true
killall Dock

echo_ok "Done."
