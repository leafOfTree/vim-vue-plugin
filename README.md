# vim-vue-plugin

Vim syntax and indent plugin for `.vue` files. Mainly inspired by [mxw/vim-jsx][1].

## Install

- Use [VundleVim][2]

        Plugin 'leafOfTree/vim-vue-plugin'

- Use [vim-pathogen][5]

        cd ~/.vim/bundle && \
        git clone https://github.com/leafOfTree/vim-vue-plugin

- Use [vim-plug][7]

        Plug 'leafOfTree/vim-vue-plugin'
        :PlugInstall

- Or manually, clone this plugin, drop it in custom `path/to/this_plugin`, and add it to `rtp` in vimrc

        set rpt+=path/to/this_plugin

Plugin works if filetype is set to `javascript.vue`. Please stay up to date. Feel free to open an issue or a pull request.

## How it works

Since `.vue` is a combination of CSS, HTML and JavaScript, so is `vim-vue-plugin`. (Like XML and JavaScript for `.jsx`).

- Support Pug(`<template lang="pug">`) with [vim-pug][4] (see Configuration).
- Support Less(`<style lang="less">`) with or without [vim-less][9] (see Configuration).
- Support `.wpy` files from [WePY][6]

## Configuration

Set global variable to `1` to enable or `0` to disable.

Ex:

    let g:vim_vue_plugin_load_full_syntax = 1

| variable                              | description                                                                                            | default                    |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| `g:vim_vue_plugin_load_full_syntax`\* | Enable: load all syntax files in `runtimepath` to enable related syntax plugins. Disable: only in `syntax`, `~/.vim/syntax` and `$VIM/vimfiles/syntax` | 0 |
| `g:vim_vue_plugin_use_pug`\*          | Enable `vim-pug` pug syntax for `<template lang="pug">`.                                               | 0 |
| `g:vim_vue_plugin_use_less`           | Enable less syntax for `<template lang="less">`.                                                       | 0 |
| `g:vim_vue_plugin_debug`              | Echo debug message in `messages` list. Useful to debug if indent errors occur.                         | 0 |
| `g:vim_vue_plugin_has_init_indent`    | Initially indent one tab inside `style/script` tags.                                                   | 0 for `.vue`. 1 for `.wpy` |

\*: Vim may be slow if the feature is enabled. Find balance between syntax highlight and speed. By the way, custom syntax could be added in `~/.vim/syntax` or `$VIM/vimfiles/syntax`.

## Screenshot

![screenshot](https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/vim-vue-plugin-screenshot.png)

## Acknowledgments & Refs

[mxw/vim-jsx][1]

[Single File Components][3]

## License

This plugin is under [The Unlicense][8].

[1]: https://github.com/mxw/vim-jsx "mxw: vim-jsx"
[2]: https://github.com/VundleVim/Vundle.vim
[3]: https://vuejs.org/v2/guide/single-file-components.html
[4]: https://github.com/digitaltoad/vim-pug
[5]: https://github.com/tpope/vim-pathogen
[6]: https://tencent.github.io/wepy
[7]: https://github.com/junegunn/vim-plug
[8]: https://choosealicense.com/licenses/unlicense/
[9]: https://github.com/groenewege/vim-less
