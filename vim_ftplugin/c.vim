highlight OverLengthC ctermbg=darkred ctermfg=white guibg=#890000
match OverLengthC /\%>80v.\+\|\s\+$/
set colorcolumn=80

set cinoptions=e-0
set softtabstop=4
imap { {<CR>}<ESC>k$

