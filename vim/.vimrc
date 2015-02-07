set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'a'
"Bundle 'ctrlp'
"Bundle 'mark'
Bundle 'YouCompleteMe'
"Bundle 'bream'
"Bundle 'nerdtree'
Bundle 'tagbar'
Bundle 'vim-colors-solarized'
Bundle 'vim-indent-guides'
Bundle 'vim-powerline'
"Bundle 'syntastic'
"Bundle 'eclim'

filetype plugin indent on

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

"**********************************************************************************
"pathogen
call pathogen#infect()
syntax on
syntax enable
filetype plugin indent on
set background=dark

"**********************************************************************************
"solarized
let g:solarized_termcolors=256

"colorscheme desert
"colorscheme rainbowNeon
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
nmap <leader>w <c-w>
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

"Function key**********************************************************************
nmap <F3> :grep <C-R>=expand("<cword>")<CR><CR>
nmap <C-F3> :grep - <C-R>=expand("<cword>")<CR><C-left><left>
nmap <F4> :%s/<C-R>=expand("<cword>")<CR>/<C-R>=expand("<cword>")<CR>/gc<Left><Left><Left>
map Q gQ
map <F5> :make<CR>
map <C-F5> Qmake<Space>
"autocmd CmdwinEnter * map <buffer> <F5> <CR>q:

"**********************************************************************************

"map <F5> :LookupFile<CR>
"let g:LookupFile_TagExpr = string('./filenametags')
"let g:LookupFile_AllowNewFiles = 0

"**********************************************************************************
"NERDtree
"map <F4> :NERDTreeToggle<CR>
"let g:NERDTreeWinPos="right"
"let NERDTreeIgnore=['.git$[[dir]]', 'tags', 'cscope.in.out', 'cscope.files', 'cscope.out', 'cscope.po.out']

set tags=tags
"**********************************************************************************
"cscope
set csto=0
set nocst
"nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <leader>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
"nmap <leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>
set cscopequickfix=s-,c-,d-,i-,t-,e-
set nocsverb
if filereadable("cscope.out")
    execute "cs add cscope.out"
endif
set csverb

"**********************************************************************************
"compile
"map <F7> :make<CR>
"nmap <silent> <F7> :call MyMake()<CR>

"clang_complete
"let g:clang_complete_copen=1 

"**********************************************************************************
"font
set guifont=DejaVu\ Sans\ Mono\ 10
"set guifont=Ubuntu\ Mono\ 12

"**********************************************************************************
"quickfix
"let g:quickfixWindowStatus = 0
"function OpenQuickfixWindow()
"    if g:quickfixWindowStatus == 0
"        let g:quickfixWindowStatus = 1
"        exe 'copen'
"    endif
"endfunction
"
"function CloseQuickfixWindow()
"    if g:quickfixWindowStatus == 1
"        let g:quickfixWindowStatus = 0
"        exe 'cclose'
"    endif
"endfunction
"
"function ToggleQuickfixWindow()
"    if g:quickfixWindowStatus == 0
"        let g:quickfixWindowStatus = 1
"        exe 'copen'
"    elseif g:quickfixWindowStatus == 1
"        let g:quickfixWindowStatus = 0
"        exe 'cclose'
"    endif
"endfunction

"nmap <silent> <F8> :call ToggleQuickfixWindow()<CR>
"nmap <silent> ge :call ToggleQuickfixWindow()<CR>
nmap <silent> <C-F8> :cp<CR>
nmap <silent> <F8> :cn<CR>

"**********************************************************************************
"tagbar
nmap <silent> <F6> :TagbarToggle<CR>
let g:tagbar_left = 1
let g:tagbar_width = 40


"**********************************************************************************
"CtrlP"
"nnoremap <silent> <leader>f :CtrlP<CR>
"nnoremap <silent> <leader>t :CtrlPTag<CR>
let g:ctrlp_working_path_mode = '0'
let g:ctrlp_regexp = 1
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 40
let g:ctrlp_max_height = 15
let g:ctrlp_custom_ignore = {
    \ 'dir' : '\v[\/](\.git|output|android_tools|tvui)$',
    \ 'file' : '\v\.(class)$'
    \ }
"\ 'file': '\v(\.i|\.cpp|\.cc|\.h|\.c|\.bream|\.java|\.inc|\.js)@<!$',
"let g:ctrlp_user_command = 'find %s -name "*.bream" -o -name "*.cpp" -o -name "*.h" -o -name "*.c" -o -name "*.java" -o -name api -o -path "./.git" -prune -type f'
let g:ctrlp_dotfiles = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_switch_buffer = 'Et'

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
"insert bream log
"function Breamlog()
"    let line="Log.d(\"zjzjzj\", );"
"    call setline(".", line)
"endfunction

"imap <silent> <c-l> <ESC>:call Breamlog()<CR>V=$hi
"nmap <silent> <c-l> :call Breamlog()<CR>V=$hi

"**********************************************************************************
"ack
"set grepprg=git grep

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

"vimIM
"let g:vimim_cloud = 'google'
let g:vimim_cloud = 'google,sogou,baidu,qq'
let g:vimim_map = 'tab_as_gi'
let g:vimim_mode = 'dynamic'
"let g:vimim_mycloud = 0
"let g:vimim_mycloud = 0
"let g:vimim_punctuation = 2
"let g:vimim_shuangpin = 0
"let g:vimim_toggle = 'pinyin,google,sogou'
"

"indent guide
let g:indent_guides_guide_size=4

"eclim
let g:EclimCompletionMethod = 'omnifunc'

"YouCompleteMe
let g:ycm_key_invoke_completion = '<C-S-Space>'
"let g:ycm_key_list_select_completion = ['<C-TAB>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<C-S-TAB>', '<Up>']

"""**********************************************************************************
""BufExplorer
"nmap <silent> <F9> :BufExplorer<CR>
"let g:bufExplorerSortBy='name'       " Sort by the buffer's name.

" syntastic
let g:syntastic_check_on_open = 1

" for my own code
if filereadable(".etc/profile/vimrc")
    execute "so .etc/profile/vimrc"
endif

