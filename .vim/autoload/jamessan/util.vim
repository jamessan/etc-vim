function! jamessan#util#getcwd() abort
  if exists(':tcd')
    if !haslocaldir() && haslocaldir(-1, 0)
      return getcwd(-1, 0)
    endif
  endif
  return getcwd()
endfunction
