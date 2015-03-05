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
 '(helm-gtags-auto-update t)
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

;;(require 'xcscope)
;;(add-hook 'java-mode-hook (lambda () (cscope-minor-mode)))

;;(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-X") 'smex)
;;(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;;;; This is your old M-x
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
;;(add-to-list 'helm-completing-read-handlers-alist '(switch-to-buffer . ido))
;;(add-to-list 'helm-completing-read-handlers-alist '(find-file . ido))
(helm-autoresize-mode 1)
(setq helm-M-x-fuzzy-match t)
;;(custom-set-variables
;; '(helm-gtags-prefix-key "C-t")
;; '(helm-gtags-suggested-key-map t))

;;company mode
(global-company-mode)
;;(global-set-key "\t" 'company-complete-common)

(add-to-list 'load-path "~/.emacs.d/evil")
(add-to-list 'load-path "~/.emacs.d/evil-leader")
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key "p" 'projectile-find-file)
(evil-leader/set-key "f" 'helm-semantic-or-imenu)
(evil-leader/set-key "w" 'helm-swoop)
(evil-leader/set-key "b" 'helm-buffers-list)
(evil-leader/set-key "d" 'helm-gtags-find-tag)
(evil-leader/set-key "g" 'helm-gtags-find-tag-from-here)
(evil-leader/set-key "r" 'helm-gtags-find-rtag)
(evil-leader/set-key "s" 'helm-gtags-find-symbol)
(evil-leader/set-key "l" 'helm-gtags-select)
(evil-leader/set-key "c" 'helm-gtags-dwim)
(evil-leader/set-key "t" 'helm-gtags-pop-stack)
(evil-leader/set-key "o" 'evil-jump-backward)
(evil-leader/set-key "i" 'evil-jump-forward)

;;(require 'evil)
(evil-mode 1)

(setq ido-enable-flex-matching t)

(yas-global-mode 1)

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
	(if (looking-at "->") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
	(if (check-expansion)
	    (company-complete-common)
	  (indent-for-tab-command)))))

(global-set-key [tab] 'tab-indent-or-complete)