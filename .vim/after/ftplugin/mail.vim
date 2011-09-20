fun! FormatMail()
    let headerPattern = 'mailHeader\%(Key\)\=\|mailSubject'
    if synIDattr(synID(v:lnum, 1, 1), 'name') !~# headerPattern
        return -1
    endif
    return 0
endfun

setl formatexpr=FormatMail()
