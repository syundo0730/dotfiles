gui
if has('win32')
    " 背景を透明にする
    set transparency=230
    " VimのGUI版で使われるフォントのリストである。
    :set guifont=MS_Gothic:h12:cSHIFTJIS
endif
" カラースキーマをロードする。
:colorscheme billw

" 画面上の列幅を設定する。
:set columns=100
" 画面上の行数。
:set lines=32

" コマンドラインに使われる画面上の行数。
:set cmdheight=2

" このオプションは、いつタブページのラベルを表示するかを指定する。
"                0: 表示しない
"                1: 2個以上のタブページがあるときのみ表示
"                2: 常に表示
:set showtabline=2

" 前回の検索パターンが存在するとき、それにマッチするテキストを全て強調表示する。（有効:hlsearch/無効:nohlsearch）
:set hlsearch

" Visual選択で選択されたテキストが、自動的にクリップボードレジスタ "*" にコピーされる。
:set guioptions+=a
