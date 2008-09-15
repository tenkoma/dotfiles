" tenkoma's .vimrc
" Note  "{{{1








" Basic  "{{{1
" Absolute  "{{{2

set nocompatible

" Encoding  "{{{2
set enc=utf-8
set fencs=utf-8,iso-2022-jp,euc-jp,cp932

" Options  "{{{2

set number
set ruler
" バックスペースキーの動作
set backspace=2
" カーソルの上下に最低何行表示するか
set scrolloff=5
" □とか○でカーソル位置がずれないようにする
set ambiwidth=double
" テキスト整形オプション
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
set backupdir=.,~/tmp
set backupskip&
set backupskip+=svn-commit.tmp,svn-commit.[0-9]*.tmp
set directory=.,~/tmp

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

" タブ/改行を表示しない
set nolist
" 長い行を折り返す
set wrap
" 括弧を閉じたとき括弧始まりに一瞬移動
set showmatch
" カーソル行を強調
set cursorline

" Input Method
set iminsert=0
set imsearch=0
set imdisable

" 配色
highlight Search term=reverse ctermbg=DarkBlue ctermfg=NONE








" Utilities  "{{{1
" Misc  "{{{2

function! s:set_short_indent()
  setlocal expandtab softtabstop=2 shiftwidth=2
endfunction








" Mappings  "{{{1
" Tab pages  "{{{2
" Command-line editting  "{{{2
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








" Plugins  "{{{1
" rails.vim "{{{2
"let g:rails_level=4
"let g:rails_default_file="app/controllers/application.rb"
"let g:rails_default_database="sqlite3"

" rubycomplete.vim "{{{2
"autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
"autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
"autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
"autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1




 
 


" Fin.  "{{{1








" END  "{{{1
" vim: expandtab softtabstop=2 shiftwidth=2
" vim: foldmethod=marker
