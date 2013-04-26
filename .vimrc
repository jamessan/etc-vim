" General
set nocompatible " get out of horrible vi-compatible mode
let &tenc=&enc
set enc=utf-8
scriptencoding utf-8
set history=10000 " How many lines of history to remember
set ffs=unix,dos,mac

call pathogen#infect()

" Theme/Colors

" Let Vim know that screen/tmux can use bce
if &term =~ '^screen-.*-bce$'
    set t_ut=y
end
" Change the cursor to an underline in insert mode
if &term =~ 'xterm\|screen'
    set t_SI=[4\ q
    set t_EI=[2\ q
endif

if &t_Co >= 88 || has('gui_running')
    colorscheme jellyx
else
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
set makeef=error.err " When using make, where should it dump the file

" Vim UI

set diffopt+=horizontal
set linespace=0 " space it out just like unix
set wildmenu " turn on wild menu
set wildmode=longest:list
set ruler " Always show current positions along the bottom
set cmdheight=2 " the command bar is 2 high
" Only use numbers if we can adjust the width of the number column
if exists('+numberwidth')
    " Use 'relativenumber' if Vim is new enough to show the actual line number
    " instead of 0 for the cursor's line
    if exists('+relativenumber') && (v:version > 703 || v:version == 703 && has('patch787'))
        set relativenumber
    else
        set number " turn on line numbers
    endif
    set numberwidth=1 " Dynamically resize the 'number' column
endif
set lazyredraw " do not redraw while running macros (much faster)
set hidden " you can change buffer without saving
set backspace=2 " make backspace work normal
set whichwrap+=<,>,h,l  " backspace and cursor keys wrap to
set mouse=a " use mouse everywhere
set ignorecase " easier to ignore case for searching
set smartcase " match case if upper case characters are used in the search
set shortmess=atI " shortens messages to avoid 'press a key' prompt
set report=0 " tell us when anything is changed via :...
set noconfirm " Don't use dialog boxes to confirm choices
set ttyfast

" Visual Cues

set ttimeoutlen=100 " Quickly detect normal escape sequences
set noequalalways " Don't automatically make windows the same size. <C-w>= works
set showmatch " show matching brackets
set showcmd
set matchtime=5 " how many tenths of a second to blink matching brackets for
set nohlsearch " do not highlight searched for phrases
set incsearch " BUT do highlight as you type you search phrase
set list " show chars on end of line, whitespace, etc.
" gui_running implies multi_byte since GTK requires it
if has('multi_byte') || has('gui_running')
    set listchars=eol:¶,tab:»—,trail:·,extends:→,precedes:←
    if v:version >= 700
        set listchars+=nbsp:‗
    endif
    digraph ?! 8253  " Interrobang
else
    set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<
endif
set visualbell t_vb= " don't blink and no noises
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%f                           " filename
set statusline+=%m%r\                        " flags
try
    set statusline+=%q                       " Added in 7.3
catch /^Vim(set):E539/
endtry
set statusline+=%h%w\ 
set statusline+=[%n:                         " buffer number
set statusline+=%{&fileformat}/
set statusline+=%{strlen(&fenc)?&fenc:&enc}/ " encoding
set statusline+=%Y]                          " filetype
set statusline+=%=%<                         " right align
set statusline+=[0x%04.4B]                   " current char
set statusline+=[%03c%04V]                   " column
set statusline+=[%p%%\ line\ %l\ of\ %L]     " position in buffer
set laststatus=2 " always show the status line
set nostartofline " Don't move to ^ after various actions.
                  " :he 'sol' for an explanation of what actions

" Text Formatting/Layout

set formatoptions=tcrqn " See Help (complex)
set wrap
set sidescroll=1
set sidescrolloff=7
set smarttab
set noshiftround
set cpoptions+=n " When 'wrap' is enabled, the 'number' column is used to
                 " display wrapped text
set autoindent

filetype plugin indent on
syntax enable

" NetRW
let netrw_silent = 1

" VCSCommand
let VCSCommandDisableMappings = 1
let VCSCommandDisableExtensionMappings = 1

let buffalo_autoaccept = 1

" NERD Tree
let NERDTreeQuitOpen = 1

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
let g:GPGDefaultRecipients = [ '0x61326d40' ]

" securemodelines
let g:secure_modelines_allowed_items = [
            \ "iskeyword",   "isk",
            \ "textwidth",   "tw",
            \ "softtabstop", "sts",
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
    endif
endif

if executable('ack-grep') == 1
    set grepprg=ack-grep\ -H\ --column
    set grepformat^=%f:%l:%c:%m
elseif executable('ack') == 1
    set grepprg=ack\ -H\ --column
    set grepformat^=%f:%l:%c:%m
endif

" Custom Functions

function! <SID>ValidAltBuffer(bufnr)
    " &buftype requires +quickfix
    " Checking that it's '' should preclude quickfix, minibufexpl, etc from
    " being considered a valid buffer to switch to
    " bufwinnr() check is to make sure we don't have another window displaying
    " the buffer
    return (!has('quickfix') || getbufvar(a:bufnr, '&buftype') == '') && bufwinnr(a:bufnr) == -1
endfunction

function! <SID>FindBuffer(bufstart, cond, bufend, operand)
    exe "let l:bufnr = a:bufstart " . a:operand . " 1"
    exe "while l:bufnr " . a:cond . " " . a:bufend
        if buflisted(l:bufnr) && <SID>ValidAltBuffer(l:bufnr)
            exe "b " . l:bufnr
            return l:bufnr
        else
            exe "let l:bufnr = l:bufnr " . a:operand . " 1"
        endif
    endwhile
    return a:bufstart
endfunction

" For all windows/tabpages curbuf is displayed, execute cmd
function! <SID>ExeCmdInAllBufWindows(curbuf, cmd)
    let l:lz = &lz
    let &lz = 1

    let l:tbpgnr = tabpagenr()
    let l:winnr = winnr()
    " Maintain a list of [tabpage, bufinwindow, origwindow]
    let l:buflist = []
    for l:i in range(tabpagenr('$'))
        exe "tabn " . i+1
        let l:nr = winnr()
        for l:j in range(winnr('$'))
            exe l:j+1 . "wincmd w"
            if bufnr('') == a:curbuf
                call add(buflist, [l:i+1, l:j+1, l:nr])
            endif
        endfor
        exe l:nr . "wincmd w"
    endfor

    " For all the [tabpage, bufinwindow, origwindow] sets we have:
    " 1. change to tabpage
    " 2. change to bufinwindow
    " 3. change the buffer (as instructed by a:cmd)
    " 4. put the cursor back in origwindow
    for l:L in l:buflist
        exe "tabn " . l:L[0]
        exe l:L[1] . "wincmd w"
        exe a:cmd
        exe l:L[2] . "wincmd w"
    endfor

    " Change back to our original tabpage and window
    exe "tabn " . l:tbpgnr
    exe l:winnr . "wincmd w"
    let &lz = l:lz
endfunction

function! <SID>CloseIfOnlyWindow(force)
    let l:curbuf = bufnr('%')
    let l:displayedbufs = []
    for i in range(tabpagenr('$'))
        call extend(l:displayedbufs, tabpagebuflist(i+1))
    endfor

    " There is only one buffer being displayed and therefore only one
    " window/tabpage.  We can just delete the buffer
    if len(l:displayedbufs) == 1
        if a:force
            bd!
        else
            bd
        endif
        return
    endif

    let l:bufnr = l:curbuf
    let l:cmd = ''
    if buflisted(bufnr('#')) && <SID>ValidAltBuffer('#')
        let l:bufnr = bufnr('#')
        let l:cmd = 'b ' . l:bufnr
    else
        let l:bufnr = <SID>FindBuffer(l:curbuf, '>', 0, '-')
        if l:bufnr == l:curbuf
            let l:bufnr = <SID>FindBuffer(l:curbuf, '<=', bufnr('$'), '+')
        endif
        if l:bufnr == l:curbuf
            let l:cmd = 'enew'
        else
            let l:cmd = 'b ' . l:bufnr
        endif
    endif

    if count(displayedbufs, l:curbuf) > 1
        call <SID>ExeCmdInAllBufWindows(l:curbuf, l:cmd)
    else
        exe l:cmd
    endif

    if a:force
        exe 'bd! ' . l:curbuf
    else
        exe 'bd ' . l:curbuf
    endif
endfunction

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

fun! s:ToggleFugitiveStatusline(enter)
    if expand('<afile>') =~# '^fugitive:'
        if a:enter
            let &l:stl = substitute(&stl, '^%f', '%t%{fugitive#statusline()}', '')
        else
            set statusline<
        endif
    endif
endfunction

" Make Y act like D, C, S, etc.
nnoremap Y y$

" Print out the english description of the unicode character under the cursor
nnoremap <Leader>un :UnicodeName<CR>

" Clear the active 'hlsearch' highlighting and refresh the screen
nnoremap <C-l> :nohlsearch<CR><C-l>

" \-i (normal mode) inserts a single char, and then switches back to normal
nnoremap <Leader>i i <ESC>
nnoremap <Leader>I i <ESC>r

nnoremap <Leader>bd :call <SID>CloseIfOnlyWindow(0)<CR>
nnoremap <Leader>bD :call <SID>CloseIfOnlyWindow(1)<CR>
nnoremap <Leader>dp :call <SID>DiffPreview()<CR>
nnoremap <Leader>si :echo <SID>SynInfo()<CR>
if exists('*synstack')
    nnoremap <Leader>sI :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>
endif

" I can open the help with :help, kthx
map <F1> <nop>
map! <F1> <nop>
" Autocommands

if has('autocmd')
    augroup jamessan
        autocmd!
        autocmd FileType help nnoremap <buffer> <Enter> <C-]>

        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
                             \exe "normal! g'\"" | endif
        autocmd BufWinEnter * call <SID>ToggleFugitiveStatusline(1)
        autocmd BufWinLeave * call <SID>ToggleFugitiveStatusline(0)
    augroup END
endif
" vim: set et sts=4 sw=4:
