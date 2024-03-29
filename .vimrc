" General
set nocompatible " get out of horrible vi-compatible mode
if !has('nvim')
    let &tenc=&enc
    set enc=utf-8
endif
scriptencoding utf-8
set history=10000 " How many lines of history to remember
set ffs=unix,dos,mac
set nomodeline " Let securemodelines plugin handle this

call pathogen#infect()

" Need this to be before last-position-jump autocmd so the filetype
" is defined by the time last-position-jump runs.
filetype plugin indent on
syntax enable

" Autocommands
if has('autocmd')
    augroup jamessan
        autocmd!
        autocmd FileType help nnoremap <buffer> <Enter> <C-]>

        if exists('##TermOpen')
            autocmd TermOpen * setlocal nolist
        endif

        if has('nvim-0.5')
            au TextYankPost * silent! lua vim.highlight.on_yank()
        endif

        autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") &&
                \   &ft !~# '\%(^git\%(config\)\@!\|commit\)'
                \ | exe "normal! g`\""
                \ | endif
    augroup END
endif

" Theme/Colors

" Change the cursor to an underline in replace mode, bar in insert
if has('nvim') && !has('nvim-0.2')
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
elseif &term =~ 'xterm\|screen\|tmux'
    set t_SI=[6\ q
    set t_SR=[4\ q
    set t_EI=[2\ q
endif

if exists('+termguicolors') && hostname() !~ 'cec\.lab\.emc\.com'
    if !has('nvim')
        if empty(&t_8f)
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        endif
        if empty(&t_8b)
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        endif
    endif
    set termguicolors
endif

if &t_Co >= 88
    if has('nvim-0.5')
        lua <<EOF
        require("tokyonight").setup({style = "moon"})
        vim.cmd[[colorscheme tokyonight]]
EOF
    else
        let g:jellybeans_use_term_italics = 1
        colorscheme jellybeans
    endif
elseif !has('nvim')
    set background=dark
end

" Files/Backups

set nobackup " make backup file ...
set writebackup " ... but delete after successfully saving file
if has("win32")
    set backupdir^=$HOME/vimfiles/backup " where to put backup file
    set directory^=$HOME/vimfiles/tmp// " where to put swapfiles
else
    set backupdir^=$HOME/.vim/backup " where to put backup file
    set directory^=$HOME/.vim/tmp// " where to put swapfiles
endif

" Vim UI

set title
let &titlestring = printf('%svim:%%t%%r%%m', has('nvim') ? 'n' : '')
if $TERM =~ 'screen\|tmux'
    let &titlestring = "\ek" . &titlestring . "\e\\"
endif

set diffopt+=horizontal
set linespace=0 " space it out just like unix
set wildmenu " turn on wild menu
set wildmode=longest:list
set cmdheight=2 " the command bar is 2 high
" Only use numbers if we can adjust the width of the number column
if exists('+numberwidth')
    " Use 'relativenumber' if Vim is new enough to show the actual line number
    " instead of 0 for the cursor's line
    if exists('+relativenumber') && (v:version > 703 || v:version == 703 && has('patch787'))
        set relativenumber
        " After 7.3.1115, also need to set 'number' to see the current line
        " number
        if v:version > 703 || v:version == 703 && has('patch1115')
            set number
        endif
    else
        set number " turn on line numbers
    endif
    set numberwidth=1 " Dynamically resize the 'number' column
endif
set lazyredraw " do not redraw while running macros (much faster)
set hidden " you can change buffer without saving
set backspace=2 " make backspace work normal
set whichwrap+=<,>  " cursor keys wrap to
if exists('+mouse')
    set mouse=a " use mouse everywhere
endif
set ignorecase " easier to ignore case for searching
set smartcase " match case if upper case characters are used in the search
set shortmess=atI " shortens messages to avoid 'press a key' prompt
set report=0 " tell us when anything is changed via :...
set noconfirm " Don't use dialog boxes to confirm choices
set ttyfast
if exists('+signcolumn')
    set signcolumn=yes
endif
if exists('+pumblend')
    set pumblend=20
endif

" Visual Cues

set ttimeoutlen=100 " Quickly detect normal escape sequences
set noequalalways " Don't automatically make windows the same size. <C-w>= works
set showmatch " show matching brackets
set showcmd
set matchtime=5 " how many tenths of a second to blink matching brackets for
set hlsearch " highlight searched for phrases
set incsearch " BUT do highlight as you type you search phrase
if exists('+inccommand')
    set inccommand=nosplit
endif
set list " show chars on end of line, whitespace, etc.
" gui_running implies multi_byte since GTK requires it
if has('multi_byte') || has('gui_running')
    set listchars=eol:¶,tab:»—,trail:·,extends:→,precedes:←
    if v:version >= 700
        set listchars+=nbsp:‗
    endif
    digraph ?! 8253  " Interrobang
    digraph xx 10060
    digraph \/ 10003
else
    set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<
endif
set visualbell t_vb= " don't blink and no noises
set statusline=%!jamessan#stl#config()
set laststatus=2 " always show the status line
set nostartofline " Don't move to ^ after various actions.
                  " :he 'sol' for an explanation of what actions

" Text Formatting/Layout

set formatoptions=tcrqn " See Help (complex)
if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j " Make joining comment lines work properly
end
set wrap
set sidescroll=1
set sidescrolloff=7
set noshiftround
set cpoptions+=n " When 'wrap' is enabled, the 'number' column is used to
                 " display wrapped text
set autoindent
set tags=.git/tags;.git,.bzr/tags;.bzr,./tags;,tags

if has('nvim-0.5')
    lua <<EOF
local nvim_lsp = require 'lspconfig'

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  buf_set_option('tagfunc', 'v:lua.vim.lsp.tagfunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  if vim.fn.has('nvim-0.9') then
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  else
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  end
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

for _, lsp in ipairs({ "rust_analyzer", "clangd" }) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
    }
end

if vim.fn.executable('pylsp') then
    nvim_lsp.pylsp.setup {
        on_attach = on_attach,
    }
end

require('lsp_lines').setup()
vim.diagnostic.config({ virtual_lines = { only_current_line = true }})
EOF
else
    " Not compatible with Vim or older nvim
    let g:lspconfig = 1
endif

" Python
let python_highlight_builtins = 1
let python_highlight_exceptions = 1
let python_highlight_space_errors = 1

" Perl
let perl_extended_vars=1 " highlight advanced perl vars inside strings
let perl_include_pod=1

" Shell
let is_posix=1

" C/C++
let [ c_gnu, c_space_errors, c_comment_strings ] = [ 1, 1, 1 ]
let [ c_no_comment_fold, c_ansi_typedefs, c_no_if0_fold ] = [ 1, 1, 1]

" Debian filetypes
let [ debchangelog_fold_enable, debcontrol_fold_enabled ] = [ 1, 1 ]

" gnupg
let g:GPGDefaultRecipients = [ '0xDFE691AE331BA3DB' ]

" Sy
let g:signify_skip = {'vcs': {'allow': ['git', 'hg', 'svn', 'bzr']}}
" Only highlight the number column, if it's supported, otherwise use blank
" text in the sign column
let s:sign = (has('nvim') || has('vim-8.2.3874')) ? "" : "\u00A0"
let g:signify_sign_add = s:sign
let g:signify_sign_change = s:sign
let g:signify_sign_delete = s:sign
let g:signify_sign_delete_first_line = s:sign
let g:signify_sign_show_count = v:false
let g:signify_number_highlight = 1

" securemodelines
let g:secure_modelines_allowed_items = [
            \ "iskeyword",   "isk",
            \ "textwidth",   "tw",
            \ "tabstop",     "ts",
            \ "shiftwidth",  "sw",
            \ "expandtab",   "et",   "noexpandtab", "noet",
            \ "filetype",    "ft",
            \ "foldmethod",  "fdm",
            \ "readonly",    "ro",   "noreadonly", "noro",
            \ "rightleft",   "rl",   "norightleft", "norl",
            \ "spell",
            \ "spelllang"
            \ ]

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
nnoremap <silent> <Leader>g :Grepper<CR>
nnoremap <silent> <Leader>lg :Grepper -noquickfix<CR>
let g:grepper = {}
let g:grepper.tools = ['rg', 'git', 'ag', 'ack', 'ack-grep', 'grep', 'findstr']

" Is this a Debian system?
if executable('dpkg-architecture')
    " Check whether multi-arch is actually supported
    call system('dpkg --assert-multi-arch')
    if v:shell_error == 0
        " Update 'path' with multi-arch paths
        for arch in split(system('dpkg --print-architecture; dpkg --print-foreign-architectures'))
            let ma_path=split(system('dpkg-architecture -a'.arch.' -qDEB_HOST_MULTIARCH'))[0]
            let &path .= ',/usr/include/'.ma_path
        endfor
        unlet arch
        unlet ma_path
    endif
endif

let ack = filter(['ack-grep', 'ack'], 'executable(v:val)')
if !empty(ack)
    let &grepprg=ack[0]. ' -H --column'
    set grepformat^=%f:%l:%c:%m
elseif executable('ag')
    let &grepprg='ag --vimgrep'
    set grepformat^=%f:%l:%c:%m
endif

" Load matchit
runtime macros/matchit.vim

" Custom Functions
if 1
    function! <SID>DiffPreview()
        vert new
        set buftype=nofile
        read #
        0d_
        diffthis
        wincmd p
        diffthis
    endfunction

    function! s:SynNames()
        let syn = {}
        let lnum = line('.')
        let cnum = col('.')
        let [effective, visual] = [synID(lnum, cnum, 0), synID(lnum, cnum, 1)]
        let syn.effective = synIDattr(effective, 'name')
        let syn.effective_link = synIDattr(synIDtrans(effective), 'name')
        let syn.visual = synIDattr(visual, 'name')
        let syn.visual_link = synIDattr(synIDtrans(visual), 'name')
        return syn
    endfunction

    function! s:SynInfo()
        let syn = s:SynNames()
        let info = ''
        if syn.visual != ''
            let info .= printf('visual: %s', syn.visual)
            if syn.visual != syn.visual_link
                let info .= printf(' (as %s)', syn.visual_link)
            endif
        endif
        if syn.effective != syn.visual
            if syn.visual != ''
                let info .= ', '
            endif
            let info .= printf('effective: %s', syn.effective)
            if syn.effective != syn.effective_link
                let info .= printf(' (as %s)', syn.effective_link)
            endif
        endif
        return info
    endfunction
endif

" Make Y act like D, C, S, etc.
nnoremap Y y$

" Clear the active 'hlsearch' highlighting and refresh the screen
nnoremap <C-l> :nohlsearch<CR><C-l>

" Make <C-p>/<C-n> act like <Up>/<Down> in cmdline mode, so they can be used
" to navigate history with partially completed commands
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

nnoremap <Leader>dp :call <SID>DiffPreview()<CR>
nnoremap <Leader>si :echo <SID>SynInfo()<CR>
if exists('*synstack')
    nnoremap <Leader>sI :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>
endif

" I can open the help with :help, kthx
map <F1> <nop>
map! <F1> <nop>
" vim: set et sw=4:
