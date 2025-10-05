" Private function to show error messages
function! s:Cuefix_ShowErr(msg)
  redraw
  echohl ErrorMsg
  echom "Cuefix: " . a:msg
  echohl None
endfunction



" Private function to delete a specific line from g:cfile file
function! s:Cuefix_DelLineInCFile(cfile_lnum) abort
  " Vsplit-open quickfix source file and remove specified line
  silent! exec 'vsplit ' . g:cfile
  silent! exec a:cfile_lnum
  silent! exec "normal! dd"
  silent! exec 'wq'
endfunction



" Cuefix Session Opener
" - gets quickfix source file (GCC/MISRA formatted/unformatted file)
" - if errorformat is set, uses it; or else sets a default format
" - if user allowed it, creates session-specific easy-navigation keymaps
" - Sets up quickfix entry background/highlight settings as user chose
" - opens quickfix window
function! cuefix#Cuefix_Open(fname) abort
  " Ensure we have a proper cfile input and file is accessible
  let g:cfile = ''
  if empty(a:fname)
    call s:Cuefix_ShowErr("No filename specified!")
    return
  elseif !filereadable(a:fname)
    call s:Cuefix_ShowErr("File not readable - " . fnameescape(a:fname))
    return
  endif
  let g:cfile = a:fname

  " Setup errorformat, quickfix input and keymaps if user allowed
  if exists('g:cuefix_errfmt')
    set errorformat=g:cuefix_errfmt
  else
    set errorformat=%-G#\ %f,%f:%l:%c:%m
  endif
  exec 'cfile ' . fnameescape(g:cfile)
  if !exists('g:cuefix_no_keymaps')
    nnoremap <C-d> <C-W><Down>:call cuefix#Cuefix_Del()<CR>
    nnoremap <C-x><C-Down> :cclose<CR>
    if exists('g:cuefix_lpos') && g:cuefix_lpos ==# 'top'
      nnoremap <C-Down> :cn<CR><C-w><Down>zt<CR>
      nnoremap <C-Up> :cp<CR><C-w><Down>zt<CR>
    else
      nnoremap <C-Down> :cn<CR>
      nnoremap <C-Up> :cp<CR>
    endif
  endif

  " open quickfix after proper configuration
  if exists('g:cuefix_nohl')
    autocmd FileType qf highlight QuickFixLine ctermbg=NONE guibg=NONE
    autocmd FileType qf setlocal cursorline
  else
    autocmd FileType qf highlight clear QuickFixLine
    autocmd FileType qf setlocal nocursorline
  endif
  if exists('g:cuefix_lpos')
    if g:cuefix_lpos ==# 'top'
      autocmd FileType qf setlocal scrolloff=0
    elseif g:cuefix_lpos ==# 'center'
      autocmd FileType qf setlocal scrolloff=999
    endif
  endif
  copen
  set lazyredraw
endfunction



" Cuefix Entry Deleter
" - Deletes current quickfix entry from quickfix source file
" - Deletes all invalid lines till next valid entry is found
function! cuefix#Cuefix_Del() abort
  if !exists('g:cfile') || !filereadable(g:cfile) || len(getqflist()) == 0
	  call s:Cuefix_ShowErr("Session not found or invalid!")
	  return
  endif
  let qfitem = getqflist({'idx': 0, 'items': 0})
  let cfile_lnum = qfitem.idx
  " Remove current quickfix entry (and any following invalid lines)
  " and move on to next quickfix entry
  call s:Cuefix_DelLineInCFile(cfile_lnum)
  while 1
    silent! exec 'cfile ' . fnameescape(g:cfile)
    copen
    exec 'cc' . cfile_lnum
    if &filetype !=# 'qf'
      break
    endif
    call s:Cuefix_DelLineInCFile(cfile_lnum)
  endwhile
  "Reposition quickfix cursor line
  if exists('g:cuefix_lpos')
    if g:cuefix_lpos ==# 'top'
      let zop = 'zt'
    elseif g:cuefix_lpos ==# 'center'
      let zop = 'zz'
    endif
    call feedkeys("\<C-w>\<Down>" . zop . "\<CR>")
  endif
  redraw
endfunction
