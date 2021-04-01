function! jamessan#stl#config()
  let stl = '[%n]%<'
  let stl .= '%{pathshorten(fnamemodify(expand("%"), ":~:."))}'
  let stl .= jamessan#stl#sy_stats()
  let stl .= '%m%r '  " flags
  let stl .= '%q'     " quickfix/location list name
  let stl .= '%h%w '
  let stl .= '%#ErrorMsg#%{&paste?"paste":""}%*'
  let stl .= '%#WarningMsg#%{(&ff=="unix")?"":",".&ff}%*'
  let stl .= '%#WarningMsg#%{(empty(&fenc)||&fenc=="utf-8")?"":",".&fenc}%*'
  let stl .= '%y'     " filetype
  let stl .= '%='     " right align
  let stl .= jamessan#stl#neomake()
  let stl .= '[0x%04.4B]'  " current char
  let stl .= '[%c%V]'
  let stl .= '[%p%% line %l of %L]'  " position in buffer
  return stl
endfunction

function! jamessan#stl#sy_stats()
  let stats=''
  let sy = get(b:, 'sy', {})
  if !empty(sy) && !empty(get(sy, 'updated_by', ''))
    let [added, modified, deleted] = sy#repo#get_stats()
    let stats = printf('[+%d ~%d -%d]', added, modified, deleted)
  endif
  return stats
endfunction

function! jamessan#stl#neomake()
  let status = ''
  try
    let status = neomake#statusline#get(winbufnr(0))
  catch
  endtry
  return status
endfunction
