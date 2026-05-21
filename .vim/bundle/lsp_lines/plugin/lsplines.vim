if exists("g:loaded_lsplines")
  finish
endif

lua require("lsp_lines").setup()

let g:loaded_lsplines = 1
