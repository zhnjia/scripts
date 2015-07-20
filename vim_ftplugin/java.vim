highlight OverLengthJava ctermbg=darkred ctermfg=white guibg=#890000
match OverLengthJava /\%>100v.\+\|\s\+$/
set colorcolumn=100

"set shiftwidth=8
"set softtabstop=4
"nmap O O<BS>
imap { {<CR>}<ESC>k$
