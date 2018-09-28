# vim-vue-plugin

Vim plugin for `.vue` files syntax and indent. Mainly inspired by [mxw/vim-jsx][1]. 

## Install

- Use [VundleVim][2]

        Plugin 'leafOfTree/vim-vue-plugin'

- Or manual: download 'vim-vue-plugin' and drop it in `Vim/vimfiles`.

Plugin works if filetype is set to `javascript.vue`.

## How it works

Since `.vue` is a combination of CSS, HTML and JavaScript, so is `vim-vue-plugin`. (Like XML and JavaScript for `.jsx`).

Support `.wpy` files too.

## Config

`g:vim_vue_plugin_has_init_indent`: indent one tab inside `sytle/template/script` tags (default: 0)

    let g:vim_vue_plugin_has_init_indent = 1

## Screenshot

![screenshot](static/screenshot.png)

## Acknowledgments

[mxw/vim-jsx][1]

[1]: https://github.com/mxw/vim-jsx "mxw: vim-jsx"
[2]: https://github.com/VundleVim/Vundle.vim
