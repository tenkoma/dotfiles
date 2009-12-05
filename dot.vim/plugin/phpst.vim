" phpst - running PHPUnit scripts.
" Author: tenkoma (http://www.tenkoma.net)
"

scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

" Script Main
if exists('g:loaded_phpst')
  finish
endif

let s:original = escape(&statusline, ' ')

function! PHPUnit()
  let s:save_reg=@a
  let s:script_name = expand("%:p")
  new phpunit_result | r!phpunit #
  "try
  "  redir @a
  "  silent exec '!phpunit --colors %'
  "  redir END
  "finally
  "  redraw!
  "endtry

  "exec "new"
  "put a
  "1,2g/^$/d
  "0 put = 'Command'
  setf vim
  set bufhidden=hide noswapfile noro nomodified
  let @a=s:save_reg
endfunction

au BufRead,BufNewFile *.php :command! PHPUnit :call PHPUnit()

let g:loaded_phpst = 1
let &cpoptions = s:save_cpoptions
