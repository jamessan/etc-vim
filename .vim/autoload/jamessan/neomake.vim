function! jamessan#neomake#build_all_adjust(ln) abort
  " build_all does its own post-processing which outputs duplicate
  " information.  Elide this line
  if a:ln =~ '^FAULT_DETAILS'
    return ''
  endif
  " Determine the root of the workspace
  let root = jamessan#util#getcwd()
  let root = substitute(root, '/c4_working/views/[^/]\+\zs/.*', '', '')
  " Translate all the super-relative ../../../../../catmerge/.... paths
  " to absolute paths based on 'root'
  let ln = substitute(a:ln, '[./]\+/catmerge', root . '/safe/catmerge', 'g')
  " Translate 'Time elapsed ($stage): HH:MM::SS' lines to use . for time
  " separation so they aren't treated as error lines
  if ln =~ 'Time elapsed'
    let ln = substitute(ln, ':', '.', 'g')
  endif
  return ln
endfunction

function! jamessan#neomake#make_post(entry) abort
  if a:entry.text =~ 'recipe for target'
    let a:entry.valid = -1
  endif
endfunction

function! jamessan#neomake#c_lint_args() abort
  return ['clint', 'LINT_FILE='. expand('%')]
endfunction
