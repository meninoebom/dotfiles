set nocompatible              " be iMproved, required
filetype off                  " required

" install Vim-Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" Unite is a commonly used resource for plugins to open panels and other temporary interfaces onscreen.
Plug 'Shougo/unite.vim'

" Indent guides
Plug 'Yggdroot/indentLine'

" Async Linter (meaning it shouldnt interrupt typing)
Plug 'w0rp/ale'

" Tabs and Status Bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Fuzzy Finder
Plug 'ctrlpvim/ctrlp.vim', { 'on': 'CtrlP' }

" Fuzzy Finder FZF which is supposedly faster than ctrlP
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Find in files
Plug 'mhinz/vim-grepper'

" See project as file tree
Plug 'Shougo/vimfiler.vim', { 'on': 'VimFiler' }

" Autocomplete
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Cursor movement shortcuts
Plug 'justinmk/vim-sneak'


" Support for easily toggling comments.
Plug 'tpope/vim-commentary'

" In addtion to the above plugins, you'll likely need some for individual
" non-standard syntaxes that aren't pre-bundled with vim. Here are some I use,
" these are required for me, but depending on what code you write, obviously
" this may differ for you.

" Proper JSON filetype detection, and support.
Plug 'leshill/vim-json'

" vim already has syntax support for javascript, but the indent support is
" horrid. This fixes that.
Plug 'pangloss/vim-javascript'

" supports syntax hightlighting for vim-javascript
" Plug 'crusoexia/vim-javascript-lib'

" React(jsx) syntax highlighting 
Plug 'mxw/vim-jsx'

" vim indents HTML very poorly on it's own. This fixes a lot of that.
" Plug 'indenthtml.vim'

" I write markdown a lot. This is a good syntax.
Plug 'tpope/vim-markdown'

" install Rigel colorscheme with vim-plug
Plug 'Rigellute/rigel'

call plug#end()

filetype plugin indent on " Filetype auto-detection
syntax enable
set number


" Color
" Set the background theme to dark - explaination here: https://vi.stackexchange.com/questions/12104/what-does-set-background-dark-do
set background=dark
set t_Co=256
"colorscheme monokai 
colorscheme rigel

" Don't forget set the airline theme as well.
let g:airline_theme = 'distinguished'
" This line enables the true color support.
let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
" Note, the above line is ignored in Neovim 0.1.5 above, use this line instead. WARNING: THIS MAY BE SCREWING UP COLORS IN TMUX
set termguicolors

" vim-airline plugin settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Tabs and spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab " use spaces instead of tabs.
set smarttab " let's tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " Match indents on new lines.
set smartindent " Intellegently dedent / indent new lines based on rules.

" We have VCS -- we don't need this stuff.
set nobackup " We have vcs, we don't need backups.
set nowritebackup " We have vcs, we don't need backups.
set noswapfile " They're just annoying. Who likes them?

" don't nag me when hiding buffers
set hidden " allow me to have buffers with unsaved changes.
set autoread " when a file has changed on disk, just load it. Don't ask.

" Make search more sane
set ignorecase " case insensitive search
set smartcase " If there are uppercase letters, become case-sensitive.
set incsearch " live incremental searching
set showmatch " live match highlighting
set hlsearch " highlight matches
set gdefault " use the `g` flag by default.

" allow the cursor to go anywhere in visual block mode.
set virtualedit+=block

"First, set last status to 2 using the following:
set laststatus=2

"set status line to %f for short file name
set statusline=%f

" leader is a key that allows you to have your own "namespace" of keybindings.
" You'll see it a lot below as <leader>
let mapleader = ","

" So we don't have to press shift when we want to get into command mode.
nnoremap ; :
vnoremap ; :

" So we don't have to reach for escape to leave insert mode.
inoremap jf <esc>

" create new vsplit, and switch to it.
noremap <leader>v <C-w>v

" bindings for easy split nav
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Use sane regex's when searching
nnoremap / /\v
vnoremap / /\v

" Clear match highlighting
noremap <leader><space> :noh<cr>:call clearmatches()<cr>

" Quick buffer switching - like cmd-tab'ing
nnoremap <leader><leader> <c-^>

" Visual line nav, not real line nav
" If you wrap lines, vim by default won't let you move down one line to the
" wrapped portion. This fixes that.
noremap j gj
noremap k gk

" Plugin settings:
" Below are some 'sane' (IMHO) defaults for a couple of the above plugins I
" referenced.

" Map the key for toggling comments with vim-commentary
nnoremap <leader>c <Plug>CommentaryLine

" Remap ctrlp to ctrl-t -- map it however you like, or stick with the
" defaults. Additionally, in my OS, I remap caps lock to control. I never use
" caps lock. This is highly recommended.
let g:ctrlp_map = '<c-t>'

" Let ctrlp have up to 30 results.
let g:ctrlp_max_height = 30

" IndentLine plugin settings
let g:indentLine_enabled = 1
let g:indentLine_char = "⟩"

" CtrlP plugin settings
" Space t or Space p opens Fuzzy Finder
nnoremap <Leader>fp :Grepper<Space>-query<Space>
nnoremap <Leader>fb :Grepper<Space>-buffers<Space>-query<Space>-<Space>

" vim-grepper plugin settings
" Space f p to type a search to find matches in entire project<Paste>
" Space f b to type a search to find matches in current buffers
nnoremap <Leader>fp :Grepper<Space>-query<Space>
nnoremap <Leader>fb :Grepper<Space>-buffers<Space>-query<Space>-<Space>

" vimfiler plugin settings
" Space backtick to toggle File Tree
" Space ~ to open File Tree from current buffer’s directory
map ` :VimFiler -explorer<CR>
map ~ :VimFilerCurrentDir -explorer -find<CR>

" deoplete plugin settings
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" vim-sneak plugin settings
" f <key> to jump to next <key>
" F <key> to jump to previous <key>
" f to following match
" s <key><key> to jump to next <key><key>
" S <key><key> to jump to previous <key><key>
" s to following match
let g:sneak#s_next = 1
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

" ale plugin settings
let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '.'
let g:ale_lint_on_enter = 0 " Less distracting when opening a new file

autocmd BufWritePre *.js,*.pl,*.rb :%s/\s+$//e
autocmd FileType js,pl,rb autocmd BufWritePre <buffer> %s/\s\+$//e
