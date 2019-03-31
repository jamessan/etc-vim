function! jamessan#stl#config()
  let stl = '[%n]%<'
  let stl .= pathshorten(fnamemodify(expand('%'), ':~:.'))
  let stl .= s:sy_stats()
  let stl .= '%m%r '  " flags
  let stl .= '%q'     " quickfix/location list name
  let stl .= '%h%w '
  let stl .= s:cond_highlight([
        \ {'desc': 'paste', 'hl': 'ErrorMsg', 'enabled': &paste},
        \ {'desc': &ff, 'hl': 'WarningMsg', 'enabled': &ff != 'unix'},
        \ {'desc': &fenc, 'hl': 'WarningMsg', 'enabled': !empty(&fenc) && &fenc != 'utf-8'}
        \])
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

function! s:cond_highlight(checks)
  let strs = map(filter(a:checks, { idx, d -> d.enabled }), { idx, d -> printf('%%#%s#%s%%*', d.hl, d.desc) })
  return join(strs, '/')
endfunction

function! s:neomake()
  let status = ''
  try
    let status = neomake#statusline#get(bufnr(''))
  catch
  endtry
  return status
endfunction
