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

The plugin works if `filetype` is set to `vue`. Please stay up to date. Feel free to open an issue or a pull request.


## How it works

Since `.vue` is a combination of CSS, HTML and JavaScript, so is `vim-vue-plugin`. (Like XML and JavaScript for `.jsx`).

Supports

- Vue directive.
- Pug with [vim-pug][4] (see Configuration).
- Less with or without [vim-less][9] (see Configuration).
- Sass/Scss (see Configuration).
- `.wpy` files from [WePY][6].

## Configuration

Set global variable to `1` to enable or `0` to disable.

Ex:

    let g:vim_vue_plugin_load_full_syntax = 1

| variable                              | description                                                                                            | default                    |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| `g:vim_vue_plugin_load_full_syntax`\* | Enable: load all syntax files in `runtimepath` to enable related syntax plugins.<br> Disable: only in `$VIMRUNTIME/syntax`, `~/.vim/syntax` and `$VIM/vimfiles/syntax` | 0 |
| `g:vim_vue_plugin_use_pug`\*          | Enable `vim-pug` pug syntax for `<template lang="pug">`.                                               | 0 |
| `g:vim_vue_plugin_use_less`           | Enable less syntax for `<style lang="less">`.                                                          | 0 |
| `g:vim_vue_plugin_use_sass`           | Enable sass/scss syntax for `<style lang="sass">`(or scss).                                            | 0 |
| `g:vim_vue_plugin_has_init_indent`    | Initially indent one tab inside `style/script` tags.                                                   | 0 for `.vue`. 1 for `.wpy` |
| `g:vim_vue_plugin_highlight_vue_attr` | Highlight vue attributes differently.                                                                  | 0 |
| `g:vim_vue_plugin_debug`              | Echo debug messages in `messages` list. Useful to debug if unexpected indentations occur.                   | 0 |

\*: Vim may be slow if the feature is enabled. Find a balance between syntax highlight and speed. By the way, custom syntax could be added in `~/.vim/syntax` or `$VIM/vimfiles/syntax`.

**Note**: `filetype` used to be set to `javascript.vue`, which caused `javascript` syntax to be loaded multiple times and a significant delay. Now it is `vue` so autocmds and other settings for `javascript` have to be manually enabled for `vue`.

## Screenshot

<img alt="screenshot" src="https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/vim-vue-plugin-screenshot.png" width="600" />

## Context based behavior

As there are more than one language in `.vue` file, the different behavior like mapping or completion may be expected under the different tag.

This plugin provides a Function to get the tag the cursor is in.

- `GetVueTag() => String` Return value is 'template', 'script' or 'style'.

### Example

```vim
autocmd FileType vue inoremap <buffer><expr> : InsertColon()

function! InsertColon()
  let tag = GetVueTag()
  if tag == 'template'
    return ':'
  else
    return ': '
  endif
endfunction
```

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
