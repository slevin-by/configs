(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; Set your lisp system and, optionally, some contribs
(setq inferior-lisp-program "/usr/bin/clisp")
(setq slime-contribs '(slime-fancy))

;; System-type definition
(defun system-is-linux()
    (string-equal system-type "gnu/linux"))

;; Start Emacs as a server
;;(when (system-is-linux)
    ;;(require 'server)
    ;;(unless (server-running-p)
        ;;(server-start))) ;; запустить Emacs как сервер, если ОС - GNU/Linux

;; Unix path-variable
(when (system-is-linux)
    (setq unix-sbcl-bin          "/usr/bin/sbcl")
    (setq unix-init-path         "~/.emacs.d")
    (setq unix-init-ct-path      "~/.emacs.d/plugins/color-theme")
    (setq unix-init-ac-path      "~/.emacs.d/plugins/auto-complete")
    (setq unix-init-slime-path   "/usr/share/common-lisp/source/slime/")
    (setq unix-init-ac-dict-path "~/.emacs.d/plugins/auto-complete/dict"))

; Delete selection
(delete-selection-mode t)

;; Linum plugin
(require 'linum) ;; вызвать Linum
(line-number-mode   t) ;; показать номер строки в mode-line
(global-linum-mode  t) ;; показывать номера строк во всех буферах
(column-number-mode t) ;; показать номер столбца в mode-line
(setq linum-format " %d") ;; задаем формат нумерации строк

;; Color-theme definition <http://www.emacswiki.org/emacs/ColorTheme>
(defun color-theme-init()
    (require 'color-theme)
    (color-theme-initialize)
    (setq color-theme-is-global t)
    (color-theme-charcoal-black))
(if (system-is-windows)
    (when (file-directory-p win-init-ct-path)
        (add-to-list 'load-path win-init-ct-path)
        (color-theme-init))
    (when (file-directory-p unix-init-ct-path)
        (add-to-list 'load-path unix-init-ct-path)
        (color-theme-init)))

;; Syntax highlighting
(require 'font-lock)
(global-font-lock-mode             t) ;; включено с версии Emacs-22. На всякий...
(setq font-lock-maximum-decoration t)

;; SLIME settings
(defun run-slime()
    (require 'slime)
    (require 'slime-autoloads)
    (setq slime-net-coding-system 'utf-8-unix)
    (slime-setup '(slime-fancy slime-asdf slime-indentation))) ;; загрузить основные дополнения Slime
;;;; for MS Windows
(when (system-is-windows)
    (when (and (file-exists-p win-sbcl-exe) (file-directory-p win-init-slime-path))
        (setq inferior-lisp-program win-sbcl-exe)
        (add-to-list 'load-path win-init-slime-path)
        (run-slime)))
;;;; for GNU/Linux
(when (system-is-linux)
    (when (and (file-exists-p unix-sbcl-bin) (file-directory-p unix-init-slime-path))
        (setq inferior-lisp-program unix-sbcl-bin)
        (add-to-list 'load-path unix-init-slime-path)
        (run-slime)))

;; Colors
(set-background-color "black")
