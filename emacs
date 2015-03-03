(tool-bar-mode -1)
;;(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(setq inhibit-startup-message t)
(global-hl-line-mode 1)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cscope-close-window-after-select t)
 '(cscope-indexer-suffixes
   (quote
    ("*.[chly]" "*.[ch]xx" "*.[ch]pp" "*.cc" "*.hh" "*.java")))
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(ecb-options-version "2.40")
 '(frame-background-mode (quote dark))
 '(send-mail-function (quote smtpmail-send-it))
 '(smtpmail-smtp-server "smtp.oupeng.com")
 '(smtpmail-smtp-service 25)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#002b36" :foreground "#839496" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "Monaco")))))

(setq package-user-dir "~/.emacs.d/elpa/")
(package-initialize)

;;(add-to-list 'load-path "~/.emacs.d/plugin")
;;(require 'linum)
(global-linum-mode 1)
;;(setq linum-format "%d ")

(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
(load-theme 'solarized-dark t)

;;(add-to-list 'load-path "~/.emacs.d/auto-complete")
;;(require 'auto-complete-config)
;;(ac-config-default)

(require 'projectile)
(projectile-global-mode 1)
(global-set-key [f5] 'projectile-find-file)

;;(require 'ecb)
;;(require 'sr-speedbar)

(require 'xcscope)
(add-hook 'java-mode-hook (lambda () (cscope-minor-mode)))

;;(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
;;(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;;;; This is your old M-x
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(require 'helm-config)
(global-set-key (kbd "M-X") 'helm-M-x)

(global-company-mode)

(add-to-list 'load-path "~/.emacs.d/evil")
(add-to-list 'load-path "~/.emacs.d/evil-leader")
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key "p" 'projectile-find-file)
(evil-leader/set-key "f" 'helm-semantic-or-imenu)
(evil-leader/set-key "t" 'helm-swoop)
(evil-leader/set-key "d" 'cscope-find-this-symbol)
(evil-leader/set-key "c" 'cscope-find-functions-calling-this-function)
(evil-leader/set-key "s" 'cscope-find-this-text-string)
(evil-leader/set-key "o" 'evil-jump-backward)
(evil-leader/set-key "i" 'evil-jump-forward)

;;(require 'evil)
(evil-mode 1)

