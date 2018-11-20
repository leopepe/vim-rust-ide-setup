#!/bin/bash

RACER_PATH="$HOME/.cargo/bin/racer"

check_racer() {
    if [[ ! -f $RACER_PATH ]]; then
        RACER_INSTALLED=0
    else
        RACER_INSTALLED=1
    fi
}

check_rustfmt() {
    if [[ $(rustup component list|grep rustfmt|wc -l) -ne 1 ]]; then
        RUSTFMT_INSTALLED=0
    else
        RUSTFMT_INSTALLED=1
    fi
}

check_vimrc() {
    if [[ "$(cat $HOME/.vimrc_bkp)" == "$(cat ./vimrc)" ]]; then
        VIMRC_STATE="equal"
    else
        VIMRC_STATE="differ"
    fi
}

check_rust_vim() {
    if [[ -d $HOME/.vim/pack/plugins/start/rust.vim ]]; then
        RUST_VIM_INSTALLED=1
    else
        RUST_VIM_INSTALLED=0
    fi
}

install_racer() {
    check_racer
    if [[ $RACER_INSTALLED -eq 0  ]]; then
        cargo install racer
    else
        echo "Racer was already installed"
    fi
}

install_rustfmt() {
    check_rustfmt
    if [[ $RUSTFMT_INSTALLED -eq 0 ]]; then
        rustup component add rustfmt-preview
    else
        echo "RustFmt was already intalled"
    fi
}

install_rust_vim() {
    check_rust_vim
    if [[ $RUST_VIM_INSTALLED -eq 0 ]]; then
        git clone https://github.com/rust-lang/rust.vim $HOME/.vim/pack/plugins/start/rust.vim
    else
        echo "Rust VIM plugin was already installed"
    fi
}

install_vimrc() {
    if [[ $VIMRC_STATE == "differ" ]]; then
        cp $HOME/.vimrc $HOME/.vimrc_$(date "+%Y%m%d%H%M")
        cat ./vimrc >> $HOME/.vimrc
    else
        echo "$HOME/.vimrc file was already configured"
    fi
}

main() {
    install_racer
    install_rustfmt
    install_rust_vim
}

main
