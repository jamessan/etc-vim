function! jamessan#gutentags#init(path)
  " Ignore UNC paths, since they're expensive to search
  if a:path =~ '^\\'
    return 0
  endif
  return 1
endfunction
