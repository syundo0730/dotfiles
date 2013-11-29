;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;elispファイル自動読み込み設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs 23より前のバージョンを利用している場合は
;; user-emacs-directory変数が未定義のため次の設定を追加
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "elpa")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Emacs Lisp Package Archive（ELPA）──Emacs Lispパッケージマネージャ
;; Emacs24では標準装備になった
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; package.elの設定
(when (require 'package nil t)
  ;; パッケージリポジトリにMarmaladeと開発者運営のELPAを追加
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  ;; インストールしたパッケージにロードパスを通して読み込む
  (package-initialize))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; auto-installの設定
(when (require 'auto-install nil t)
  ;; インストールディレクトリを設定する 初期値は ~/.emacs.d/auto-install/
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWikiに登録されているelisp の名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  ;; install-elisp の関数を利用可能にする
  (auto-install-compatibility-setup))

;;;フォント設定
;;英語フォント
(set-face-attribute 'default nil
                    :family "Consolas"
                    ;:family "SourceCodePro"
                    :height 120)
;;日本語フォント
(set-fontset-font
 nil 'japanese-jisx0208
 (font-spec :family "Meiryo"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;文字コード等に関する設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-language-environment "japanese")
(prefer-coding-system 'utf-8)

;;MacOS
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))
;;Windows
(when (eq window-system 'w32)
  (set-file-name-coding-system 'cp932)
  (setq locale-coding-system 'cp932))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;表示に関する設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 起動時にスタートアップ画面を表示しない
(setq inhibit-startup-message t)
;; "yes or no" の代わりに "y or n" の省略形を使用する
(fset 'yes-or-no-p 'y-or-n-p)
;; scratchバッファのメッセージを消す
(setq initial-scratch-message "")
;; Messagesバッファの消去
(setq message-log-max nil)
(kill-buffer "*Messages*")
;;ビープ音を鳴らさない
(setq visible-bell t)
;; メニューバーを非表示にする
(menu-bar-mode -1)
;; ツールバーを非表示にする
(tool-bar-mode -1)
;; タイトルバーにファイル名を表示する
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
;; カーソル位置の行番号を表示する
(line-number-mode t)
;; カーソル位置の列番号を表示する
(column-number-mode t)
;; 時刻を表示する
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(display-time)
;; 括弧を強調表示する
(show-paren-mode t)
;; 1 行ずつスムーズにスクロールする
(setq scroll-step 1)
;; スクロールバーを右側に表示する
(set-scroll-bar-mode 'right)
;; デフォルトの透明度を設定する (85%)
(add-to-list 'default-frame-alist '(alpha . 85))
;; 行番号表示
(global-linum-mode t) ;デフォルトでlinum-modeを有効にする
(setq linum-format "%2d") ;2桁分の領域を確保して行番号のあとにスペースを入れる

;; リージョンの文字数をカウント，モードラインに表示
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
      ;;(count-lines-region (region-beginning) (region-end)) ;; これだとエコーエリアがチラつく
    ""))

(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))

;; リージョンをハイライト表示する
(setq transient-mark-mode t)

;; 関数内の強調表示
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(set-face-attribute 'show-paren-match-face nil :background "#101010" :foreground "#ffffff")

;; 編集行のハイライト
;;(install-elisp "http://www.emacswiki.org/cgi-bin/emacs/download/highlight-current-line.el")
(require 'highlight-current-line)
(highlight-current-line-on t)
(set-face-background 'highlight-current-line-face "#050505")

;;yankした文字列をハイライト表示する
(when (or window-system (eq emacs-major-version '21))
  (defadvice yank (after ys:highlight-string activate)
    (let ((ol (make-overlay (mark t) (point))))
      (overlay-put ol 'face 'highlight)
      (sit-for 0.5)
      (delete-overlay ol)))
  (defadvice yank-pop (after ys:highlight-string activate)
    (when (eq last-command 'yank)
      (let ((ol (make-overlay (mark t) (point))))
        (overlay-put ol 'face 'highlight)
        (sit-for 0.5)
        (delete-overlay ol)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;キー割り当て
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-mで改行と同時にインデントする
(global-set-key (kbd "C-m") 'newline-and-indent)
;; backspaceをC-hにバインドする
(global-set-key (kbd "C-h") 'delete-backward-char)
;; ウィンドウ切り替え
(global-set-key (kbd "C-t") 'other-window)
;; 折り返しトグルコマンド
(global-set-key (kbd "C-c l") 'toggle-truncate-lines)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;編集に関する設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; バックアップとオートセーブファイルを~/.emacs.d/backups/へ集める
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;; バッファの末尾で新たな行を追加しない
(setq next-line-add-newlines nil)
;; 行頭で行削除 kill-line (C-k) したら改行も含めて行全体を削除する
(setq kill-whole-line t)
;; リージョン上書きできるようにする
(delete-selection-mode t)
;; クリップボードを他のアプリケーションと共用にする
(setq x-select-enable-clipboard t)
;; ファイル名を補完する時に大文字と小文字を区別しない
(setq read-file-name-completion-ignore-case t)

;; ;;; ibus-mode
;; (when(require 'ibus nil t)
;; ;; Turn on ibus-mode automatically after loading .emacs
;; (add-hook 'after-init-hook 'ibus-mode-on)
;; ;; Use C-SPC for Set Mark command
;; (ibus-define-common-key ?\C-\s nil)
;; ;; Use C-/ for Undo command
;; (ibus-define-common-key ?\C-/ nil)
;; ;; Change cursor color depending on IBus status
;; (setq ibus-cursor-color '("limegreen" "white" "blue"))
;; (global-set-key (kbd "C-;") 'ibus-toggle))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;編集補完機能など
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Anything
;;(auto-install-batch "anything")

(when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を早くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install)))

;; M-yにanythig-show-kill-ringを割り当てる
(global-set-key (kbd "M-y") 'anything-show-kill-ring)

;; color-moccurの設定
;(auto-install-from-emacswiki color-moccur)
(when (require 'color-moccur nil t)
  ;; M-oにoccur-by-moccurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  ;; Migemoを利用できる環境であればMigemoを使う
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;(auto-install-from-emacswiki moccur-edit)
(require 'moccur-edit nil t)

;;Re-roadしてinit.elを適用してくれる
;;reload
(global-set-key
 [f12] 'eval-buffer)

;; cua-modeの設定
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; auto-complete
;; http://cx4a.org/software/auto-complete/index.ja.html
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/auto-complete/dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default)
  (setq ac-auto-show-men 0.1)
  (define-key ac-completing-map (kbd "C-p") 'ac-previous) ;;M-pから変更
  (define-key ac-completing-map (kbd "C-n") 'ac-next) ;;M-nから変更
  (define-key ac-completing-map (kbd "C-i") nil) ;;C-iで決定されないよう設定
)

;; dmacro.el
;; 同じ操作を二度実行した後で繰り返しキーを押すだけで操作を再実行させる
;; (install-elisp "http://www.pitecan.com/papers/JSSSTDmacro/dmacro.el")
(defconst *dmacro-key* (kbd "C-c C-t") "繰返し指定キー")
(global-set-key *dmacro-key* 'dmacro-exec)
(autoload 'dmacro-exec "dmacro" nil t)

;; smartchr
;; キーの両側にスペースを補完する．複数回入力で補完方法が切り替わる．
;;(install-elisp "https://raw.github.com/imakado/emacs-smartchr/master/smartchr.el")
;; smartchrの設定定義ファイルを読み込む
(require 'init-smartchr)

;; key-combo
;; smartchrみたいなもん
;;(auto-install-from-url "https://raw.github.com/uk-ar/key-combo/master/key-combo.el")
;; (when (require 'key-combo nil t)
;; (key-combo-load-default))


;; プログラミング向け補完機能
;; c-mode-common-hook用の関数を定義(C,C++,Obj-C,JAVAなど)
(defun c-mode-hooks()
  ;; センテンスの終了である ';' を入力したら、自動改行+インデント
  (c-toggle-auto-hungry-state 1)
  ;; RET キーで自動改行+インデント
  (define-key c-mode-base-map (kbd "C-m") 'newline-and-indent)
  ;; インデントスタイル
  (c-set-style "bsd")
  ;; flyspell-prog-mode をオンにする
  (flyspell-prog-mode)
 )
;; c-mode-common-hookのフックをセット
(add-hook 'c-mode-common-hook 'c-mode-hooks)

;; tabを用いない
(setq-default indent-tabs-mode nil)
;; オフセット4
(setq-default tab-width 4)

;;;; This snippet enables lua-mode
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
(setq lua-indent-level 4);インデント4にする

;; 削除をゴミ箱の移動に置き換える
(setq delete-by-moving-to-trash t)
(setq trash-directory "~/tmp/trash")

;;; iswitch
(iswitchb-mode 1)
;; キーバインドの変更
(add-hook 'iswitchb-define-mode-map-hook
          'iswitchb-my-keys)

(defun iswitchb-my-keys ()
  "Add my keybindings for iswitchb."
  (define-key iswitchb-mode-map [right] 'iswitchb-next-match)
  (define-key iswitchb-mode-map [left] 'iswitchb-prev-match)
  (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
  (define-key iswitchb-mode-map " " 'iswitchb-next-match)
  (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)
  )

;;選択中の内容を表示
(defadvice iswitchb-exhibit
  (after
   iswitchb-exhibit-with-display-buffer
   activate)
  "選択している buffer を window に表示してみる。"
  (when (and
         (eq iswitchb-method iswitchb-default-method)
         iswitchb-matches)
    (select-window
     (get-buffer-window (cadr (buffer-list))))
    (let ((iswitchb-method 'samewindow))
      (iswitchb-visit-buffer
       (get-buffer (car iswitchb-matches))))
    (select-window (minibuffer-window))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;バッファ切り替え
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq my-ignore-buffer-list
      '("*Help*" "*Compile-Log*" "*Mew completions*" "*Completions*"
        "*Shell Command Output*" "*Apropos*" "*Buffer List*" "*Messages*" "*scratch*"))
(defun my-visible-buffer (blst)
  (let ((bufn (buffer-name (car blst))))
    (if (or (= (aref bufn 0) ? ) (member bufn my-ignore-buffer-list))
        (my-visible-buffer (cdr blst)) (car blst))))

(defun my-grub-buffer ()
  (interactive)
  (switch-to-buffer (my-visible-buffer (reverse (buffer-list)))))

(defun my-bury-buffer ()
  (interactive)
  (bury-buffer)
  (switch-to-buffer (my-visible-buffer (buffer-list))))

(global-set-key [C-tab] 'my-grub-buffer)
(global-set-key [C-S-tab] 'my-bury-buffer)

;;; pc-bufsw
;;すべてのバッファを順番に簡単に巡る拡張
(when (require 'pc-bufsw nil t)
(global-set-key [?\C-,] 'pc-bufsw::lru)
(global-set-key [?\C-.] 'pc-bufsw::previous)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Egg
;; gitのための拡張
(when (executable-find "git")
  (require 'egg nil t))

;; multi-term
;; (install-elisp "http://www.emacswiki.org/emacs/download/multi-term.el")
(when (require 'multi-term nil t)
  (setq multi-term-program shell-file-name)
  (setq term-default-bg-color "#000000")
  (setq term-default-fg-color "#ffffff")
)

;;フルスクリーンに関する操作を改善
;;(install-elisp "https://raw.github.com/rmm5t/maxframe.el/master/maxframe.el")
(when (require 'maxframe nil t)
  (add-hook 'window-setup-hook 'maximize-frame t)
)

;;; ELPA + package.el
;;(install-elisp "http://bit.ly/pkg-el23")

;;; ELPAの利用;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 追加してからM-x package-initializeすると再起動せず適用できる

;; undo-treeの設定
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; color-theme
;; http://download.savannah.gnu.org/releases/color-theme/color-theme-6.6.0.tar.gz
(when (require 'color-theme nil t)
;(require 'zenburn)
(color-theme-initialize)
;(color-theme-zenburn)
(color-theme-billw))

;;; dired
;; 移動先ディレクトリ名として他方のバッファのディレクトリ名を自動で挿入
(setq dired-dwim-target t)
;; C-x dで現在のファイルのディレクトリを開く
(require 'dired-x)
(global-set-key (kbd "C-x d") 'dired-jump-other-window)
;;; direx
;; http://cx4a.blogspot.jp/2011/12/popwineldirexel.html
;; https://github.com/m2ym/direx-el
;;(install-elisp "https://raw.github.com/m2ym/direx-el/master/direx.el")
(when (require 'direx nil t)
  (global-set-key (kbd "C-x D") 'direx:find-directory-other-window)
  (global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)
  )
;;; popwin
;;ポップアップ表示してくれる
;; http://d.hatena.ne.jp/m2ym/20110120/1295524932
;;(install-elisp "https://raw.github.com/m2ym/popwin-el/master/popwin.el")
(when (require 'popwin nil t)
  (popwin-mode 1)
  ;;ポップアップ表示するバッファの指定
  ;;dired
  (push '(dired-mode :position top :dedicated t) popwin:special-display-config)
  ;;direx
  (push '(direx:direx-mode :position left :width 30 :dedicated t) popwin:special-display-config)
  ;;undo-tree
  (push '(" *undo-tree*" :width 0.3 :position right) popwin:special-display-config)
  ;;scratch
  (push '("*scratch*") popwin:special-display-config)
  ;; M-x compile
  (push '(compilation-mode :noselect t) popwin:special-display-config)
  )
(when (require 'popwin-yatex nil t)
  ;;YaTeX
  (push '("*YaTeX-typesetting*") popwin:special-display-config)
  )

;; ;;; brows-yank
;; ;; http://www.bookshelf.jp/soft/meadow_32.html#SEC460
;; (load "browse-yank")
;; (global-set-key "\M-y" 'browse-yank)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; YaTeX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; YaTeX
;; yatex-mode の起動
(setq auto-mode-alist 
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)

;; 文章作成時の日本語文字コード
;; 0: no-converion
;; 1: Shift JIS (windows & dos default)
;; 2: ISO-2022-JP (other default)
;; 3: EUC
;; 4: UTF-8
;;(setq YaTeX-kanji-code 4)

(setq YaTeX-inhibit-prefix-letter nil)

(setq tex-command "platex")
(setq dvi2-command-format "dviout %s ")
(setq dviprint-command-format "dvipdfmx %s ")

; ~/.LaTeX-templateは新規ファイル作成時に自動挿入するファイル名
(setq YaTeX-template-file "~/.emacs.d/LaTeX-template")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; emacs-w3m
(require 'w3m-load)
(setq browse-url-browser-function 'w3m-browse-url)
(setq w3m-default-display-inline-images t)

;;; twittering-mode
(require 'twittering-mode)
(setq twittering-use-master-password t)
(setq twittering-auth-method 'oauth)
(setq twittering-username "nekokoneko_mode")
(setq twittering-timer-interval 60)
(setq twittering-convert-fix-size 48)
(setq twittering-update-status-function 'twittering-update-status-from-pop-up-buffer)
(setq twittering-icon-mode t)
(setq twittering-scroll-mode nil)
(setq twittering-edit-skeleton 'inherit-any)
;; いくつかのTLをまとめて名前をつけることができる
(setq twittering-timeline-spec-alias
      `(("related-to" .
	 ,(lambda (username)
	    (if username
		(format ":search/to:%s OR from:%s OR @%s/"
			username username username)
	      ":home")))
	))
;; 起動時に以下のリストを読みこむ
(setq twittering-initial-timeline-spec-string
      '(	"nekokoneko_mode/tech"
	"DHC_6/airc"
	":home"))
(add-hook 'twittering-mode-hook
          (lambda ()
            (set-face-bold-p 'twittering-username-face t)
            (set-face-foreground 'twittering-username-face "DeepSkyBlue3")
            (set-face-foreground 'twittering-uri-face "gray60")
	    (setq twittering-status-format "%i %p%s / %S:\n%FOLD{%T}\n%r %R [%@]")
	    (setq twittering-retweet-format " RT @%s: %t")
            ;; "F"でお気に入り
            ;; "R"でリツイートできるようにする
            (define-key twittering-mode-map (kbd "F") 'twittering-favorite)
            (define-key twittering-mode-map (kbd "R") 'twittering-native-retweet)
            ;; "<"">"で先頭、最後尾にいけるように
            (define-key twittering-mode-map (kbd "<") (lambda () (interactive) (goto-char (point-min))))
            (define-key twittering-mode-map (kbd ">") (lambda () (interactive) (goto-char (point-max))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
