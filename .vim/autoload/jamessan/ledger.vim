fun! s:mark_cleared(ln)
  " Jump to main buffer
  .cc
  " Mark cleared
  call ledger#transaction_state_set(line('.'), '*')
  update
  " Switch back to quickfix
  wincmd w
  " Update cleared entries using ledger.vim's map
  call feedkeys("\<C-l>", 'mtx')
  " Go back to entry
  exe a:ln
endfun

fun! jamessan#ledger#reconcile_setup()
  nnoremap <silent> <buffer> <Space> :call <SID>mark_cleared(line('.'))<CR>
endfun
