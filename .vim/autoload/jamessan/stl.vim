function! jamessan#stl#sy_stats()
  let stats=''
  let sy = get(b:, 'sy', {})
  if !empty(get(sy, 'updated_by', ''))
    let [added, modified, deleted] = sy#repo#get_stats()
    let stats = printf('[+%d ~%d -%d]', added, modified, deleted)
  endif
  return stats
endfunction

function! jamessan#stl#fileformat()
  let ff = ''
  if &ff != 'unix'
    let ff = printf('%s/', &ff)
  endif
  return ff
endfunction

function! jamessan#stl#encoding()
  let enc = ''
  if &fenc != '' && &fenc != 'utf-8'
    let enc = printf('%s/', &fenc)
  endif
  return enc
endfunction
