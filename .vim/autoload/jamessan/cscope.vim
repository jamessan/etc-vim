function! jamessan#cscope#setup_db()
  let fname = findfile('cscope.out', '.git;.git,.bzr;.bzr')
  if !empty(fname)
    try
      exe 'cscope add' fname
    catch
    endtry
  endif
endfunction
