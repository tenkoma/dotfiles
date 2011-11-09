" tenkoma's .vimrc
" Note  "{{{1

" neobundle.vim
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/

  call neobundle#rc(expand('~/.vimbundle'))
endif

" from github
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kana/vim-fakeclip'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'tpope/vim-rails'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-surround'
NeoBundle 'mattn/zencoding-vim'
NeoBundle 'hallettj/jslint.vim'
NeoBundle 'motemen/git-vim'
NeoBundle 'vim-scripts/buftabs'
NeoBundle 'vim-scripts/grep.vim'
NeoBundle 'vim-scripts/project.tar.gz'
" NeoBundle 'vim-scripts/snippetsEmu'

" not github git repository
NeoBundle 'git://repo.or.cz/vcscommand'

filetype plugin on
filetype indent on









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
  augroup recheckfenc
    autocmd!
    autocmd BufReadPost * call AU_ReCheck_FENC()
  augroup END
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

set runtimepath+=$HOME/.vim
set number
set ruler
set modeline
set modelines=5
" 未指定でyankしたときはクリップボードを使う
set clipboard=unnamed,autoselect
" バックスペースキーの動作
set backspace=2
" カーソルの上下に最低何行表示するか
set scrolloff=5
" □とか○でカーソル位置がずれないようにする
set ambiwidth=double
" テキスト整形オプション "よくわかってない
set formatoptions=tcroqnlM12
" 他で書き換えられたら自動で読み直す
set autoread
" スワップファイルつくらない
set noswapfile
" 編集中でも他のファイルを開けるようにする
set hidden
" バックスペースでなんでも消せるように
set backspace=indent,eol,start
" Exploreの初期ディレクトリ
set browsedir=buffer
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

" ファイルタイプの自動識別
filetype on
filetype plugin on
filetype indent on
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
set nobackup
set directory=~/tmp

" status line
set showcmd
" 現在のモードを表示
set showmode
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
set guioptions+=a
set ttymouse=xterm2

"git の branch を statusline に
" http://subtech.g.hatena.ne.jp/secondlife/20080310/1205138674
let g:gitCurrentBranch = ''
function! CurrentGitBranch()
    let cwd = getcwd()
    cd %:p:h
    let branch = matchlist(system('/opt/local/bin/git  branch -a --no-color'), '\v\* (\w*)\r?\n')
    execute 'cd ' . cwd
    if (len(branch))
      let g:gitCurrentBranch = '[git:' . branch[1] . ']'
    else
      let g:gitCurrentBranch = ''
    endif
    return g:gitCurrentBranch
endfunction

augroup gitbranchonstatusline
  autocmd!
  autocmd BufEnter * :call CurrentGitBranch()
augroup END

" TODO: もちょっとカスタマイズするのだわ
" default 'statusline' with 'fileencoding'.
let &statusline = ''
let &statusline .= '%<%F %h%m%r%w'
let &statusline .= '%{g:gitCurrentBranch} ' "git のブランチ表示
let &statusline .= '%='
let &statusline .= '%y' " filetype
let &statusline .= '[%{&fileencoding == "" ? &encoding : &fileencoding}]'
let &statusline .= '[%{&fileformat}]'
let &statusline .= '  %-14.(%l,%c%V%) %P'

" 挿入モードになったとき、ステータスラインの色を変える
augroup statuslinechangebymode
  autocmd!
  autocmd InsertEnter * highlight StatusLine guifg=Black guibg=Gray gui=none ctermfg=Black ctermbg=Gray cterm=none
  autocmd InsertLeave * highlight StatusLine guifg=White guibg=Blue gui=none ctermfg=White ctermbg=Blue cterm=none
augroup END


" タイトル
set title
set titlestring=Vim:\ %f\ %h%r%m

" 不可視文字の表示形式
set list
set listchars=eol:<,tab:>.,trail:_,extends:>,precedes:<
"行末の半角スペースを強調する
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
" 長い行を折り返す
set wrap
" 括弧を閉じたとき括弧始まりに一瞬移動
set showmatch
" カーソル行を強調
set cursorline

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
nnoremap <F5> ;<C-u>write<CR>

" 検索
" 検索キーを押した後、画面の真ん中に
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" Escの2回押しでハイライト消去
nmap <ESC><ESC> ;nohlsearch<CR><ESC>

" CTRL-hjklでウィンドウ移動
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h






" Filetypes  "{{{1
" All filetypes  "{{{2

" Ruby, eruby, rails "{{{2
augroup codestyleruby
  autocmd!
  autocmd FileType ruby setlocal tabstop=2 tw=0 sw=2 expandtab
  autocmd FileType eruby setlocal tabstop=2 tw=0 sw=2 expandtab
  autocmd BufNewFile,BufRead app/*/*.rhtml setlocal ft=mason fenc=utf-8
  autocmd BufNewFile,BufRead app/**/*.rb setlocal ft=ruby fenc=utf-8
  autocmd BufNewFile,BufRead app/**/*.yml setlocal ft=ruby fenc=utf-8
augroup END
" action script "{{{2
augroup codestyleactionscript
  autocmd!
  autocmd BufNewFile,BufRead *.as setlocal filetype=actionscript
  autocmd BufNewFile,BufRead *.mxml setlocal filetype=mxml
augroup END
" JavaScript "{{{2
augroup codestylejavascript
  autocmd!
  autocmd FileType *.js setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd Syntax javascript setlocal foldmethod=indent
augroup END
" PHP "{{{2
augroup codestylephp
  autocmd!
  autocmd BufNewFile,BufRead *.thtml setfiletype php
  autocmd BufNewFile,BufRead *.ctp setfiletype php
  autocmd BufNewFile,BufRead *.tpl setfiletype php
augroup END
let php_sql_query = 1
let php_htmlInStrings = 1
let php_noShortTags=1
let php_folding=1
let php_parent_error_open = 1
let php_parent_error_close = 1
augroup syntaxphp
  autocmd!
  autocmd Syntax php setlocal fdm=syntax foldmethod=syntax
augroup END
"php 文法チェック<
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l

" yaml
augroup codestyleyaml
  autocmd!
  autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END








" Plugins  "{{{1



"モジュールを有効にする
source $VIMRUNTIME/macros/matchit.vim

" rails.vim "{{{2
let g:rails_level=4
let g:rails_default_file="app/controllers/application_controller.rb"
let g:rails_default_database="sqlite3"

" butabs.vim {{{2
"バッファタブにパスを省略してファイル名のみ表示する(buftabs.vim)
"let g:buftabs_only_basename=1
"バッファタブをステータスライン内に表示する
"let g:buftabs_in_statusline=1

"autocomplpop.vim {{{2
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
" autocmd FileType c setlocal omnifunc=ccomplete#Complete

"php-doc.vim {{{2
inoremap <C-P> <ESC>;call PhpDocSingle()<CR>i
nnoremap <C-P> ;call PhpDocSingle()<CR>
vnoremap <C-P> ;call PhpDocRange()<CR>

"project.tar.gz
nmap <F5> <ESC>;Project<CR>
let g:proj_window_width=34

"zencoding.vim
let g:user_zen_settings = {
\  'indentation': '',
\  'lang' : 'ja',
\  'php' : {
\    'extends' : 'html',
\  },
\  'eruby' : {
\    'extends' : 'html',
\  },
\  'smarty' : {
\    'extends' : 'html',
\  },
\  'xml' : {
\    'extends' : 'html',
\  }
\}

"neocomplcache
let g:neocomplcache_enable_at_startup = 1

"grep.vim
" :Gb <args> でGrepBufferする
command! -nargs=1 Gb :GrepBuffer <args>
" カーソル下の単語をGrepBufferする
nnoremap <C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><Enter>
" 検索外のディレクトリ、ファイルパターン
let Grep_Skip_Dirs = '.svn .git .hg'
let Grep_Skip_Files = '*.bak *~'







" Fin.  "{{{1








" END  "{{{1
" vim: expandtab softtabstop=2 shiftwidth=2
" vim: foldmethod=marker

