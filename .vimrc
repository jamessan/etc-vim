" General
set nocompatible " get out of horrible vi-compatible mode
let &tenc=&enc
set enc=utf-8
scriptencoding utf-8
set history=10000 " How many lines of history to remember
set ffs=unix,dos,mac

call pathogen#infect()

" Theme/Colors

" Change the cursor to an underline in insert mode
if &term =~ 'xterm\|screen'
    set t_SI=[4\ q
    set t_EI=[2\ q
endif

if &t_Co >= 88
    colorscheme janah
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

" Vim UI

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
set statusline=[%n]%<
set statusline+=%{pathshorten(fnamemodify(expand('%'),':~:.'))}
set statusline+=%{jamessan#stl#sy_stats()}
set statusline+=%m%r\                        " flags
try
    set statusline+=%q                       " Added in 7.3
catch /^Vim(set):E539/
endtry
set statusline+=%h%w\ 
set statusline+=%#ErrorMsg#%{&paste?'paste/':''}%*
set statusline+=%#WarningMsg#%{jamessan#stl#fileformat()}%*
set statusline+=%#WarningMsg#%{jamessan#stl#encoding()}%*
set statusline+=%y                           " filetype
set statusline+=%=                           " right align
set statusline+=[0x%04.4B]                   " current char
set statusline+=[%c%V]
set statusline+=[%p%%\ line\ %l\ of\ %L]     " position in buffer
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

filetype plugin indent on
syntax enable

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
let g:signify_vcs_list = filter([ 'git', 'hg', 'accurev', 'svn', 'bzr' ], 'executable(v:val)')

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

function! s:GenDaqTags(workspace, etags) abort
    let cwd = getcwd()
    let chdir = haslocaldir() ? 'lcd' : 'cd'
    let workspace = fnamemodify(expand(a:workspace), ':p')
    if a:etags
        let outname = 'TAGS'
        let etags = '-e'
    else
        let outname = 'tags'
        let etags = ''
    endif
    " Remove the trailing slash, since that causes problems with
    " --tag-relative
    let workspace = workspace[:-2]
    let opts = etags .' -I CSX_CLASS_EXPORT,FBE_API_CALL --extra=+fq --fields=+Sia --languages=C,C++ --c-kinds=+p --c++-kinds=+p -R --tag-relative=yes'
    exe chdir .' '. fnameescape(workspace.'/safe/catmerge')
    if has('win32') || has('win64')
        exe '!start /b ctags '. opts .' -f '. workspace .'\'.outname.'.product --exclude=mgmt . ../Targets/armada64_checked ../../sys-common'
    else
        exe '!ctags '. opts .' -f '. workspace .'/'.outname.'.product --exclude=mgmt . ../Targets/armada64_checked ../../sys-common &'
    endif
    exe chdir .' mgmt'
    if has('win32') || has('win64')
        exe '!start /b ctags '. opts . ' -f '. workspace .'\'.outname.'.daq .'
    else
        exe '!ctags '. opts .' -f '. workspace .'/'.outname.'.daq . &'
    endif
    exe chdir .' '. fnameescape(cwd)
endfunction

command! -nargs=1 -complete=dir -bang GenDaqTags call <SID>GenDaqTags(<f-args>, <bang>0)

" Make Y act like D, C, S, etc.
nnoremap Y y$

" Print out the english description of the unicode character under the cursor
nnoremap <Leader>un :UnicodeName<CR>

" Clear the active 'hlsearch' highlighting and refresh the screen
nnoremap <C-l> :nohlsearch<CR><C-l>

" SkyBison
nnoremap <Leader>e :<C-u>call SkyBison('e ')<CR>
nnoremap <Leader>b 2:<C-u>call SkyBison('b ')<CR>
nnoremap <Leader>tj 2:<C-u>call SkyBison('tj ')<CR>
nnoremap <Leader>h 2:<C-u>call SkyBison('h ')<CR>

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

        autocmd BufRead,BufNewFile */safe/catmerge/mgmt/{RemoteAgent,daq,MP_Engine}/* setlocal noexpandtab tabstop=4 shiftwidth=4
        autocmd BufRead,BufNewFile */views/*/{safe,sys-common}/* setlocal tags=./tags.daq;,./tags.product;
    augroup END
endif
" vim: set et sw=4:
