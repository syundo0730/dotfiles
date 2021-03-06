(when (require 'smartchr nil t)

;;; @see http://d.hatena.ne.jp/tequilasunset/20101119/p1
;; smartchr-func start
(defun my-smartchr-braces ()
  "Insert a pair of braces like below.
\n {\n `!!'\n}"
  ;; foo {
  ;; `!!'
  ;; }
  (lexical-let (beg end)
    (smartchr-make-struct
     :insert-fn (lambda ()
                  (setq beg (point))
                  (insert "{\n\n}")
                  (indent-region beg (point))
                  (forward-line -1)
                  (indent-according-to-mode)
                  (goto-char (point-at-eol))
                  (setq end (save-excursion
                              (re-search-forward "[[:space:][:cntrl:]]+}" nil t))))
     :cleanup-fn (lambda ()
                   (delete-region beg end))
     )))

(defun my-smartchr-comment ()
  "Insert a multiline comment like below.
\n/*\n * `!!'\n */"
  ;; /*
  ;; * `!!'
  ;; */
  (lexical-let (beg end)
    (smartchr-make-struct
     :insert-fn (lambda ()
                  (setq beg (point))
                  (insert "/*\n* \n*/")
                  (indent-region beg (point))
                  (setq end (point))
                  (forward-line -1)
                  (goto-char (point-at-eol)))
     :cleanup-fn (lambda ()
                   (delete-region beg end))
     )))

(defun my-smartchr-semicolon ()
  "Insert a semicolon at end of line."
  (smartchr-make-struct
   :insert-fn (lambda ()
                (save-excursion
                  (goto-char (point-at-eol))
                  (insert ";")))
   :cleanup-fn (lambda ()
                 (save-excursion
                   (goto-char (point-at-eol))
                   (delete-backward-char 1)))
   ))

;;; smartchr-func end

(defun my-smartchr-keybindings ()
  ;; !! がカーソルの位置
  (local-set-key (kbd "=") (smartchr '(" = " " == " "=")))
  (local-set-key (kbd "+") (smartchr '(" + " "++" " += " "+")))
  (local-set-key (kbd "-") (smartchr '(" - " "--" " -= " "-")))
  (local-set-key (kbd "(") (smartchr '("(`!!')" "(")))
  (local-set-key (kbd "[") (smartchr '("[`!!']" "[")))
  (local-set-key (kbd "{") (smartchr '(my-smartchr-braces "{`!!'}" "{")))
  ;;バッククォート
  (local-set-key (kbd "`") (smartchr '("\``!!''" "\`")))
  ;;ダブルクォーテーション
  (local-set-key (kbd "\"") (smartchr '("\"`!!'\"" "\"")))
  ;;シングルクォート
  (local-set-key (kbd "\'") (smartchr '("\'`!!'\'" "\'")))
  (local-set-key (kbd ">") (smartchr '(" > " " >> " ">")))
  (local-set-key (kbd "<") (smartchr '(" < " " << " "<`!!'>" "<")))
  (local-set-key (kbd ",") (smartchr '(", " ",")))
  (local-set-key (kbd ".") (smartchr '("." " . ")))
  (local-set-key (kbd "?") (smartchr '("?" "? `!!' " "<?`!!'?>")))
  (local-set-key (kbd "!") (smartchr '("!" " != ")))
  (local-set-key (kbd "&") (smartchr '("&" " && ")))
  (local-set-key (kbd "|") (smartchr '("|" " || ")))
  (local-set-key (kbd "/") (smartchr '("/" "//" "/* `!!' */" my-smartchr-comment)))
  (local-set-key (kbd ";") (smartchr '(";" my-smartchr-semicolon)))
  )

(defun my-smartchr-keybindings-lisp ()
  (local-set-key (kbd "(") (smartchr '("(`!!')" "(")))
  (local-set-key (kbd "[") (smartchr '("[`!!']" "[[`!!']]" "[")))
  (local-set-key (kbd "`") (smartchr '("\``!!''" "\`")))
  (local-set-key (kbd "\"") (smartchr '("\"`!!'\"" "\"")))
  (local-set-key (kbd ".") (smartchr '("." " . ")))
  )

(defun my-smartchr-keybindings-objc ()
  (local-set-key (kbd "@") (smartchr '("@\"`!!'\"" "@")))
  (local-set-key (kbd "[") (smartchr '("[`!!']" "[[`!!']]" "[[[`!!']]]" "["))))


(dolist (hook (list
               'c-mode-common-hook
               'c++-mode-hook
               'php-mode-hook
               'ruby-mode-hook
               'cperl-mode-hook
               'javascript-mode-hook
               'js-mode-hook
               'js2-mode-hook
               ;;'text-mode-hook
               ))
  (add-hook hook 'my-smartchr-keybindings))

(dolist (hook (list
               'lisp-mode-hook
               'emacs-lisp-mode-hook
               'lisp-interaction-mode-hook
               'inferior-gauche-mode-hook
               'scheme-mode-hook
               ))
  (add-hook hook 'my-smartchr-keybindings-lisp))

(add-hook 'objc-mode-hook 'my-smartchr-keybindings-objc)

(provide 'init-smartchr)
)
