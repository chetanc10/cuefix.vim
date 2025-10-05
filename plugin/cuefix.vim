if exists('g:cuefix_loaded')
  finish
endif
let g:cuefix_loaded = 1

if !exists('g:cuefix_no_keymaps')
  nnoremap <C-x><C-q> :call cuefix#Cuefix_Open(input("Cuefix source file name: ", "", "file"))<CR>
endif

command! -bar -bang -nargs=1 -complete=file Cuefo call cuefix#Cuefix_Open(<q-args>)

command! -bar -bang Cuefd call cuefix#Cuefix_Del()

" vim: ts=2 sw=2 et
