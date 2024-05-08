#!/usr/bin/env bash
export NEEDRESTART_MODE=a
export DEBIAN_FRONTEND=noninteractive

set -e
log_info() {
  printf "\n\e[0;35m $1\e[0m\n\n"
}

log_info "Updating Packages ..."
  sudo -E apt-get update

log_info "Installing libraries for common gem dependencies ..."
  sudo -E apt-get -y install libxslt1-dev libcurl4-openssl-dev libksba8 libksba-dev libreadline-dev libssl-dev zlib1g-dev libsnappy-dev libyaml-dev

log_info "Installing ImageMagick ..."
  sudo -E apt-get -y install libtool
  wget https://raw.githubusercontent.com/discourse/discourse_docker/main/image/base/install-imagemagick
  chmod +x install-imagemagick
  sudo -E ./install-imagemagick

log_info "Installing ImageMagick ..."
  sudo -E apt-get -y install libtool
  wget https://raw.githubusercontent.com/discourse/discourse_docker/main/image/base/install-imagemagick
  chmod +x install-imagemagick
  sudo -E ./install-imagemagick

log_info "Installing image utilities ..."
  sudo -E apt-get -y install advancecomp gifsicle jpegoptim libjpeg-progs optipng pngcrush pngquant
  sudo -E apt-get -y install jhead

  # Install oxipng
  cd /tmp && \
    wget https://github.com/shssoichiro/oxipng/releases/download/v8.0.0/oxipng-8.0.0-x86_64-unknown-linux-musl.tar.gz && \
    tar -xzvf oxipng-8.0.0-x86_64-unknown-linux-musl.tar.gz && \
    sudo cp oxipng-8.0.0-x86_64-unknown-linux-musl/oxipng /usr/local/bin
  cd /tmp && \
    rm oxipng-8.0.0-x86_64-unknown-linux-musl.tar.gz && \
    rm -Rf oxipng-8.0.0-x86_64-unknown-linux-musl

log_info "Installing rbenv ..."
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv

  if ! grep -qs "rbenv init" ~/.bashrc; then
    printf 'export PATH="$HOME/.rbenv/bin:$PATH"\n' >> ~/.bashrc
    printf 'eval "$(rbenv init - --no-rehash)"\n' >> ~/.bashrc
  fi

  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"

log_info "Installing ruby-build, to install Rubies ..."
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

ruby_version="3.2.1"

log_info "Installing Ruby $ruby_version ..."
  rbenv install "$ruby_version"

log_info "Setting $ruby_version as global default Ruby ..."
  rbenv global $ruby_version
  rbenv rehash

log_info "Updating to latest Rubygems version ..."
  gem update --system

log_info "Installing Rails ..."
  gem install rails

log_info "Installing Bundler ..."
  gem install bundler
