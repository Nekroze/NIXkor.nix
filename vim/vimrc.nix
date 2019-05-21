{ stdenv, writeText, lib }:
with lib;

let
  plugins = [
    "airblade/vim-gitgutter"
    "b4b4r07/vim-hcl"
    "buoto/gotests-vim"
    "chrisbra/Colorizer"
    "ConradIrwin/vim-bracketed-paste"
    "dag/vim-fish"
    "editorconfig/editorconfig-vim"
    "fatih/vim-go"
    "godlygeek/tabular"
    "hashivim/vim-terraform"
    "junegunn/fzf.vim"
    "leafgarland/typescript-vim"
    "lifepillar/vim-solarized8"
    "LnL7/vim-nix"
    "luochen1990/rainbow"
    "machakann/vim-highlightedyank"
    "myusuf3/numbers.vim"
    "Quramy/tsuquyomi"
    "Quramy/vim-js-pretty-template"
    "RRethy/vim-illuminate"
    "rust-lang/rust.vim"
    "sirtaj/vim-openscad"
    "townk/vim-autoclose"
    "tpope/vim-fugitive"
    "tpope/vim-sensible"
    "vim-airline/vim-airline"
    "vim-airline/vim-airline-themes"
    "vim-syntastic/syntastic"
    "wlangstroth/vim-racket"
    "Yggdroot/indentLine"
    "z0mbix/vim-shfmt"
  ];
in ''
set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Automatically install missing plugins on startup
if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall | q
endif

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
${concatMapStringsSep "\n" (n: "Plug '${n}'") plugins}

call plug#end()

syntax enable
let g:is_posix=1
set number
set ruler
set expandtab tabstop=4 shiftwidth=4

set t_Co=256

if has('gui_running')
	let $theme_color_scheme = terminal-light
	set guioptions-=m  "remove menu bar
	set guioptions-=T  "remove toolbar
	set guioptions-=r  "remove right-hand scroll bar
	set guioptions-=L  "remove left-hand scroll bar
	set guifont=Fira\ Code\ 10
else
	hi Normal guibg=NONE ctermbg=NONE
endif

set background=dark
set termguicolors
colorscheme solarized8

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1
let g:airline_solarized_bg='dark'
let g:airline_theme='solarized'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
set hidden

if has('gui_running')
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
endif
if filereadable(expand("$HOME/.vimrc"))
  source ~/.vimrc
endif

autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal spell
set complete+=kspell

augroup filetypedetect
  au! BufRead,BufNewFile Dockerfile.*       setfiletype dockerfile
augroup END

" View whitespace
set list

let vimDir = '$HOME/.vim'

" Single swap dir
set backupdir=$HOME/.vim/swap
let mySwapDir = expand(vimDir . '/swap')
call system('mkdir -p ' . mySwapDir)

" Persistent undo
let &runtimepath.=','.vimDir
if has('persistent_undo')
  let myUndoDir = expand(vimDir . '/undodir')
  call system('mkdir -p ' . myUndoDir)
  let &undodir = myUndoDir
  set undofile
endif
set undolevels=1000
set undoreload=10000

set foldmethod=indent
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf
set nofoldenable

set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" disable matches in help buffers
autocmd BufEnter,FileType help call clearmatches()

" Window split settings
set splitbelow
set splitright

" Always use system clipboard
set clipboard=unnamedplus

highlight TermCursor ctermfg=red guifg=red

" make FZF work like CTRL+p
nnoremap <c-p> :FZF<cr>
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:syntastic_check_on_open = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
let g:asyncomplete_remove_duplicates = 1

let g:go_version_warning = 0
let g:go_fmt_command = "goimports"

if filereadable(expand("$HOME/.vimrc.local"))
  source ~/.vimrc.local
endif

let g:detectindent_preferred_expandtab = 1

let g:rainbow_active = 0

autocmd FileType fish compiler fish
autocmd FileType fish setlocal textwidth=79
autocmd FileType fish setlocal foldmethod=expr
if &shell =~# 'fish$'
    set shell=bash
endif

let g:terraform_fmt_on_save=1
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1

let g:go_fmt_command = "goimports"

let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
nnoremap <c-p> :FZF<cr>

let g:typescript_compiler_binary = 'tsc'
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

let g:rustfmt_autosave = 1

let g:shfmt_fmt_on_save = 1
let g:shfmt_extra_args = '-s -bn -ci -sr -kp'

" Consistent indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" case insensitive search
set smartcase

" Clean trailing spaces
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" vv to generate new vertical split
nnoremap <silent> vv <C-w>v

" Highlight named docker files
augroup filetypedetect
  au! BufRead,BufNewFile Dockerfile.*       setfiletype dockerfile
augroup END

" Spell check markdown and commits
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal spell
set complete+=kspell

" Ignore some generated files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" In editor terminal tweaks
highlight TermCursor ctermfg=red guifg=red
tnoremap <Leader><ESC> <C-\><C-n>

" Split in expected directions
set splitbelow
set splitright

" highlight trailing spaces
autocmd BufNewFile,BufRead * let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)
" highlight tabs between spaces
autocmd BufNewFile,BufRead * let b:mtabbeforesp=matchadd('ErrorMsg', '\v(\t+)\ze( +)', -1)
autocmd BufNewFile,BufRead * let b:mtabaftersp=matchadd('ErrorMsg', '\v( +)\zs(\t+)', -1)
" disable matches in help buffers
autocmd BufEnter,FileType help call clearmatches()

let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
"set termguicolors
let g:solarized_use16 = 1

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'
" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'
''
