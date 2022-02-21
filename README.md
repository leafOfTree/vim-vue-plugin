<img src="https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/vim-vue-plugin-icon.svg" width="60" height="60" alt="icon" align="left"/>

# vim-vue-plugin [![Build Status](https://app.travis-ci.com/leafOfTree/vim-vue-plugin.svg?branch=master)](https://app.travis-ci.com/leafOfTree/vim-vue-plugin)

<p align="center">
<a href="https://github.com/altercation/vim-colors-solarized">
<img alt="screenshot" src="https://raw.githubusercontent.com/leafOfTree/leafOfTree.github.io/master/vim-vue-plugin-screenshot.png" width="220" />
</a>
</p>

Vim syntax and indent plugin for `.vue` files. Mainly inspired by [mxw/vim-jsx][1]

## Installation

You could install it just like other plugins. The filetype will be set to `vue`. Feel free to open an issue or a pull request if any questions

<details>
<summary><a>How to install</a></summary>

- [VundleVim][2]

    ```vim
    Plugin 'leafOfTree/vim-vue-plugin'
    ```

- [vim-pathogen][5]

    ```
    cd ~/.vim/bundle
    git clone https://github.com/leafOfTree/vim-vue-plugin --depth 1
    ```

- [vim-plug][7]

    ```vim
    Plug 'leafOfTree/vim-vue-plugin'
    :PlugInstall
    ```

- Or manually, clone this plugin to `path/to/this_plugin`, and add it to `rtp` in vimrc

    ```vim
    set rtp+=path/to/this_plugin

    " If filetype is not set to 'vue', try
    filetype off
    set rtp+=path/to/this_plugin
    filetype plugin indent on
    ```
<br />
</details>

## How it works

It loads multiple syntax and indent files for `.vue` and enables them to work together

- Blocks (both `template/script/style` and custom blocks) with any syntax, including `pug, typescript, coffee, scss, sass, less, stylus, ...`. Syntax plugins need to be installed if not provided by vim
- Attribute and keyword highlight
- [emmet-vim][10] `html, javascript, css, ...` filetype detection
- Context-based behavior, such as to get current tag or syntax, and set local options like `commentstring`
- A built-in `foldexpr` foldmethod

## Configuration

`g:vim_vue_plugin_config`*dict* is the only configuration. You could copy **default value** below as a starting point

```vim
let g:vim_vue_plugin_config = { 
      \'syntax': {
      \   'template': ['html'],
      \   'script': ['javascript'],
      \   'style': ['css'],
      \},
      \'full_syntax': [],
      \'initial_indent': [],
      \'attribute': 0,
      \'keyword': 0,
      \'foldexpr': 0,
      \'debug': 0,
      \}
```

### Description

It has the following options

- **syntax**
    - **key**: *string*. Block tag name
    - **value**: *string list*. Block syntax
        - `lang="..."` on block tag decides the effective syntax
        - When no valid `lang="..."` is present, the first syntax in the list will be used.
        - By default, only syntax files from `['$VIMRUNTIME', '$VIM/vimfiles', '$HOME/.vim']` are loaded. If none is found, then **full** syntax files, including those from plugins, will be loaded
- **full_syntax**: *string list*. Syntax whose **full** syntax files will always be loaded
- **initial_indent**: *string list*. Tag/syntax with initial one tab indent. The format can be `tag.syntax`, `tag`, or `syntax`

For *boolean* options below, set `1` to enable or `0` to disable

- **attribute**: *boolean*. Highlight attribute as expression instead of string
- **keyword** : *boolean*. Highlight keyword such as `data`, `methods`, ...
- **foldexpr**: *boolean*. Enable built-in `foldexpr` foldmethod
- **debug**: *boolean*. Echo debug messages in `messages` list

### Example

Only for demo. Try to set syntax as little as possible for performance

```vim
let g:vim_vue_plugin_config = { 
      \'syntax': {
      \   'template': ['html', 'pug'],
      \   'script': ['javascript', 'typescript', 'coffee'],
      \   'style': ['css', 'scss', 'sass', 'less', 'stylus'],
      \   'i18n': ['json', 'yaml'],
      \   'route': 'json',
      \},
      \'full_syntax': ['json'],
      \'initial_indent': ['i18n', 'i18n.json', 'yaml'],
      \'attribute': 1,
      \'keyword': 1,
      \'foldexpr': 1,
      \'debug': 0,
      \}
```

You can still change options as if they are global variables

```vim
let g:vim_vue_plugin_config.foldexpr = 0
```

Note

- `typescript` matches `lang="ts"`
- `list` options can be `string` if only one
- For `.wpy`, `initial_indent` defaults to `['script', 'style']`
- You could check `:h dict` and `:h list` for details about the complex data types

## Context-based behavior

There are more than one language in `.vue` file. Different mappings, completions, and local options may be required under different tags or syntax (current language filetype)

This plugin provides functions to get the tag/syntax where the cursor is in

- `GetVueTag() => String` Return value is one of `'template', 'script', 'style'`

    ```vim
    " Example
    autocmd FileType vue inoremap <buffer><expr> : InsertColon()

    function! InsertColon()
      let tag = GetVueTag()
      return tag == 'template' ? ':' : ': '
    endfunction
    ```

- `GetVueSyntax() => String` Return value is one of `'html', 'javascript', 'css', 'scss', ...`

- `OnChangeVueSyntax(syntax)` An event listener that is called when syntax changes

    You can define it in your `vimrc` to set local options based on current syntax

    ```vim
    " Example: set local options based on syntax
    function! OnChangeVueSyntax(syntax)
      echom 'Syntax is '.a:syntax
      if a:syntax == 'html'
        setlocal commentstring=<!--%s-->
        setlocal comments=s:<!--,m:\ \ \ \ ,e:-->
      elseif a:syntax =~ 'css'
        setlocal comments=s1:/*,mb:*,ex:*/ commentstring&
      else
        setlocal commentstring=//%s
        setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
      endif
    endfunction
    ```

> It has been renamed to `GetVueSyntax, OnChangeVueSyntax` from `GetVueSubtype, OnChangeVueSubtype` for consistency

### emmet-vim

Currently emmet-vim works regarding your `html, javascript, css, ...` emmet settings, but it depends on how emmet-vim gets `filetype` and may change in the future. Feel free to report an issue if any problem appears

For `sass` using emmet-vim, please check out [this issue][17]

## Avoid overload

Since there are many sub-languages included, most delays come from syntax files overload. A variable named `b:current_loading_main_syntax` is set to `vue` which can be used as a loading condition if you'd like to manually find and modify the syntax files causing overload

For example, the built-in syntax `sass.vim` and `less.vim` in vim8.1 runtime and `pug.vim` in vim-pug/syntax always load `css.vim` which this plugin already loads. It can be optimized like

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

    [Svelte][13] is a compilation web framework that shares a similar syntax to Vue

## License

This plugin is under [The Unlicense][8]. Other than this, `lib/indent/*` files are extracted from vim runtime

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
[17]: https://github.com/leafOfTree/vim-vue-plugin/issues/23#issuecomment-628306633
