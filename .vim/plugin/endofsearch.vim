fun! EndOfSearch(omap)
    let s = "//e\<CR>"
    if a:omap
        if v:operator == 'c'
            let s .= "\<C-r>=setreg('/', @/)\<CR>\<BS>"
        else
            let s .= ":let @/=@/\<CR>"
        endif
        silent! call repeat#set(s, -1)
    else
        if v:version >= 704 || (v:version == 703 && has('patch610'))
            let s = 'gn'
        else
            let s .= ":\<C-u>let @/=@/\<CR>gv"
        endif
    endif
    return s
endfun
onoremap <expr> <silent> <Leader>e EndOfSearch(1)
vnoremap <expr> <silent> <Leader>e EndOfSearch(0)
