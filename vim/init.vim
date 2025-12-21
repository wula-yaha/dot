" References
" https://github.com/chenxuan520/vim-fast
" https://github.com/carlhuda/janus
" https://github.com/liuchengxu/space-vim

" Options
set nocompatible
set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal
set ttimeout
set ttimeoutlen=500
set incsearch
set hlsearch
set laststatus=2
set showtabline=2
set ruler
set wildmenu
set scrolloff=1
set sidescroll=1
set sidescrolloff=2
set nowrap
set background=dark
set notermguicolors
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set formatoptions+=j
set autoread
set autowrite
set history=1000
set t_Co=256
set number
set relativenumber
set cursorline
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set lazyredraw
set pumheight=10
set pumwidth=8
set textwidth=0
set whichwrap=b,s,<,>,h,l
set virtualedit=block
set matchpairs+=<:>
set autoindent
set cindent
set cinoptions=g0,:0,N-s,(0
set smartindent
filetype on
filetype plugin indent on
filetype indent on
syntax on
syntax enable
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_gzip = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tutor_mode_plugin = 1

" Keybindings
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
imap jk <Esc>
vmap jk <Esc>
cmap jk <Esc>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Auto Command
augroup restore_last_cursor_position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
augroup END

augroup close_with_q
  autocmd!
  autocmd FileType help,qf,man,netrw,lspinfo,checkhealth,startuptime nnoremap <silent> <buffer> q :close<CR>
augroup END

augroup disable_auto_comment
  autocmd!
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

augroup auto_create_dir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force || input("Directory '" . a:dir . "' does not exist. Create? [y/N] ") =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END

augroup auto_read_file
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
  autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
augroup END

augroup vertical_split_for_help_manual
  autocmd!
  autocmd FileType help wincmd L
augroup END

" vim-plug & Plugins
let data_dir = has('win32') || has('win64') ? '$HOME\vimfiles' : '~/.vim'
if empty(glob(data_dir.'/autoload/plug.vim'))
  if has('win32') || has('win64')
    silent execute '!powershell -Command "New-Item -Path "'.data_dir.' -Name autoload -Type Directory -Force; Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -OutFile '.data_dir.'\autoload\plug.vim"'
  else
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endif
  augroup install_vim_plug
    autocmd!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif
augroup install_missing_plugins
augroup install_missing_plugins
  autocmd!
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) | PlugInstall --sync | source $MYVIMRC | endif
augroup END
nnoremap <Leader>L :PlugInstall<CR>

call plug#begin(data_dir.'/plugged')

Plug 'mhinz/vim-startify'
let g:startify_custom_header = []

Plug 'ryanoasis/vim-devicons', { 'on': [] }
augroup load_devicons
  autocmd!
  autocmd BufEnter,BufReadPost * call plug#load('vim-devicons')
        \| autocmd! load_devicons
        \| let g:webdevicons_enable_nerdtree = 1
        \| let g:webdevicons_conceal_nerdtree_brackets = 1
        \| let g:webdevicons_enable_startify = 1
augroup END

Plug 'sheerun/vim-polyglot', { 'on': [] }
augroup load_polyglot
  autocmd!
  autocmd BufReadPost * call plug#load('vim-polyglot')
        \| autocmd! load_polyglot
augroup END

Plug 'morhetz/gruvbox', { 'on': [] }
augroup load_gruvbox
  autocmd!
  autocmd BufReadPost * call plug#load('gruvbox')
        \| autocmd! load_gruvbox
        \| let g:gruvbox_contrast_dark = 'hard'
        \| colorscheme gruvbox
augroup END

Plug 'ap/vim-buftabline', { 'on': [] }
augroup load_buftabline
  autocmd!
  autocmd BufReadPost * call plug#load('vim-buftabline')
        \| autocmd! load_buftabline
augroup END

Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
augroup load_lightline
  autocmd!
  autocmd BufReadPost * call plug#load('lightline.vim', 'lightline-gruvbox.vim')
        \| autocmd! load_lightline
        \| let g:lightline_gruvbox_style = 'hard'
        \| let g:lightline = {}
        \| let g:lightline.colorscheme = 'gruvbox'
augroup END

Plug 'machakann/vim-highlightedyank', { 'on': [] }
augroup load_highlightedyank
  autocmd!
  autocmd BufReadPost * call plug#load('vim-highlightedyank')
        \| autocmd! load_highlightedyank
        \| let g:highlightedyank_highlight_duration = 1000
        \| highlight HighlightedyankRegion cterm=reverse gui=reverse
augroup END

Plug 'ntpeters/vim-better-whitespace', { 'on': [] }
augroup load_better_whitespace
  autocmd!
  autocmd BufReadPost * call plug#load('vim-better-whitespace')
        \| autocmd! load_better_whitespace
        \| highlight link ExtraWhitespace ErrorMsg
augroup END

Plug 'itchyny/vim-cursorword', { 'on': [] }
augroup load_cursorword
  autocmd!
  autocmd BufReadPost * call plug#load('vim-cursorword')
        \| autocmd! load_cursorword
        \| let g:cursorword_delay = 500
        \| highlight link CursorWord CursorLine
augroup END

Plug 'vim-scripts/LargeFile', { 'on': [] }
augroup load_largefile
  autocmd!
  autocmd BufReadPost * call plug#load('LargeFile')
        \| autocmd! load_largefile
        \| let g:LargeFile = 2
augroup END

Plug 'wincent/terminus', { 'on': [] }
augroup load_terminus
  autocmd!
  autocmd BufReadPost * call plug#load('terminus')
        \| autocmd! load_terminus
augroup END

Plug 'romainl/vim-cool', { 'on': [] }
augroup load_cool
  autocmd!
  autocmd BufReadPost * call plug#load('vim-cool')
        \| autocmd! load_cool
augroup END

Plug 'airblade/vim-gitgutter', { 'on': [] }
augroup load_gitgutter
  autocmd!
  autocmd BufReadPost * call plug#load('vim-gitgutter')
        \| autocmd! load_gitgutter
        \| let g:gitgutter_map_keys = 0
augroup END

Plug 'justinmk/vim-sneak', { 'on': [] }
augroup load_sneak
  autocmd!
  autocmd BufReadPost * call plug#load('vim-sneak')
        \| autocmd! load_sneak
augroup END

Plug 'andymass/vim-matchup', { 'on': [] }
augroup load_matchup
  autocmd!
  autocmd BufReadPost * call plug#load('vim-matchup')
        \| autocmd! load_matchup
        \| let g:matchup_matchparen_offscreen = {}
augroup END

Plug 'ap/vim-css-color', { 'on': [] }
augroup load_css_color
  autocmd!
  autocmd BufReadPre * call plug#load('vim-css-color')
        \| autocmd! load_css_color
augroup END

Plug 'tpope/vim-commentary', { 'on': [] }
augroup load_commentary
  autocmd!
  autocmd BufReadPost * call plug#load('vim-commentary')
        \| autocmd! load_commentary
augroup END

Plug 'tpope/vim-surround', { 'on': [] }
augroup load_surround
  autocmd!
  autocmd BufReadPost * call plug#load('vim-surround')
        \| autocmd! load_surround
augroup END

Plug 'wellle/context.vim', { 'on': [] }
augroup load_context
  autocmd!
  autocmd BufReadPost * call plug#load('context.vim')
        \| autocmd! load_context
        \| let g:context_max_height = 2
        \| let g:context_max_per_indent = 2
        \| let g:context_max_join_parts = 2
augroup END

Plug 'junegunn/vim-peekaboo', { 'on': [] }
augroup load_peekaboo
  autocmd!
  autocmd BufReadPost * call plug#load('vim-peekaboo')
        \| autocmd! load_peekaboo
augroup END

if has('conceal')
  Plug 'yggdroot/indentLine', { 'on': [] }
  augroup load_indentline
    autocmd!
    autocmd BufReadPost * call plug#load('indentLine')
          \| autocmd! load_indentline
          \| let g:indentLine_char_list = ['│']
  augroup END
endif

Plug 'terryma/vim-smooth-scroll', { 'on': [] }
augroup load_smooth_scroll
  autocmd!
  autocmd BufReadPost * call plug#load('vim-smooth-scroll')
        \| autocmd! load_smooth_scroll
        \| noremap <silent> <C-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
        \| noremap <silent> <C-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
        \| noremap <silent> <C-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
        \| noremap <silent> <C-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>
augroup END

Plug 'kana/vim-textobj-user', { 'on': [] }
Plug 'kana/vim-textobj-indent', { 'on': [] }
Plug 'glts/vim-textobj-comment', { 'on': [] }
Plug 'wellle/targets.vim', { 'on': [] }
augroup load_textobj
  autocmd!
  autocmd BufReadPost * call plug#load('vim-textobj-user', 'vim-textobj-indent', 'vim-textobj-comment', 'targets.vim')
        \| autocmd! load_textobj
augroup END

Plug 'mg979/vim-visual-multi', { 'branch': 'master', 'on': [] }
augroup load_visual_multi
  autocmd!
  autocmd BufReadPost * call plug#load('vim-visual-multi')
        \| autocmd! load_visual_multi
augroup END

Plug 'dense-analysis/ale', { 'on': [] }
augroup load_ale
  autocmd!
  autocmd InsertEnter * call plug#load('ale')
        \| autocmd! load_ale
        \| let g:ale_lint_on_text_changed = 'never'
        \| let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
augroup END

Plug 'LunarWatcher/auto-pairs', { 'on': [] }
augroup load_auto_pairs
  autocmd!
  autocmd InsertEnter * call plug#load('auto-pairs')
        \| autocmd! load_auto_pairs
        \| call autopairs#AutoPairsTryInit()
augroup END

Plug 'luochen1990/rainbow', { 'on': [] }
augroup load_rainbow
  autocmd!
  autocmd InsertEnter * call plug#load('rainbow')
        \| autocmd! load_rainbow
        \| call rainbow_main#toggle()
augroup END

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim', { 'on': ['Files', 'Buffers', 'Rg', 'Lines', 'BLines', 'Colors', 'History', 'Commands'] }
Plug 'pbogut/fzf-mru.vim', { 'on': ['FZFMru'] }
let g:fzf_vim = {}
let g:fzf_layout = { 'window': { 'width': 0.92, 'height': 0.88 } }
nnoremap <Leader><Leader> :Commands<CR>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>fc :Colors<CR>
nnoremap <Leader>fw :Rg<CR>
nnoremap <Leader>fs :BLines<CR>
nnoremap <Leader>fS :Lines<CR>
nnoremap <Leader>fr :History<CR>
nnoremap <Leader>fm :FZFMru<CR>

Plug 'matze/vim-move', { 'on': ['<Plug>MoveBlockDown', '<Plug>MoveBlockUp', '<Plug>MoveBlockLeft', '<Plug>MoveBlockRight'] }
vmap <S-h> <Plug>MoveBlockLeft
vmap <S-j> <Plug>MoveBlockDown
vmap <S-k> <Plug>MoveBlockUp
vmap <S-l> <Plug>MoveBlockRight

Plug 'easymotion/vim-easymotion', { 'on': ['<Plug>(easymotion-bd-w)', '<Plug>(easymotion-bd-jk)'] }
nnoremap <Leader>gw <Plug>(easymotion-bd-w)
nnoremap <Leader>gl <Plug>(easymotion-bd-jk)

Plug 'dyng/ctrlsf.vim', { 'on': ['<Plug>CtrlSFPrompt'] }
nnoremap <Leader>fp <Plug>CtrlSFPrompt

Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle'] }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': ['NERDTreeToggle'] }
let g:NERDTreeLimitedSyntax = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 28
nnoremap <Leader>tn :NERDTreeToggle<CR>

Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<C-u>WhichKey ','<CR>
let g:which_key_map = {}
let g:which_key_map.f = { 'name' : '+Find' }
let g:which_key_map.g = { 'name' : '+Goto' }
let g:which_key_map.t = { 'name' : '+Toggle' }
let g:which_key_timeout = 100
let g:which_key_display_names = {'<CR>': '↵', '<TAB>': '⇆', ' ': 'SPC'}
let g:which_key_sep = '→'
let g:which_key_map = {}
let g:which_key_centered = 1
let g:which_key_use_floating_win = 1
let g:which_key_floating_relative_win = 1
let g:which_key_disable_default_offset = 1
augroup load_which_key
  autocmd!
  autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
augroup END

Plug 'thinca/vim-quickrun', { 'on': ['QuickRun'] }
nnoremap <Leader>tr :QuickRun<CR>

Plug 'mtth/scratch.vim', { 'on': ['Scratch'] }
let g:scratch_top = 0
nnoremap <Leader>ts :Scratch<CR>

Plug 't9md/vim-choosewin', { 'on': ['<Plug>(choosewin)'] }
let g:choosewin_overlay_enable = 1
nnoremap <Leader>tw <Plug>(choosewin)

Plug 'mbbill/undotree', { 'on': ['UndotreeToggle'] }
nnoremap <Leader>tu :UndotreeToggle<CR>

Plug 'dstein64/vim-startuptime', { 'on': ['StartupTime'] }
nnoremap <Leader>tt :StartupTime<CR>

Plug 'terryma/vim-expand-region', { 'on': ['<Plug>(expand_region_expand)', '<Plug>(expand_region_shrink)'] }
map + <Plug>(expand_region_expand)
map _ <Plug>(expand_region_shrink)

Plug 'liuchengxu/vista.vim', { 'on': ['Vista', 'Vista!', 'Vista!!'] }
let g:vista_default_executive = 'vim_lsp'
nnoremap <Leader>tv :Vista!!<CR>

Plug 'voldikss/vim-floaterm', { 'on': ['FloatermNew', 'FloatermPrev', 'FloatermNext', 'FloatermToggle'] }
nnoremap <silent> <F7> :FloatermNew<CR>
tnoremap <silent> <F7> <C-\><C-n>:FloatermNew<CR>
nnoremap <silent> <F8> :FloatermPrev<CR>
tnoremap <silent> <F8> <C-\><C-n>:FloatermPrev<CR>
nnoremap <silent> <F9> :FloatermNext<CR>
tnoremap <silent> <F9> <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <F12> :FloatermToggle<CR>
tnoremap <silent> <F12> <C-\><C-n>:FloatermToggle<CR>

if !has('python3')
  Plug 'puremourning/vimspector', { 'on': [] }
  augroup load_dap
    autocmd!
    autocmd BufReadPost * call plug#load('vimspector')
          \| autocmd! load_dap
          \| let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
  augroup END
endif

Plug 'mattn/emmet-vim', { 'for': ['html'] }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
Plug 'tpope/vim-fugitive', { 'on': ['G', 'Git'] }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': ['go'] }
Plug 'sbdchd/neoformat', { 'on': ['Neoformat'] }

Plug 'prabirshrestha/asyncomplete.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-buffer.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-file.vim', { 'on': [] }
Plug 'prabirshrestha/asyncomplete-lsp.vim', { 'on': [] }
Plug 'prabirshrestha/vim-lsp', { 'on': [] }
Plug 'mattn/vim-lsp-settings', { 'on': [] }
Plug 'hrsh7th/vim-vsnip', { 'on': [] }
Plug 'hrsh7th/vim-vsnip-integ', { 'on': [] }
augroup load_completion
  autocmd!
  autocmd InsertEnter * call plug#load('asyncomplete.vim', 'asyncomplete-buffer.vim', 'asyncomplete-file.vim', 'asyncomplete-lsp.vim', 'vim-lsp', 'vim-lsp-settings', 'vim-vsnip', 'vim-vsnip-integ')
        \| autocmd! load_completion
        \| inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
        \| inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
        \| inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<CR>"
        \| call asyncomplete#enable_for_buffer()
        \| call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({ 'name': 'buffer', 'allowlist': ['*'], 'blocklist': ['go'], 'completor': function('asyncomplete#sources#buffer#completor'), 'config': { 'max_buffer_size': 5000000 } }))
        \| call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({ 'name': 'file', 'allowlist': ['*'], 'priority': 10, 'completor': function('asyncomplete#sources#file#completor') }))
        \| let g:lsp_diagnostics_enabled = 0
        \| call lsp#enable()
        \| if executable('clangd') | call lsp#register_server({ 'name': 'clangd', 'cmd': { server_info -> ['clangd', '-background-index'] }, 'whitelist': ['c', 'cpp', 'objc', 'objcpp'] }) | endif
        \| if executable('basedpyright') | call lsp#register_server({ 'name': 'basedpyright', 'cmd': { server_info -> ['basedpyright-langserver', '--stdio'] }, 'whitelist': ['python'] }) | endif
augroup END

call plug#end()
