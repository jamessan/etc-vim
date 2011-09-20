" http://dollyfish.net.nz/blog/2008-04-01/mutt-and-vim-custom-autocompletion
fun! LBDBCompleteFn(findstart, base)
    let line = getline('.')
    if a:findstart
        " locate the start of the word
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '[^:,]'
            let start -= 1
        endwhile
        while start < col('.') && line[start] =~ '[:, ]'
            let start += 1
        endwhile
        return start
    else
        let res = []
        let query = substitute(a:base, '"', '', 'g')
        let query = substitute(query, '\s*<.*>\s*', '', 'g')
        for m in LbdbQuery(query)
            call complete_add(printf('"%s" <%s>', escape(m[0], '"'), m[1]))
            if complete_check()
                break
            endif
        endfor
        return res
    endif
endfun
set completefunc=LBDBCompleteFn

let s:regex = '^\%(To\|B\=CC\):'

ino <expr> <C-n> getline('.') =~? s:regex ? "\<lt>C-x>\<lt>C-u>" : "\<lt>C-n>"
ino <expr> <C-p> getline('.') =~? s:regex ? "\<lt>C-x>\<lt>C-u>" : "\<lt>C-p>"
