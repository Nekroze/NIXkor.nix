{ stdenv, writeText, lib }:
with lib;

let
  plugins = [
    "airblade/vim-gitgutter"
    "buoto/gotests-vim"
    "chrisbra/Colorizer"
    "fatih/vim-go"
    "godlygeek/tabular"
    "icymind/NeoSolarized"
    "junegunn/fzf.vim"
    "LnL7/vim-nix"
    "myusuf3/numbers.vim"
    "prabirshrestha/asyncomplete-lsp.vim"
    "prabirshrestha/asyncomplete.vim"
    "prabirshrestha/async.vim"
    "prabirshrestha/vim-lsp"
    "RRethy/vim-illuminate"
    "sheerun/vim-polyglot"
    "townk/vim-autoclose"
    "tpope/vim-fugitive"
    "tpope/vim-sensible"
    "tpope/vim-sleuth"
    "vim-airline/vim-airline"
    "vim-airline/vim-airline-themes"
    "vim-syntastic/syntastic"
    "Yggdroot/indentLine"
    "sirtaj/vim-openscad"
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
set background=dark
set termguicolors
colorscheme NeoSolarized
hi Normal guibg=NONE ctermbg=NONE

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

let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir
if has('persistent_undo')
  let myUndoDir = expand(vimDir . '/undodir')
  call system('mkdir ' . vimDir)
  call system('mkdir ' . myUndoDir)
  let &undodir = myUndoDir
  set undofile
endif

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
set clipboard+=unnamedplus

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

" When dapper is available use the LSP servers dapper provides
if executable('dapper')
	au user lsp_setup call lsp#register_server({
				\ 'name': 'bash',
				\ 'cmd': {server_info->[&shell, &shellcmdflag, 'dapper lsp-bash']},
				\ 'whitelist': ['sh'],
				\ })
	au user lsp_setup call lsp#register_server({
				\ 'name': 'php',
				\ 'cmd': {server_info->[&shell, &shellcmdflag, 'dapper lsp-php']},
				\ 'whitelist': ['php'],
				\ })
	au user lsp_setup call lsp#register_server({
				\ 'name': 'dockerfile',
				\ 'cmd': {server_info->[&shell, &shellcmdflag, 'dapper lsp-dockerfile']},
				\ 'whitelist': ['dockerfile'],
				\ })
	au user lsp_setup call lsp#register_server({
				\ 'name': 'dart',
				\ 'cmd': {server_info->[&shell, &shellcmdflag, 'dapper lsp-dart']},
				\ 'whitelist': ['dart'],
				\ })
endif

let g:go_version_warning = 0
''
