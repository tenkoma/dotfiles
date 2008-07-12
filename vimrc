set expandtab tabstop=4 shiftwidth=4 softtabstop=4

"ファイルタイプ別の設定
au FileType *.js set tabstop=2 shiftwidth=2 softtabstop=2
au FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.thtml setfiletype php
au BufNewFile,BufRead *.ctp setfiletype php
au BufNewFile,BufRead *.tpl setfiletype smarty
let php_sql_query=1
let php_htmlInStrings=1
let php_noShortTags=1
let php_folding=1
au Syntax php set fdm=syntax
"php 文法チェック
"set makeprg=php\ -l\ %
"set errorformat=%m\ in\ %f\ on\ line\ %l

" IME制御
set iminsert=0 imsearch=0


set mouse=a
set ttymouse=xterm2

set number
set ruler
set smartindent
set ignorecase
set smartcase
set wrapscan
set noincsearch
set showcmd
set showmatch
set hlsearch
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" 改行と行末の表示
set list
set listchars=eol:<,tab:>-

" 日付、時間の挿入 (¥date, ¥time)
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d (%a)%n================%n%n')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M:%S@')<CR>

"挿入モードでカーソル移動
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-f> <Right>
inoremap <C-b> <Left>

"行末の半角スペースを強調する
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

" マップ定義
"
"バッファ移動用キーマップ
" F2: 前のバッファ
" F3: 次のバッファ
" F4: バッファ削除
map <F2> <ESC>:bp<CR>
map <F3> <ESC>:bn<CR>
map <F4> <ESC>:bw<CR>
"buftabs.vim
let g:buftabs_only_basename=1
set laststatus=2
let g:buftabs_in_statusline=1



"表示行単位で行移動する
nnoremap j gj
nnoremap k gk
"フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-

syntax on

"バックアップ・スワップファイル
if $OS == 'Windows_NT'
  set backupdir=~/vimfiles/backup/
  set directory=~/vimfiles/swap/
else
  set backupdir=~/.vim/
  set directory=~/.vim/swap/
endif


colorscheme torte

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

if v:version >= 700
  "vim7の設定
  "TABでOmni completion
  function InsertTabWrapper()
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

 inoremap <tab> <c-r>=InsertTabWrapper()<cr>
endif

"php-doc.vim
"inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
"nnoremap <C-P> :call PhpDocSingle()<CR>
"vnoremap <C-P> :call PhpDocRange()<CR>

"モジュールを有効にする
source $VIMRUNTIME/macros/matchit.vim
