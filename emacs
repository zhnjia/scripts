; -*-lisp-*-
(tool-bar-mode -1)
(setq-default indent-tabs-mode nil)
(setq-default fill-column 80)
(electric-pair-mode 1)
(global-superword-mode)
(scroll-bar-mode -1)
(setq make-backup-files nil)
(column-number-mode 1)
(setq auto-save-default nil)
(setq inhibit-startup-message t)
(global-hl-line-mode 1)
(global-set-key (kbd "<apps>") 'helm-execute-extended-command)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 ;;'(cursor-type (quote bar))
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(frame-background-mode (quote dark))
 '(helm-autoresize-max-height 30)
 '(helm-gtags-auto-update t)
 '(helm-gtags-prefix-key "g")
 '(helm-gtags-suggested-key-mapping t)
 '(send-mail-function (quote smtpmail-send-it))
 '(smtpmail-smtp-server "smtp.oupeng.com")
 '(smtpmail-smtp-service 25)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#002b36" :foreground "#839496" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "Ubuntu Mono")))))

(setq package-user-dir "~/.emacs.d/elpa/")
(package-initialize)

(global-linum-mode 1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
(load-theme 'solarized-dark t)

(setq ido-enable-flex-matching t)
(setq ido-case-fold t)

(global-set-key (kbd "M-<ESC>") 'smex)

(helm-mode 1)

(global-set-key (kbd "C-*") 'occur)
(helm-autoresize-mode 1)

;(setq helm-alist-list '((switch-to-buffer . ido)
;                        (find-file . ido)
;                        (dired . ido)
;                        (execute-extended-command . ido)
;                        (dired-create-directory . ido)
;                        (dired-do-rename . ido)
;                        (dabbrev-completion . ido)
;                        (diff . ido)
;                        (kill-buffer . ido)))
;(setq helm-completing-read-handlers-alist
;      (append helm-completing-read-handlers-alist helm-alist-list))
(global-set-key (kbd "C-c h g g") 'helm-git-grep-from-here)
(global-set-key (kbd "C-c h p g") 'helm-projectile-grep)
(global-set-key (kbd "C-c h s i") 'helm-semantic-or-imenu)
(global-set-key (kbd "C-c h o") 'helm-occur)
(global-set-key (kbd "C-c h r") 'helm-resume)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(require 'google-c-style)
(add-hook 'c-mode-common-hook
  (lambda()
    (subword-mode)
    (google-set-c-style)
    (google-make-newline-indent)
    (setq c-basic-offset 4)))

(add-hook 'java-mode-hook '(setq fill-column 100))

(add-hook 'prog-mode-hook
  (lambda()
    (local-set-key (kbd "C-c o") 'ff-find-other-file)
    (helm-gtags-mode)
    (rainbow-delimiters-mode)
    (semantic-mode)
    (yas-global-mode)
    (global-flycheck-mode)
    (flyspell-prog-mode)
    (fci-mode)))

(setq fci-rule-color "darkred")

(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match t)

(projectile-global-mode 1)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(setq projectile-switch-project-action 'helm-projectile)
(add-to-list 'grep-find-ignored-files "GTAGS")
(add-to-list 'grep-find-ignored-files "GRTAGS")
(add-to-list 'grep-find-ignored-files "GPATH")

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)
(setq-default evil-symbol-word-search t)

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
            (company-begin-backend 'company-gtags)
	    (company-complete-common)
	  (indent-for-tab-command)))))

(global-set-key [tab] 'tab-indent-or-complete)
;;(put 'Info-edit 'disabled nil)
(add-hook 'after-init-hook 'global-company-mode)

(window-numbering-mode)

(global-set-key (kbd "C-%") 'match-paren)
 (defun match-paren (arg)
   "Go to the matching paren if on a paren; otherwise insert %."
   (interactive "p")
   (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
         ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
         (t (self-insert-command (or arg 1)))))

(defalias 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "C-c r b") 'revert-buffer)
(global-set-key (kbd "C-c t w") 'delete-trailing-whitespace)
(global-set-key (kbd "C-x r i") 'string-insert-rectangle)

(global-whitespace-mode)
(setq whitespace-style
 '(face trailing tabs empty spaces space-after-tab space-before-tab newline indentation))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun surround-with-parens ()
  (interactive)
  (save-excursion
    (goto-char (region-beginning))
    (insert "("))
  (goto-char (region-end))
  (insert ")"))

(defun delete-surrounded-parens ()
  (interactive)
  (let ((beginning (region-beginning))
        (end (region-end)))
    (cond ((not (eq (char-after beginning) ?\())
           (error "Character at region-begin is not an open-parenthesis"))
          ((not (eq (char-before end) ?\)))
           (error "Character at region-end is not a close-parenthesis"))
          ((save-excursion
             (goto-char beginning)
             (forward-sexp)
             (not (eq (point) end)))
           (error "Those parentheses are not matched"))
          (t (save-excursion
               (goto-char end)
               (delete-backward-char 1)
               (goto-char beginning)
               (delete-char 1))))))

(defun surround (begin end open close)
  "Put OPEN at START and CLOSE at END of the region.
If you omit CLOSE, it will reuse OPEN."
  (interactive  "r\nsStart: \nsEnd: ")
  (when (string= close "")
    (setq open close))
  (save-excursion
    (goto-char end)
    (insert close)
    (goto-char begin)
    (insert open)))
