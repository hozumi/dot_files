;;2011/12/28 ユーザ指定のディレクトリ以下全てを load-path に追加
;; http://masutaka.net/chalow/2009-07-05-3.html
(defconst my-elisp-directory "~/.emacs.d/elisp" "The directory for my elisp file.")

(dolist (dir (let ((dir (expand-file-name my-elisp-directory)))
               (list dir (format "%s%d" dir emacs-major-version))))
  (when (and (stringp dir) (file-directory-p dir))
    (let ((default-directory dir))
      (add-to-list 'load-path default-directory)
      (normal-top-level-add-subdirs-to-load-path))))

;;2011/12/28 marmalade
;; package-list-packages によってpackageのリストが取得できないと思っていたが、
;;	http://marmalade-repo.org/packages/archive-contents
;;	が 502 proxy error を返していた。多分これが原因。
;;2011/12/29 9:10 なんか直ってた。
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;2010/10/25
(require 'color-theme)
(require 'zenburn)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     ;;(color-theme-gnome2)
     (color-theme-zenburn)))

;;2011/12/29 paredit-mode
;; https://github.com/technomancy/clojure-mode
(defun turn-on-paredit () (paredit-mode 1))
(add-hook 'clojure-mode-hook 'turn-on-paredit)

;;2011/4/21 anything auto-install
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/elisp/auto-install/")
;; 2012/11/2 http://d.hatena.ne.jp/rubikitch/20091221/autoinstall#c1308105294
;; wget のエラー回避
(setq auto-install-use-wget nil)
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)

;; anything
(require 'anything-startup)
;(mac-add-ignore-shortcut '(ctl ?'))
(require 'anything)
(require 'anything-config)
(require 'anything-match-plugin)
(setq anything-idle-delay 0.3)
(setq anything-input-idle-delay 0.2)
(define-key anything-map (kbd "C-p") 'anything-previous-line)
(define-key anything-map (kbd "C-n") 'anything-next-line)
(define-key anything-map (kbd "C-v") 'anything-next-source)
(define-key anything-map (kbd "M-v") 'anything-previous-source)
(global-set-key (kbd "C-c C-;") 'anything)

;;2011/4/20 Copy 1 line without selecting char.
;; http://dl.dropbox.com/u/7581960/elisp/killing-line.txt
(defun killing-line (&optional numlines)
  "One line puts on killing wherever there is a cursor."
  (interactive "p")
  (let* ((col (current-column))
         (bol (progn (beginning-of-line) (point)))
         (eol (progn (end-of-line) (point)))
         (line (buffer-substring bol eol)))
    (while (> numlines 0)
      (kill-new line)
      (setq numlines (- numlines 1)))
    (move-to-column col)))
(define-key global-map "\C-c\C-d" 'killing-line)

;;2011/2/21 tab to space
(setq-default tab-width 2 indent-tabs-mode nil)
;;2011/6/12
;;(setq-default tab-width 6 indent-tabs-mode t)

;;2010/11/1 全角スペースとかに色を付ける http://ubulog.blogspot.com/2007/09/emacs_09.html
(defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
(defface my-face-b-1 '((t (:background "dark turquoise"))) nil)
(defface my-face-b-2 '((t (:background "cyan"))) nil)
(defface my-face-b-2 '((t (:background "SeaGreen"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ("　" 0 my-face-b-1 append)
     ;;("\t" 0 my-face-b-2 append)
     ("[ ]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
            (if font-lock-mode
          nil
        (font-lock-mode t))))

;; ;;2010/10/29 markdown-mode http://jblevins.org/projects/markdown-mode/
;; (autoload 'markdown-mode "markdown-mode.el"
;;    "Major mode for editing Markdown files" t)
;; (setq auto-mode-alist
;;    (cons '("\\.text" . markdown-mode) auto-mode-alist))

;;2010/10/27 back slash http://d.hatena.ne.jp/Watson/20100207/1265476938
(define-key global-map [?¥] [?\\])

;;2010/10/27 utf-8
;; http://rd.clojure-users.org/entry/view/52001
;; JAVA_OPTS="-Dswank.encoding=utf-8-unix" lein swank
(setq slime-net-coding-system 'utf-8-unix)

;;2010/10/20 tab symbol completion.
;;http://d.hatena.ne.jp/fatrow/20101020/tab_completion
(add-hook 'slime-mode-hook
    '(lambda ()
       (define-key slime-mode-map [(tab)]
         'slime-complete-symbol)
       (define-key slime-mode-map (kbd "C-i")
         'lisp-indent-line)))

;;2010/10/20 command key -> Meta  http://www.emacswiki.org/emacs/AquamacsFAQ
(setq mac-command-modifier 'meta)

;;2010/10/20 highlighting in the slime repl
;; http://github.com/technomancy/swank-clojure
(add-hook 'slime-repl-mode-hook
          (defun clojure-mode-slime-font-lock ()
            (let (font-lock-mode)
              (clojure-mode-font-lock-setup))))

;;2010/10/20 auto-complete.el http://dev.ariel-networks.com/Members/matsuyama/auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)

;;for global 2010/10/13 http://d.hatena.ne.jp/higepon/20060107/1136628498
;; (load-library "/opt/local/share/gtags/gtags.el")
;; (autoload 'gtags-mode "gtags" "" t)
;; (setq gtags-mode-hook
;;       '(lambda ()
;;          (local-set-key "\M-t" 'gtags-find-tag)
;;          (local-set-key "\M-r" 'gtags-find-rtag)
;;          (local-set-key "\M-s" 'gtags-find-symbol)
;;          (local-set-key "\C-t" 'gtags-pop-stack)
;;          ))

;; (add-hook 'c-mode-common-hook
;;           '(lambda()
;;              (gtags-mode 1)
;;              (gtags-make-complete-list)
;;              ))

;;2010/1/28 for shell-toggle  http://gihyo.jp/admin/serial/01/ubuntu-recipe/0038
(autoload 'shell-toggle "shell-toggle"
  "Toggles between the *shell* buffer and whatever buffer you are editing."
  t)
(autoload 'shell-toggle-cd "shell-toggle"
  "Pops up a shell-buffer and insert a \"cd <file-dir>\" command." t)
(global-set-key "\C-ct" 'shell-toggle)
(global-set-key "\C-cd" 'shell-toggle-cd)

;; set encoding UTF-8
(modify-coding-system-alist 'process "gosh" '(utf-8 . utf-8))

;; load mode files
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process." t)

(add-hook
 'cmuscheme-load-hook
 '(lambda()
    (defun scheme-args-to-list (string)
      (if (string= string "") nil
        (let ((where (string-match "[ \t]" string)))
          (cond ((null where) (list string))
                ((not (= where 0))
                 (let ((qpos (string-match "^\"\\([^\"]*\\)\"" string)))
                   (if (null qpos)
                       (cons (substring string 0 where)
                             (scheme-args-to-list
                              (substring string (+ 1 where)
                                         (length string))))
                     (cons (substring string
                                      (match-beginning 1)
                                      (match-end 1))
                           (scheme-args-to-list
                            (substring string
                                       (match-end 0)
                                       (length string)))))))
                (t (let ((pos (string-match "[^ \t]" string)))
                     (if (null pos)
                         nil
                       (scheme-args-to-list
                        (substring string pos
                                   (length string))))))))))))

;; set gosh path
(setq scheme-program-name "/opt/local/bin/gosh -i")

;; split window
(defun scheme-other-window ()
  "Run scheme on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

;; set keymap
;(define-key global-map
;  "\C-cs" 'scheme-other-window)

;; blink paren
;; Aquamacs
(show-paren-mode 1)
;; 2011/12/30 paren color
;; http://www.emacswiki.org/emacs/ShowParenMode
(require 'paren)
(set-face-background 'show-paren-match-face "#6bc");;(face-background 'default))
(set-face-foreground 'show-paren-match-face (face-foreground 'default));;"#664")
(set-face-attribute 'show-paren-match-face nil :weight 'extra-bold)

;; indent settings
(put 'and-let* 'scheme-indent-function 1)
(put 'begin0 'scheme-indent-function 0)
(put 'call-with-client-socket 'scheme-indent-function 1)
(put 'call-with-input-conversion 'scheme-indent-function 1)
(put 'call-with-input-file 'scheme-indent-function 1)
(put 'call-with-input-process 'scheme-indent-function 1)
(put 'call-with-input-string 'scheme-indent-function 1)
(put 'call-with-iterator 'scheme-indent-function 1)
(put 'call-with-output-conversion 'scheme-indent-function 1)
(put 'call-with-output-file 'scheme-indent-function 1)
(put 'call-with-output-string 'scheme-indent-function 0)
(put 'call-with-temporary-file 'scheme-indent-function 1)
(put 'call-with-values 'scheme-indent-function 1)
(put 'dolist 'scheme-indent-function 1)
(put 'dotimes 'scheme-indent-function 1)
(put 'if-match 'scheme-indent-function 2)
(put 'let*-values 'scheme-indent-function 1)
(put 'let-args 'scheme-indent-function 2)
(put 'let-keywords* 'scheme-indent-function 2)
(put 'let-match 'scheme-indent-function 2)
(put 'let-optionals* 'scheme-indent-function 2)
(put 'let-syntax 'scheme-indent-function 1)
(put 'let-values 'scheme-indent-function 1)
(put 'let/cc 'scheme-indent-function 1)
(put 'let1 'scheme-indent-function 2)
(put 'letrec-syntax 'scheme-indent-function 1)
(put 'make 'scheme-indent-function 1)
(put 'multiple-value-bind 'scheme-indent-function 2)
(put 'match 'scheme-indent-function 1)
(put 'parameterize 'scheme-indent-function 1)
(put 'parse-options 'scheme-indent-function 1)
(put 'receive 'scheme-indent-function 2)
(put 'rxmatch-case 'scheme-indent-function 1)
(put 'rxmatch-cond 'scheme-indent-function 0)
(put 'rxmatch-if 'scheme-indent-function 2)
(put 'rxmatch-let 'scheme-indent-function 2)
(put 'syntax-rules 'scheme-indent-function 1)
(put 'unless 'scheme-indent-function 1)
(put 'until 'scheme-indent-function 1)
(put 'when 'scheme-indent-function 1)
(put 'while 'scheme-indent-function 1)
(put 'with-builder 'scheme-indent-function 1)
(put 'with-error-handler 'scheme-indent-function 0)
(put 'with-error-to-port 'scheme-indent-function 1)
(put 'with-input-conversion 'scheme-indent-function 1)
(put 'with-input-from-port 'scheme-indent-function 1)
(put 'with-input-from-process 'scheme-indent-function 1)
(put 'with-input-from-string 'scheme-indent-function 1)
(put 'with-iterator 'scheme-indent-function 1)
(put 'with-module 'scheme-indent-function 1)
(put 'with-output-conversion 'scheme-indent-function 1)
(put 'with-output-to-port 'scheme-indent-function 1)
(put 'with-output-to-process 'scheme-indent-function 1)
(put 'with-output-to-string 'scheme-indent-function 1)
(put 'with-port-locking 'scheme-indent-function 1)
(put 'with-string-io 'scheme-indent-function 1)
(put 'with-time-counter 'scheme-indent-function 1)
(put 'with-signal-handlers 'scheme-indent-function 1)
(put 'with-locking-mutex 'scheme-indent-function 1)
(put 'guard 'scheme-indent-function 1)

;; (global-font-lock-mode t)


(put 'upcase-region 'disabled nil)


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
;; (when
;;     (load
;;      (expand-file-name "~/.emacs.d/elpa/package.el"))
;;  (package-initialize))



;;2011/6/21 titanium debug
(defun run-titanium ()
 "Run titnium"
 (interactive)
 (call-process "curl" nil "*run*" nil "http://localhost:9090/run-nocompress"))
(global-set-key "\C-xt" 'run-titanium)

;;2011/7/26 background alpha
(set-frame-parameter nil 'alpha 91)

;;2011/11/15 for ClojureScript
;; https://github.com/clojure/clojurescript/wiki/Emacs-%26-inferior-lisp-mode
(setq inferior-lisp-program "~/bin/browser-repl")
;; clojure-mode for .cljs
(add-to-list 'auto-mode-alist '("\\.cljs$" . clojure-mode))

;;2011/12/11 for daily memo
;; http://0xcc.net/unimag/1/
(setq user-full-name "Takahiro Hozumi")
(setq user-mail-address "fatrow@googlemail.com")
(defun memo ()
  (interactive)
  (let ((memo-file "~/Dropbox/diary.txt"))
    (if (not (eq (current-buffer)
                 (find-file-noselect memo-file)))
        (set-buffer (find-file-other-window memo-file)))
    (add-change-log-entry
     nil
     (expand-file-name memo-file))))
(define-key ctl-x-map "m" 'memo)

;;2011/12/11 kill-summary
(autoload 'kill-summary "kill-summary" nil t)
(define-key global-map "\ey" 'kill-summary)
