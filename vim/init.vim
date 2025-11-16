" Options
set autoindent
set autoread
set autowrite
set colorcolumn=80
set cursorline
set clipboard=unnamed,unnamedplus
set nobackup
set noswapfile
set number
set relativenumber
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set nowrap
set wildmenu
set wildoptions=pum
set lazyredraw
set timeoutlen=500
set hlsearch
set incsearch
set nofoldenable
set nospell
set regexpengine=1
set nowritebackup
set virtualedit=block
let g:vim_indent_cont = &shiftwidth
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" Keybinginds
imap jk <Esc>
vmap jk <Esc>
cmap jk <Esc>
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nnoremap <Leader><Leader>s :source $MYVIMRC<CR>
nnoremap <Leader><Leader>e :edit $MYVIMRC<CR>

" Autocmd
augroup restore_cursor_position
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
augroup END

augroup large_file_performance
  autocmd!
  autocmd BufReadPost * if getfsize(expand('%')) > 512 * 1024 | syntax off | setlocal filetype= | setlocal nonumber | setlocal norelativenumber | setlocal nospell | setlocal nocursorline | endif
augroup END

augroup disable_auto_comment
  autocmd!
  autocmd BufReadPost,FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  augroup bootstrap_vim_plug
    autocmd!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif

augroup install_missing_plugins
  autocmd!
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) | PlugInstall --sync | source $MYVIMRC | endif
augroup END

call plug#begin('~/.vim/plugged')

" SYNTAX
Plug 'sheerun/vim-polyglot', { 'on': [] }
augroup load_polyglot
  autocmd!
  autocmd InsertEnter * call plug#load('vim-polyglot') | autocmd! load_polyglot
augroup END

Plug 'dense-analysis/ale', { 'on': [] }
augroup load_ale
  autocmd!
  autocmd InsertEnter * call plug#load('ale') | autocmd! load_ale
    \| let g:ale_lint_on_text_changed = 'never'
    \| let g:ale_lint_on_insert_leave = 0
augroup END

" UI
Plug 'tpope/vim-sensible', { 'on': [] }
augroup load_sensible
  autocmd!
  autocmd BufReadPost * call plug#load('vim-sensible') | autocmd! load_sensible
augroup END

Plug 'ryanoasis/vim-devicons', { 'on': [] }
augroup load_devicons
  autocmd!
  autocmd BufReadPost * call plug#load('vim-devicons') | autocmd! load_devicons
augroup END

Plug 'morhetz/gruvbox', { 'on': [] }
augroup load_gruvbox
  autocmd!
  autocmd BufReadPost * call plug#load('gruvbox') | autocmd! load_gruvbox
    \| set background=dark
    \| set termguicolors
    \| let g:gruvbox_contrast_dark='hard'
    \| colorscheme gruvbox
augroup END

Plug 'itchyny/lightline.vim', { 'on': [] }
Plug 'shinchu/lightline-gruvbox.vim', { 'on': [] }
augroup load_lightline
  autocmd!
  autocmd BufReadPost * call plug#load('lightline.vim', 'lightline-gruvbox.vim') | autocmd! load_lightline
    \| set laststatus=2
    \| let g:lightline = {}
    \| let g:lightline.colorscheme = 'gruvbox'
augroup END

Plug 'wellle/context.vim', { 'on': [] }
augroup load_context
  autocmd!
  autocmd BufReadPost * call plug#load('context.vim') | autocmd! load_context
    \| let g:context_enabled = 1
    \| let g:context_max_height = 2
    \| let g:context_max_per_indent = 2
    \| let g:context_max_join_parts = 2
augroup END

Plug 'itchyny/vim-cursorword', { 'on': [] }
augroup load_cursorword
  autocmd!
  autocmd BufReadPost * call plug#load('vim-cursorword') | autocmd! load_cursorword
    \| highlight link CursorWord CursorLine
    \| let g:cursorword_delay = 400
augroup END

Plug 'ap/vim-buftabline', { 'on': [] }
augroup load_buftabline
  autocmd!
  autocmd BufReadPost * call plug#load('vim-buftabline') | autocmd! load_buftabline
augroup END

Plug 'machakann/vim-highlightedyank', { 'on': [] }
augroup load_highlightedyank
  autocmd!
  autocmd BufReadPost * call plug#load('vim-highlightedyank') | autocmd! load_highlightedyank
    \| let g:highlightedyank_highlight_duration = 800
augroup END

Plug 'wincent/terminus', { 'on': [] }
augroup load_terminus
  autocmd!
  autocmd InsertEnter * call plug#load('terminus') | autocmd! load_terminus
augroup END

Plug 'Yggdroot/indentLine', { 'on': [] }
augroup load_indentline
  autocmd!
  autocmd BufReadPost * call plug#load('indentLine') | autocmd! load_indentline
    \| let g:indentLine_char_list = ['│']
    \| IndentLinesEnable
augroup END

Plug 'ntpeters/vim-better-whitespace', { 'on': [] }
augroup load_better_whitespace
  autocmd!
  autocmd BufReadPost * call plug#load('vim-better-whitespace') | autocmd! load_better_whitespace
    \| highlight link ExtraWhitespace Cursor
augroup END

" TOOL
Plug 'andymass/vim-matchup', { 'on': [] }
augroup load_matchup
  autocmd!
  autocmd BufReadPost * call plug#load('vim-matchup') | autocmd! load_matchup
augroup END

Plug 'airblade/vim-gitgutter', { 'on': [] }
augroup load_gitgutter
  autocmd!
  autocmd BufReadPost * call plug#load('vim-gitgutter') | autocmd! load_gitgutter
    \| GitGutterEnable
augroup END

Plug 'ap/vim-css-color', { 'on': [] }
augroup load_css_color
  autocmd!
  autocmd BufReadPre * call plug#load('vim-css-color') | autocmd! load_css_color
augroup END

Plug 'tpope/vim-commentary', { 'on': [] }
augroup load_commentary
  autocmd!
  autocmd BufReadPre * call plug#load('vim-commentary') | autocmd! load_commentary
augroup END

Plug 'kana/vim-textobj-user', { 'on': [] }
Plug 'kana/vim-textobj-indent', { 'on': [] }
Plug 'kana/vim-textobj-line', { 'on': [] }
Plug 'glts/vim-textobj-comment', { 'on': [] }
Plug 'wellle/targets.vim', { 'on': [] }
augroup load_textobj
  autocmd!
  autocmd BufReadPost * call plug#load('vim-textobj-user', 'vim-textobj-indent', 'vim-textobj-line', 'vim-textobj-comment', 'targets.vim') | autocmd! load_textobj
augroup END

Plug 'LunarWatcher/auto-pairs', { 'on': [] }
augroup load_auto_pairs
  autocmd!
  autocmd InsertEnter * call plug#load('auto-pairs') | autocmd! load_auto_pairs
    \| call autopairs#AutoPairsTryInit()
augroup END

Plug 'luochen1990/rainbow', { 'on': [] }
augroup load_rainbow
  autocmd!
  autocmd InsertEnter * call plug#load('rainbow') | autocmd! load_rainbow
    \| call rainbow_main#toggle()
augroup END

Plug 'easymotion/vim-easymotion', { 'on': ['<Plug>(easymotion-overwin-f2)', '<Plug>(easymotion-bd-jk)', '<Plug>(easymotion-bd-w)'] }
nnoremap <Leader>gw <Plug>(easymotion-bd-w)
nnoremap <Leader>gl <Plug>(easymotion-bd-jk)
nnoremap <Leader>g2 <Plug>(easymotion-overwin-f2)

Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle'] }
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 30
nnoremap <Leader>tn :NERDTreeToggle<CR>

Plug 'mbbill/undotree', { 'on': ['UndotreeToggle'] }
nnoremap <Leader>tu :UndotreeToggle<CR>

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim', { 'on': ['Files', 'Buffers', 'Colors', 'Rg', 'Lines', 'BLines', 'History'] }
Plug 'pbogut/fzf-mru.vim', { 'on' : ['FZFMru'] }
nnoremap <Leader>ff :Files<CR>
nnoremap <C-x><C-f> :Files<CR>
nnoremap <Leader>fF :Files ~/<CR>
nnoremap <Leader>fr :History<CR>
nnoremap <Leader>fw :Rg<CR>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <C-x><C-b> :Buffers<CR>
nnoremap <Leader>fc :Colors<CR>
nnoremap <Leader>fs :BLines<CR>
nnoremap <Leader>fS :Lines<CR>
nnoremap <Leader>fm :FZFMru<CR>

Plug 'liuchengxu/vista.vim', { 'on': ['Vista'] }
let g:vista_default_executive = 'vim_lsp'

Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<C-u>WhichKey ','<CR>
let g:which_key_map = {}
let g:which_key_map.t = { 'name': '+Toggle' }
let g:which_key_map.T = { 'name': '+Term' }
let g:which_key_map.f = { 'name': '+Find' }
let g:which_key_map.g = { 'name': '+Goto' }
let g:which_key_map.w = { 'name': '+Window' }
autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')

" LSP
Plug 'prabirshrestha/asyncomplete.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-file.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-buffer.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-lsp.vim', { 'on': [] }
Plug 'prabirshrestha/vim-lsp', { 'on': [] }
Plug 'hrsh7th/vim-vsnip', { 'on': [] }
Plug 'hrsh7th/vim-vsnip-integ', { 'on': [] }
Plug 'mattn/vim-lsp-settings', { 'on': [] }
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <Plug>(lsp-definition)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <Plug>(lsp-hover)
  nnoremap <buffer> <expr><C-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><C-d> lsp#scroll(-4)
  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction
augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
augroup load_completion
  autocmd!
  autocmd InsertEnter * call plug#load('asyncomplete.vim', 'asyncomplete-file.vim', 'asyncomplete-buffer.vim', 'asyncomplete-lsp.vim', 'vim-lsp', 'vim-vsnip', 'vim-vsnip-integ', 'vim-lsp-settings')
    \| autocmd! load_completion
    \| let g:lsp_diagnostics_enabled = 0
    \| inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : "\<Tab>"
    \| inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : "\<S-Tab>"
    \| inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<CR>"
    \| call asyncomplete#enable_for_buffer()
    \| call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({ 'name': 'file', 'allowlist': ['*'], 'priority': 10, 'completor': function('asyncomplete#sources#file#completor') }))
    \| call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({ 'name': 'buffer', 'allowlist': ['*'], 'blocklist': ['go'], 'completor': function('asyncomplete#sources#buffer#completor'), 'config': { 'max_buffer_size': 50000 } }))
    \| call lsp#enable()
    \| if executable('clangd') | call lsp#register_server({ 'name': 'clangd', 'cmd': { server_info -> [ 'clangd', '-background-index' ] }, 'whitelist': ['c', 'cpp', 'objc', 'objcpp'] }) | endif
    \| if executable('basedpyright') | call lsp#register_server({ 'name': 'basedpyright', 'cmd': { server_info -> [ 'basedpyright-langserver', '--stdio' ] }, 'whitelist': ['python'] }) | endif
    \| if executable('typescript-language-server') | call lsp#register_server({ 'name': 'typescript-language-server', 'cmd': { server_info -> [&shell, &shellcmdflag, 'typescript-language-server --stdio'] }, 'root_uri': { server_info -> lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json')) }, 'whitelist': ['typescript', 'typescript.tsx', 'typescriptreact'] }) | endif
    \| if executable('typescript-language-server') | call lsp#register_server({ 'name': 'javascript support using typescript-language-server', 'cmd': { server_info -> [&shell, &shellcmdflag, 'typescript-language-server --stdio'] }, 'root_uri': { server_info -> lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.git/..')) }, 'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact'] }) | endif
augroup END

call plug#end()
