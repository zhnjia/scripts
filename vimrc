set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'wincent/command-t'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/vim-powerline'
Plugin 'luochen1990/rainbow'
Plugin 'altercation/vim-colors-solarized'
Plugin 'majutsushi/tagbar'
Plugin 'tmhedberg/matchit'
Plugin 'vim-scripts/a.vim'
Plugin 'rking/ag.vim'
Plugin 'vim-scripts/gtags.vim'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" rainbow
let g:rainbow_active = 1

set laststatus=2
set encoding=utf-8
set t_Co=256
set tabstop=4
set shiftwidth=4
set softtabstop=4
set nosmarttab
set scrolloff=3
set expandtab
set showmatch
set number
"set nowrap
set guioptions-=m
set guioptions-=t
set guioptions-=T
set guioptions-=L
set guioptions-=r
set guioptions-=b
set cindent
set nobackup
set incsearch
"set ignorecase
set hlsearch
"highl CursorLine cterm=NONE ctermbg=black
"hi CursorLine  ctermbg=black
set cursorline
set wildignore+=*.o,*.obj,.git
set fillchars+=stl:\ ,stlnc:\
let mapleader=","

set background=dark
syntax on

"**********************************************************************************
"solarized
let g:solarized_termcolors=256

colorscheme solarized

"**********************************************************************************
"shortcut key
nmap j gj
nmap k gk
nmap <leader><leader>x :mks! ~/.vim/session/prj.vim<CR>:qa!<CR>
nmap <leader><leader>s :mks! ~/.vim/session/prj.vim<CR>
nmap <silent> <leader><leader>m :marks<CR>
nmap <leader><leader>c "+y
nmap <leader><leader>n :bn<CR>
nmap <leader><leader>p :bp<CR>
"nmap <leader>w <c-w>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
nmap gl :lnext<CR>

imap ( ()<ESC>i
imap [ []<ESC>i
"imap { {<CR>}<ESC>O

"**********************************************************************************
"getfilename
nmap <silent> <S-F2> :let @+=expand('%:p') . ":" . line('.')<CR>
nmap <silent> <F2> :let @+=expand('%:p:t') . ":" . line('.')<CR>

map <silent> <C-Insert> <ESC>"+y
map <silent> <S-Insert> <ESC>"+p<ESC>

" Ag
let g:ag_highlight = 1
nmap <F3> :Ag <C-R>=expand("<cword>")<CR><CR>
nmap <C-F3> :Ag<space>
nmap <C-F3> :%s/<C-R>=expand("<cword>")<CR>/<C-R>=expand("<cword>")<CR>/gc<Left><Left><Left>

" ultisnips
let g:UltiSnipsExpandTrigger="<c-j>"

map Q gQ
map <F5> :make<CR>
map <C-F5> Qmake<Space>
"autocmd CmdwinEnter * map <buffer> <F5> <CR>q:

"fugitive
nmap <leader>f :Ggrep <C-R>=expand("<cword>")<CR><CR>

"set tags=tags
"**********************************************************************************
"cscope
"set csto=0
"set nocst
""nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
""nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
""nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
""nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
""nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
""nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
""nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
""nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
"nmap <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
""nmap <leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
""nmap <leader>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
""nmap <leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>
"set cscopequickfix=s-,c-,d-,i-,t-,e-
"set nocsverb
"if filereadable("cscope.out")
"    execute "cs add cscope.out"
"endif
"set csverb

"**********************************************************************************
"font
"set guifont=DejaVu\ Sans\ Mono\ 10
"set guifont=Ubuntu\ Mono\ 12
set guifont=Hack\ 11


nmap <silent> <C-F8> :cp<CR>
nmap <silent> <F8> :cn<CR>

"**********************************************************************************
"tagbar
"map <silent> <F6> :TagbarToggle<CR>
map <silent> <F6> :call tagbar#OpenWindow('fcj')<CR>
let g:tagbar_left = 1
let g:tagbar_width = 40

"**********************************************************************************
"NERDtree
map <silent> <F4> :NERDTreeToggle<CR>
let g:NERDTreeWinPos="right"
let NERDTreeIgnore=['tags', 'cscope.in.out', 'cscope.files', 'cscope.out', 'cscope.po.out', 'GTAGS', 'GRTAGS', 'GPATH']

autocmd BufEnter *.* if &modifiable | NERDTreeFind | wincmd p | endif

"**********************************************************************************
"CtrlP"
"nnoremap <silent> <leader>f :CtrlP<CR>
"nnoremap <silent> <leader>t :CtrlPTag<CR>
"let g:ctrlp_working_path_mode = '0'
"let g:ctrlp_regexp = 1
"let g:ctrlp_max_files = 0
"let g:ctrlp_max_depth = 40
"let g:ctrlp_max_height = 15
"let g:ctrlp_custom_ignore = {
"    \ 'dir' : '\v[\/](\.git|output|android_tools|tvui)$',
"    \ 'file' : '\v\.(class)$'
"    \ }
""\ 'file': '\v(\.i|\.cpp|\.cc|\.h|\.c|\.bream|\.java|\.inc|\.js)@<!$',
""let g:ctrlp_user_command = 'find %s -name "*.bream" -o -name "*.cpp" -o -name "*.h" -o -name "*.c" -o -name "*.java" -o -name api -o -path "./.git" -prune -type f'
"let g:ctrlp_dotfiles = 0
"let g:ctrlp_match_window_reversed = 0
"let g:ctrlp_switch_buffer = 'Et'

"**********************************************************************************
"-- omnicppcomplete setting --
set completeopt=menu,menuone
let OmniCpp_MayCompleteDot = 1 " autocomplete with .
let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included
"files
let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype  in popup
"window
let OmniCpp_GlobalScopeSearch=1
let OmniCpp_DisplayMode=1
let OmniCpp_DefaultNamespaces=["std"]

"**********************************************************************************
"powerline
let g:Powerline_symbols = 'fancy'
let g:Powerline_stl_path_style = 'filename'
let g:Powerline_colorscheme = 'solarized'
"let g:Powerline_theme = 'solarized256'
let g:Powerline_mode_n = 'N'
let g:Powerline_mode_i = 'I'
let g:Powerline_mode_R = 'R'
let g:Powerline_mode_v = 'V'
let g:Powerline_mode_V = 'V-L'
let g:Powerline_mode_cv = 'V-B'
let g:Powerline_mode_s = 'S'
let g:Powerline_mode_S = 'S-L'
let g:Powerline_mode_cs = 'S-B'

"**********************************************************************************
"errorformat
"set errorformat=[my%.breamc]\ %f:%l:%c:\ error:\ %m

"function CompileQtSet()
"    set errorformat=[my%.breamc]\ %f:%l:%c:\ error:\ %m
"    set makeprg=platforms/qtbream/tools/oupenghd/build_oupeng.sh\ -d\ --nosdk
"endfunction

"**********************************************************************************
"mark
let loaded_matchit = 1

"YouCompleteMe
let g:ycm_key_invoke_completion = '<C-S-Space>'
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']

" syntastic
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1

" for my own code
if filereadable(".etc/profile/vimrc")
    execute "so .etc/profile/vimrc"
endif

" Auto-update GTags database from current file
let g:Gtags_Auto_Update = 1
nmap gtu                       :! global -v -u && htags -v && echo -e "\nGtags and Htags updated."<CR>
" GTags Find definition or reference of object under Cursor (depends on the context, see $ info global )
"nmap gtfc   :GtagsCursor<CR>
nmap <leader>d   :GtagsCursor<CR>
" GTags Find Reference to object under cursor
"nmap gtfr   :Gtags -r<CR><CR>
nmap <leader>r   :Gtags -r<CR><CR>
" GTags List tags from current file
nmap gtl    :Gtags -f %<CR>
" GTags List all *.c files
nmap gtlc   :sp<CR> :Gtags -P \.c$<CR> :q<CR>
" GTags List all *.h files
nmap gtlh   :sp<CR> :Gtags -P \.h$<CR> :q<CR>
" GTags Grep
nmap gtg    :Gtags -ge<Space>
" GTags Grep among Filenames
nmap gtgf   :Gtags -P<Space>
" GTags Grep for word under Cursor
nmap gtgc   :mat Search /<C-r>=expand("<cword>")<CR>/<CR>:Gtags -g<CR><CR>
" Open GOZilla
nmap goz    :! gozilla HTML/index.html<CR>

" CommandT
let g:CommandTFileScanner = "watchman"
let g:CommandTMaxHeight = 15
"let g:CommandTMatchWindowReverse = 1
let g:CommandTMaxFiles = 1000000
let g:CommandTMaxDepth = 40
let g:CommandTSmartCase = 1

map <C-x><C-c> :wqa<CR>
