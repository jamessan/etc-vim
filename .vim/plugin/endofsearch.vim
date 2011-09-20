fun! EndOfSearch()
    let s = '//e<CR>'
    if v:operator == 'c'
        let s .= '<C-r>=setreg("/", @/)<CR><BS>'
    else
        let s .= ':let @/=@/<CR>'
    endif
    silent! call repeat#set(s, -1)
endfun
onoremap <expr> <silent> <Leader>s EndOfSearch()
