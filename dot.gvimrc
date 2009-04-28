colorscheme torte

set columns=80
set lines=40
set number
set cursorline
set linespace=1

highlight CursorIM guibg=Purple guifg=NONE
highlight Search guibg=DarkBlue guifg=NONE
highlight CursorLine guifg=NONE guibg=#151515 gui=NONE

" MacVim用設定
if has("gui_macvim")
  "set gfn=Osaka-Mono:h14
  "set gfw=Osaka-Mono:h14
  set guifont=Monaco:h14
  set transparency=10
  set guioptions-=T
  set antialias
  set showtabline=2
  set imdisable

" Vim for Mac OS X
elseif has("gui_mac")
  set gfn=Osaka-Mono:h14
  set gfw=Osaka-Mono:h14
  set macatsui
  set antialias
  set transparency=240
  
  highlight IMLine guibg=DarkGreen guifg=Black
  
  map <D-w> :q<CR>gT
  map <D-t> :tabnew<CR>
  map <D-n> :new<CR>
  map <D-S-t> :browse tabe<CR>
  map <D-S-n> :browse split<CR>
  map <D-]> :tabn<CR>
  map <D-[> :tabp<CR>
  map <D-M-Right> :tabn<CR>
  map <D-M-Left> :tabp<CR>
  imap <D-M-Right> <C-o>:tabn<CR>
  imap <D-M-Left> <C-o>:tabp<CR>
end

autocmd VimEnter * tab all
" autocmd BufAdd * exe 'tablast | tabe "' . expand( "<afile") .'"'


" fullscreen (今のところWindows Only
" http://nanabit.net/blog/2007/11/01/vim-fullscreen/
"-----------------------------------------------------------
function! ToggleFullScreen()
  if &guioptions =~# 'C'
    set guioptions-=C
    if exists('s:go_temp')
      if s:go_temp =~# 'm'
        set guioptions+=m
      endif
      if s:go_temp =~# 'T'
        set guioptions+=T
      endif
    endif
    simalt ~r
  else
    let s:go_temp = &guioptions
    set guioptions+=C
    set guioptions-=m
    set guioptions-=T
    simalt ~x
  endif
endfunction
nnoremap <F6> :call ToggleFullScreen()<CR>

" Demoスタイルで文字をでっかくする
function! DefaultStyle ()
  if has("gui_macvim")
    set guifont=Monaco:h14
  else
    set guifont=M+1VM+IPAG_circle:h10:cSHIFTJIS
  endif

  set lines=45       " ウインドウの高さ
  set columns=80    " ウインドウの幅
endfunction
:command! DefaultStyle :call DefaultStyle()

function! DemoStyle ()
  if has("gui_macvim")
    set guifont=Monaco:h20
  else
    set guifont=M+1VM+IPAG_circle:h20:cSHIFTJIS
  endif
  set lines=30
  set columns=100
endfunction
:command! DemoStyle :call DemoStyle()

call DefaultStyle()
