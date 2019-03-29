function! jamessan#stl#config()
  let stl = '[%n]%<'
  let stl .= pathshorten(fnamemodify(expand('%'), ':~:.'))
  let stl .= s:sy_stats()
  let stl .= '%m%r '  " flags
  let stl .= '%q'     " quickfix/location list name
  let stl .= '%h%w '
  let stl .= s:cond_highlight('paste', 'ErrorMsg', &paste)
  let stl .= s:cond_highlight(&ff, 'WarningMsg', &ff != 'unix')
  let stl .= s:cond_highlight(&fenc, 'WarningMsg', !empty(&fenc) && &fenc != 'utf-8')
  let stl .= '%y'     " filetype
  let stl .= '%='     " right align
  let stl .= s:neomake()
  let stl .= '[0x%04.4B]'  " current char
  let stl .= '[%c%V]'
  let stl .= '[%p%% line %l of %L]'  " position in buffer
  return stl
endfunction

function! s:sy_stats()
  let stats=''
  let sy = get(b:, 'sy', {})
  if !empty(get(sy, 'updated_by', ''))
    let [added, modified, deleted] = sy#repo#get_stats()
    let stats = printf('[+%d ~%d -%d]', added, modified, deleted)
  endif
  return stats
endfunction

function! s:cond_highlight(s, hi, cond)
  if a:cond
    return printf('%%#%s%%*/', a:s, a:hi)
  else
    return ''
  endif
endfunction

function! s:neomake()
  let status = ''
  try
    let status = neomake#statusline#get(bufnr(''))
  catch
  endtry
  return status
endfunction
