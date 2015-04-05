filetype plugin on
filetype indent on

"windows 環境においてvimfilesではなく.vimを使う
:set runtimepath+=$HOME/.vim

"--------------------------------------------------------------------------
" neobundle

 " Note: Skip initialization for vim-tiny or vim-small.
 if !1 | finish | endif

 if has('vim_starting')
   set nocompatible               " Be iMproved

   " Required:
   set runtimepath+=~/.vim/bundle/neobundle.vim/
 endif

 " Required:
 call neobundle#begin(expand('~/.vim/bundle/'))

 " Let NeoBundle manage NeoBundle
 " Required:
 NeoBundleFetch 'Shougo/neobundle.vim'

 " My Bundles here:
 " Refer to |:NeoBundle-examples|.
 " Note: You don't set neobundle setting in .gvimrc!
 NeoBundle 'thinca/vim-quickrun'
 NeoBundle 'Shougo/unite.vim'
 NeoBundle 'spolu/dwm.vim'


 call neobundle#end()
 
 " Required:
 filetype plugin indent on

 " If there are uninstalled bundles found on startup,
 " this will conveniently prompt you to install them.
 NeoBundleCheck
"---------------------------------------------------------------------------

"" quickrun
""
"set noshellslash
let g:quickrun_config = {
\   'tex': {
\       'command': 'latexmk',
\       'exec': ['%c -gg -pdfdvi "%S:t:r.tex"', 'rundll32 shell32,ShellExec_RunDLL SumatraPDF -reuse-instance -inverse-search "\"' . $VIM . '\gvim.exe\" -n --remote-silent +\%%l \"\%%f\"" ' . '"%S:r.pdf"']
\   },
\}

" ビープ音を消す
:set visualbell t_vb=

" 物理的移動を基本の移動に設定する
:nnoremap j gj
:nnoremap k gk

" 検索パターンにおいて大文字と小文字を区別しない。（有効:ignorecase/無効:noignorecase）
:set noignorecase
" 検索パターンが大文字を含んでいたらオプション 'ignorecase' を上書きする。（有効:smartcase/無効:nosmartcase）
:set smartcase

" ファイル内の <Tab> が対応する空白の数。
:set tabstop=4
" <Tab> の挿入や <BS> の使用等の編集操作をするときに、<Tab> が対応する空白の数。
:set softtabstop=4
" インデントの各段階に使われる空白の数。
:set shiftwidth=4
" Insertモードで <Tab> を挿入するとき、代わりに適切な数の空白を使う。（有効:expandtab/無効:noexpandtab）
:set expandtab

" 入力されているテキストの最大幅。行がそれより長くなると、この幅を超えないように空白の後で改行される。値を 0 に設定すると無効になる。
:set textwidth=0
" 新しい行を開始したとき (Insertモードで <CR> を打ち込むか、コマンド "o"や "O" を使ったとき)、新しい行のインデントを現在行と同じくする。（有効:autoindent/無効:noautoindent）
:set autoindent

" オンのときは、ウィンドウの幅より長い行は折り返され、次の行に続けて表示される。（有効:wrap/無効:nowrap）
:set wrap

" 検索がファイル末尾まで進んだら、ファイル先頭から再び検索する。（有効:wrapscan/無効:nowrapscan）
:set wrapscan
" オンのとき、コマンドライン補完が拡張モードで行われる。（有効:wildmenu/無効:nowildmenu）
:set wildmenu

" 閉じ括弧が入力されたとき、対応する開き括弧にわずかの間ジャンプする。（有効:showmatch/無効:noshowmatch）
:set showmatch

" 毎行の前に行番号を表示する。（有効:number/無効:nonumber）
:set number
" カーソルが何行目の何列目に置かれているかを表示する。（有効:ruler/無効:noruler）
:set ruler
" タブ文字を CTRL-I で表示し、行末に $ で表示する。（有効:list/無効:nolist）
" :set list
" Listモード (訳注: オプション 'list' がオンのとき) に使われる文字を設定する。
" :set listchars=tab:>-,extends:<,trail:-,eol:<

" 最下ウィンドウにいつステータス行が表示されるかを設定する。
"               0: 全く表示しない
"               1: ウィンドウの数が2以上のときのみ表示
"               2: 常に表示
:set laststatus=2
" コマンド (の一部) を画面の最下行に表示する。（有効:showcmd/無効:noshowcmd）
:set showcmd

" ファイルを上書きする前にバックアップを作る。書き込みが成功してもバックアップはそのまま取っておく。（有効:backup/無効:nobackup）
:set nobackup
" ファイルの上書きの前にバックアップを作る。オプション 'backup' がオンでない限り、バックアップは上書きに成功した後削除される。（有効:writebackup/無効:nowritebackup）
:set nowritebackup

"yankしたテキストが無名レジスタだけでなく、*レジスタにも入るようにする
:set clipboard+=unnamed

""""""""""""""""""""""""""""""
"挿入モード時、ステータスラインの色を変更
""""""""""""""""""""""""""""""
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

" .vimrcを開く
nnoremap <Space>.  :<C-u>edit $MYVIMRC<CR>
" source ~/.vimrc を実行する。
nnoremap <Space>,  :<C-u>source $MYVIMRC<CR> 

""
"" Vim-LaTeX
""
"set shellslash
set grepprg=grep\ -nH\ $*

let g:tex_flavor='latex'
let g:Tex_AutoFolding = 0

let g:Imap_UsePlaceHolders = 1
let g:Imap_DeleteEmptyPlaceHolders = 1
let g:Imap_StickyPlaceHolders = 0

let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_FormatDependency_ps = 'dvi,ps'

let g:Tex_CompileRule_dvi = 'platex -guess-input-enc -interaction=nonstopmode $*'
let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'

let g:Tex_BibtexFlavor = 'upbibtex'
let g:Tex_MakeIndexFlavor = 'makeindex $*.idx'

let g:Tex_ViewRule_dvi = 'C:\texlive\2013\bin\win32\dviout.exe'
let g:Tex_ViewRule_pdf = 'rundll32 shell32,ShellExec_RunDLL SumatraPDF -reuse-instance -inverse-search "\"' . $VIM . '\gvim.exe\" -n -c \":RemoteOpen +\%l \%f\""'


" dwm.vim 設定（全てデフォルト）
nnoremap <c-j> <c-w>w
nnoremap <c-k> <c-w>W
nmap <m-r> <Plug>DWMRotateCounterclockwise
nmap <m-t> <Plug>DWMRotateClockwise
nmap <c-n> <Plug>DWMNew
nmap <c-c> <Plug>DWMClose
nmap <c-@> <Plug>DWMFocus
nmap <c-Space> <Plug>DWMFocus
nmap <c-l> <Plug>DWMGrowMaster
nmap <c-h> <Plug>DWMShrinkMaster
 
" Unite 設定
noremap zp :Unite buffer_tab file_mru<CR>
noremap zn :UniteWithBufferDir -buffer-name=files file file/new<CR>
