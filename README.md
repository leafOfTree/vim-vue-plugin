# vim-vue-plugin [![Build Status][12]](https://travis-ci.com/leafOfTree/vim-vue-plugin)

<p align="center">
<a href="https://github.com/altercation/vim-colors-solarized">
<img alt="screenshot" src="https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/vim-vue-plugin-screenshot.png" width="220" />
</a>
</p>

Vim syntax and indent plugin for `.vue` files. Mainly inspired by [mxw/vim-jsx][1].

## Upgrade to the latest version

If you've installed `vim-vue-plugin` before, it's recommended to upgrade to the latest version. After upgrade, You will have to configure in a new way as described at [Configuration](#configuration).

What's new

- Clean code and configuration
- Improved performance

## Installation

<details>
<summary><a>How to install</a></summary>

- [VundleVim][2]

        Plugin 'leafOfTree/vim-vue-plugin'

- [vim-pathogen][5]

        cd ~/.vim/bundle && \
        git clone https://github.com/leafOfTree/vim-vue-plugin --depth 1

- [vim-plug][7]

        Plug 'leafOfTree/vim-vue-plugin'
        :PlugInstall

- Or manually, clone this plugin to `path/to/this_plugin`, and add it to `rtp` in vimrc

        set rtp+=path/to/this_plugin

<br />
</details>

This plugin is effective if it has set `filetype` to `vue`. Please stay up to date. Feel free to open an issue or pull request.

## How it works

`vim-vue-plugin` will try to load multiple syntax and indent files for `.vue` and enable them to work together.

Supports

- Vue attribute(directive) and keyword.

- Blocks(both `template/script/style` and custome blocks) can use any syntax, including `less, sass, scss, stylus, coffee, typescript, pug, ...`

    Relative syntax plugins need to be installed if not provided by vim.

- A builtin `foldexpr` foldmethod.

- [emmet-vim][10] HTML/JavaScript/CSS/... filetype detection.

- `.wpy` files from [WePY][6].

see [Configuration](#configuration) for details. 

## Configuration

Now we use `g:vim_vue_plugin_config` as the only configuration variable.

- type: `dict`
- default:

    ```vim
    let default = { 
          \'syntax': {
          \   'script': ['javascript'],
          \   'template': ['html'],
          \   'style': ['css'],
          \},
          \'full_syntax': [],
          \'attribute': 0,
          \'keyword': 0,
          \'foldexpr': 0,
          \'init_indent': 0,
          \'debug': 0,
          \}
    ```

### Description

- `syntax`*dict* A dictionary with the following key-value pairs

    - `key`*string*: a block's tagname
    - `value`*list*: a list of syntax name for the block.

        - First, only syntax files from `['$VIMRUNTIME', '$VIM/vimfiles', '$HOME/.vim']` are loaded. If none is found, then **full** syntax files (including those from plugins) will be loaded
        - The first item of `value` will be used as default syntax when no `lang="..."` appears on the block tag. 'value' can be a string if only one.
        - Both Vue blocks and custom blocks are supported. 

- `full_syntax`*list*: a list of syntax name whose **full** syntax files are always loaded

- `attribute`*0/1*: highlight Vue attribute as expression instead of string

- `keyword`*0/1*: highlight Vue keyword such as `data`, `methods`, ...

- `foldexpr`*0/1*: enable builtin `foldexpr` foldmethod

- `debug`*0/1*: echo debug messages in `messages` list

> For `0/1` value, set `0` to enable or `1` to disable
>
> Please check `:h dict`, `:h list` for details about the complex data types.

<details>
<summary>Documentation archive - 3/25/2021</summary>
Set global variable to `1` to enable or `0` to disable. Ex:

```vim
let g:vim_vue_plugin_load_full_syntax = 1
```

| variable                              | description                                                                                            | default                    |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| `g:vim_vue_plugin_load_full_syntax`\* | Enable: load all syntax files in `runtimepath` to enable related syntax plugins.<br> Disable: only in `$VIMRUNTIME/syntax`, `~/.vim/syntax` and `$VIM/vimfiles/syntax`. | 0 |
| `g:vim_vue_plugin_use_pug`\*          | Enable pug syntax for `<template lang="pug">`.                                                         | 0 |
| `g:vim_vue_plugin_use_coffee`         | Enable coffee syntax for `<script lang="coffee">`.                                                     | 0 |
| `g:vim_vue_plugin_use_typescript`     | Enable typescript syntax for `<script lang="ts">`.                                                     | 0 |
| `g:vim_vue_plugin_use_less`           | Enable less syntax for `<style lang="less">`.                                                          | 0 |
| `g:vim_vue_plugin_use_sass`           | Enable sass syntax for `<style lang="scss\|sass">`.                               | 0 |
| `g:vim_vue_plugin_use_scss`           | Enable scss syntax for `<style lang="scss">`.                               | 0 |
| `g:vim_vue_plugin_use_stylus`         | Enable stylus syntax for `<style lang="stylus">`.                                                      | 0 |
| `g:vim_vue_plugin_has_init_indent`    | Initially indent one tab inside `style/script` tags.                                                   | 0+ |
| `g:vim_vue_plugin_highlight_vue_attr` | Highlight vue attribute value as expression instead of string.                                         | 0 |
| `g:vim_vue_plugin_highlight_vue_keyword` | Highlight vue keyword like `data`, `methods`, ...                       | 0 |
| `g:vim_vue_plugin_use_foldexpr`\#     | Enable builtin `foldexpr` foldmethod.                                                                  | 0 |
| `g:vim_vue_plugin_custom_blocks`      | Highlight custom blocks. See details below.                                                            | {} |
| `g:vim_vue_plugin_debug`              | Echo debug messages in `messages` list. Useful to debug if unexpected indents occur.                   | 0 |

\*: Vim may be slow if the feature is enabled. Find a balance between syntax highlight and speed. By the way, custom syntax can be added in `~/.vim/syntax` or `$VIM/vimfiles/syntax`. 

\#: In the case when it's enabled, the `foldexpr` is not efficient for large files, so it's not enabled initially when the line number exceeds `1000`. You can enable it mannully by `setlocal foldmethod=expr` when required.

\+: 0 for `.vue` and 1 for `.wpy`

**Note**

- `g:vim_vue_plugin_load_full_syntax` applies to other `HTML/Sass/Less` plugins.
- `filetype` is set to `vue` so autocmds and other settings for `javascript` have to be manually enabled for `vue`.

## Custom blocks

You can enable highlighting in a custom block by setting `g:vim_vue_plugin_custom_blocks`. 

The structure is `{ block: filetype }` or `{ block: filetype[] }`. When providing a filetype list, you need to add `lang="..."` in the tag. Otherwise, the first one will be used.

### Example

```vim
let g:vim_vue_plugin_custom_blocks = { 
      \'docs': 'markdown',
      \'i18n': ['json', 'yaml', 'json5'],
      \}
```

Should highlight custom blocks in `.vue` such as

```vue
<docs>
# This is the documentation for component.
</docs>

<i18n lang="yaml">
en:
  hello: "Hello World!"
ja:
  hello: "こんにちは、世界！"
</i18n>
```
</details>

## Context based behavior

As there are more than one language in `.vue` file, the different behaviors like mapping or completion and local options, may be required under different tags or subtypes(current language type).

This plugin provides functions to get the tag/subtype where the cursor is in.

- `GetVueTag() => String` Return value is one of `'template', 'script', 'style'`.

    ```vim
    " Example
    autocmd FileType vue inoremap <buffer><expr> : InsertColon()

    function! InsertColon()
      let tag = GetVueTag()
      return tag == 'template' ? ':' : ': '
    endfunction
    ```

- `GetVueSubtype() => String` Return value is one of `'html', 'javascript', 'css', 'scss', ...`.

- `OnChangeVueSubtype(subtype)` An event listener that is called when subtype changes.

    You can also define an event listener function `OnChangeVueSubtype(subtype)` in your `vimrc` to get the subtype and set its local options whenever it changes.

    ```vim
    " Example: set local options based on subtype
    function! OnChangeVueSubtype(subtype)
      echom 'Subtype is '.a:subtype
      if a:subtype == 'html'
        setlocal commentstring=<!--%s-->
        setlocal comments=s:<!--,m:\ \ \ \ ,e:-->
      elseif a:subtype =~ 'css'
        setlocal comments=s1:/*,mb:*,ex:*/ commentstring&
      else
        setlocal commentstring=//%s
        setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
      endif
    endfunction
    ```

### emmet-vim

Currently emmet-vim works regarding your HTML/CSS/JavaScript emmet settings, but it depends on how emmet-vim gets `filetype` and may change in the future. Feel free to report an issue if any problem appears.

## Avoid overload

Since there are many sub languages included, most delays come from syntax files overload. A variable named `b:current_loading_main_syntax` is set to `vue` which can be used as loading condition if you'd like to manually find and modify the syntax files causing overload.

For example, the builtin syntax `sass.vim` and `less.vim` in vim8.1 runtime and `pug.vim` in vim-pug/syntax always load `css.vim` which this plugin already loads. It can be optimized like

`$VIMRUNTIME/syntax/sass.vim`
```diff
- runtime! syntax/css.vim
+ if !exists("b:current_loading_main_syntax")
+   runtime! syntax/css.vim
+ endif
```

`$VIMRUNTIME/syntax/vue.vim`
```diff
-   runtime! syntax/html.vim
+ if !exists("b:current_loading_main_syntax")
+   runtime! syntax/html.vim
+ endif
```


## Acknowledgments & Refs

- [mxw/vim-jsx][1]

- [Single File Components][3]

## See also

- [vim-svelte-plugin][9] 

    [Svelte][13] is a compilation web framework which shares a similar syntax to Vue.

## License

This plugin is under [The Unlicense][8]. Other than this, `lib/indent/*` files are extracted from vim runtime.

[1]: https://github.com/mxw/vim-jsx "mxw: vim-jsx"
[2]: https://github.com/VundleVim/Vundle.vim
[3]: https://vuejs.org/v2/guide/single-file-components.html
[4]: https://github.com/digitaltoad/vim-pug
[5]: https://github.com/tpope/vim-pathogen
[6]: https://github.com/Tencent/wepy
[7]: https://github.com/junegunn/vim-plug
[8]: https://choosealicense.com/licenses/unlicense/
[9]: https://github.com/leafOfTree/vim-svelte-plugin
[10]: https://github.com/mattn/emmet-vim
[11]: https://github.com/kchmck/vim-coffee-script
[12]: https://travis-ci.com/leafOfTree/vim-vue-plugin.svg?branch=master
[13]: https://svelte.dev/
[14]: https://github.com/leafgarland/typescript-vim
[15]: https://github.com/HerringtonDarkholme/yats.vim
[16]: https://github.com/iloginow/vim-stylus
