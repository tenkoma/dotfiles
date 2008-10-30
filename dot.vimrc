" tenkoma's .vimrc
" Note  "{{{1








" Basic  "{{{1
" Absolute  "{{{2

set nocompatible

" Encoding  "{{{2
" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

set enc=utf-8
set fencs=utf-8,iso-2022-jp,euc-jp,cp932

" Options  "{{{2

set number
set ruler
set modeline
set modelines=5
" バックスペースキーの動作
set backspace=2
" カーソルの上下に最低何行表示するか
set scrolloff=5
" □とか○でカーソル位置がずれないようにする
set ambiwidth=double
" テキスト整形オプション "よくわかってない
set formatoptions=tcroqnlM12
" ファイルタイプの自動識別
filetype plugin indent on
" シンタックスハイライト
syntax on

" highlight search
set ignorecase
set smartcase
set wrapscan
set hlsearch
set incsearch

" indent
set autoindent
set cindent
set smartindent
set expandtab tabstop=4 softtabstop=4 shiftwidth=4

" backup, directory
set backup
set backupcopy&
set backupdir=~/tmp
set backupskip&
set backupskip+=svn-commit.tmp,svn-commit.[0-9]*.tmp
set directory=~/tmp

" status line
set showcmd
" コマンド行高さ
set cmdheight=2
" always display statusline
set laststatus=2
" コマンドライン補完
set wildmenu
"  コマンド履歴
set history=1000
" マウス
set mouse=a
set ttymouse=xterm2

" TODO: もちょっとカスタマイズするのだわ
" default 'statusline' with 'fileencoding'.
let &statusline = ''
let &statusline .= '%<%f %h%m%r%w'
let &statusline .= '%='
let &statusline .= '%y' " filetype
let &statusline .= '[%{&fileencoding == "" ? &encoding : &fileencoding}]'
let &statusline .= '[%{&fileformat}]'
let &statusline .= '  %-14.(%l,%c%V%) %P'


" タイトル
set title
set titlestring=Vim:\ %f\ %h%r%m

" タブ/改行の表示
set list
set listchars=eol:<,tab:>-
"行末の半角スペースを強調する
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
" 長い行を折り返す
set wrap
" 括弧を閉じたとき括弧始まりに一瞬移動
set showmatch
" カーソル行を強調
set cursorline

" Input Method
set iminsert=0
set imsearch=0
" set imdisable

" 配色
highlight Search term=reverse ctermbg=DarkBlue ctermfg=NONE

" ポップアップメニュー
highlight Pmenu guibg=#666666
highlight PmenuSel guibg=#8cd0d3 guifg=#666666
highlight PmenuSbar guibg=#333333










" Utilities  "{{{1
" Misc  "{{{2

function! s:set_short_indent()
  setlocal expandtab softtabstop=2 shiftwidth=2
endfunction

"  vim7の設定 {{{2
"  TABでOmni completion
if v:version >= 700
  function! InsertTabWrapper()
     if pumvisible()
         return "\<c-n>"
     endif
     let col = col('.') - 1
     if !col || getline('.')[col - 1] !~ '\k\|<\|/'
         return "\<tab>"
     elseif exists('&omnifunc') && &omnifunc == ''
         return "\<c-n>"
     else
         return "\<c-x>\<c-o>"
     endif
 endfunction
 inoremap <tab> <C-R>=InsertTabWrapper()<CR>
endif







" Mappings  "{{{1

" Tab pages  "{{{2

" Command-line editting  "{{{2
" Emacsのような
cnoremap <C-A> <Home>
cnoremap <C-B> <Left>
cnoremap <C-D> <Del>
cnoremap <C-E> <End>
cnoremap <C-F> <Right>
cnoremap <C-N> <Down>
cnoremap <C-P> <Up>
cnoremap <Esc><C-B> <S-Left>
cnoremap <Esc><C-F> <S-Right>

" Insert Mode "{{{2
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-f> <Right>
inoremap <C-b> <Left>

"表示行単位で行移動
nnoremap j gj
nnoremap k gk

" Misc.  "{{{2

" 入れ替え
noremap ; :
noremap : ;

" 保存
nnoremap <F5> :<C-u>write<CR>

" 検索
" 検索キーを押した後、画面の真ん中に
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz








" Filetypes  "{{{1
" All filetypes  "{{{2

" Ruby, eruby, rails "{{{2
autocmd FileType ruby set tabstop=2 tw=0 sw=2 expandtab
autocmd FileType eruby set tabstop=2 tw=0 sw=2 expandtab
autocmd BufNewFile,BufRead app/*/*.rhtml set ft=mason fenc=utf-8
autocmd BufNewFile,BufRead app/**/*.rb set ft=ruby fenc=utf-8
autocmd BufNewFile,BufRead app/**/*.yml set ft=ruby fenc=utf-8
" action script "{{{2
autocmd BufNewFile,BufRead *.as set filetype=actionscript
autocmd BufNewFile,BufRead *.mxml set filetype=mxml
" JavaScript "{{{2
autocmd FileType *.js set tabstop=2 shiftwidth=2 softtabstop=2
autocmd Syntax javascript set foldmethod=indent
" PHP "{{{2
autocmd BufNewFile,BufRead *.thtml setfiletype php
autocmd BufNewFile,BufRead *.ctp setfiletype php
autocmd BufNewFile,BufRead *.tpl setfiletype php
let php_sql_query = 1
let php_htmlInStrings = 1
let php_noShortTags=1
let php_folding=1
let php_parent_error_open = 1
let php_parent_error_close = 1
autocmd Syntax php set fdm=syntax
autocmd Syntax php set foldmethod=syntax
"php 文法チェック<
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l









" Plugins  "{{{1
"モジュールを有効にする
source $VIMRUNTIME/macros/matchit.vim

" rails.vim "{{{2
"let g:rails_level=4
"let g:rails_default_file="app/controllers/application.rb"
"let g:rails_default_database="sqlite3"

" rubycomplete.vim "{{{2
"autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
"autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
"autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
"autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

" butabs.vim {{{2
"バッファタブにパスを省略してファイル名のみ表示する(buftabs.vim)
"let g:buftabs_only_basename=1
"バッファタブをステータスライン内に表示する
"let g:buftabs_in_statusline=1

"autocomplpop.vim {{{2
" autocmd FileType python set omnifunc=pythoncomplete#Complete
" autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
" autocmd FileType css set omnifunc=csscomplete#CompleteCSS
" autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
" autocmd FileType php set omnifunc=phpcomplete#CompletePHP
" autocmd FileType c set omnifunc=ccomplete#Complete

"php-doc.vim {{{2
inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>

"project.tar.gz
" map <F5> <ESC>:Project<CR>









" Fin.  "{{{1








" END  "{{{1
" vim: expandtab softtabstop=2 shiftwidth=2
" vim: foldmethod=marker

