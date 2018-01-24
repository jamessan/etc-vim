function! jamessan#neomake#make_post(entry) abort
  if a:entry.text =~ 'recipe for target'
    let a:entry.valid = -1
  endif
endfunction

function! jamessan#neomake#c_lint_args() abort
  return ['clint', 'LINT_FILE='. expand('%')]
endfunction
