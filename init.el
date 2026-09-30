;; -*- lexical-binding: t; -*-
(defvar my-start-time (current-time))

(defun my-startup-mark (name)
  (message "[STARTUP %.3fs] %s"
           (float-time (time-subtract (current-time) my-start-time))
           name))

(my-startup-mark "BEGIN")

;;; initialize package.el
;;(package-initialize)

(my-startup-mark "my-workflows")
(require 'my-workflows)

;;(setq package-check-signature nil)

(setq whitespace-line-column 500)

(setq fancy-splash-image nil)

;;; disable beep sound
(setq ring-bell-function 'ignore)
(setq w32-use-visible-system-caret nil)

;;; opening executable
(setq dired-guess-shell-alist-user
      '(("\\.exe\\'" "start")))

;;; Font
;; (my-startup-mark "get-default-font")
;; (defun get-default-font ()
;;   (cond
;;    ((eq system-type 'windows-nt) "Consolas-14")
;;    ((eq system-type 'gnu/linux) "Ubuntu Mono-14")))

;;(add-to-list 'default-frame-alist `(font . ,(get-default-font)))

;;; theme init
(my-startup-mark "load-theme")
(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(load-theme 'vsd t)

;;; ido-mode
(my-startup-mark "ido-mode")
(use-package ido
  :ensure nil
  :custom
  (ido-use-faces nil)
  :config
  (ido-mode 1)
  (ido-everywhere 1))
  
;;; smex
(use-package smex
  :ensure t
  :bind (("M-x" . smex)
         ("C-c C-c M-x" . execute-extended-command)))

;;; paredit
(my-startup-mark "paredit")
(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode
          clojure-mode
          lisp-mode
          common-lisp-mode
          scheme-mode
          racket-mode) . paredit-mode))

;;; tab width
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;;; coding system
(set-language-environment "UTF-8")

(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-selection-coding-system 'utf-8-unix)

(setq-default buffer-file-coding-system 'utf-8-unix)

(add-hook 'before-save-hook
          (lambda ()
            (set-buffer-file-coding-system 'utf-8-unix)))

;;; backup saves
(setq backup-directory-alist
      `(("." . ,(expand-file-name "saves/" user-emacs-directory))))

(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "saves/" user-emacs-directory) t)))

;; TAB insert by key
(defalias 'yes-or-no-p 'y-or-n-p)

;;; c-mode
(setq-default c-basic-offset 4)
(with-eval-after-load 'cc-vars
  (setq c-default-style '((java-mode . "java")
                          (awk-mode . "awk")
                          (other . "k&r"))))
(add-hook 'c-mode-common-hook 
          (lambda () 
            (c-toggle-comment-style -1)))


(my-startup-mark "go-mode")
(use-package go-mode
  :mode "\\.go\\'")

;;; lua
(my-startup-mark "lua-mode")
(use-package lua-mode
  :mode "\\.lua\\'"
  :custom
  (lua-indent-level 4))
;;; odin
(my-startup-mark "odin-mode")
(use-package odin-mode
  :mode "\\.odin\\'")

;;; simpc
(use-package simpc-mode
  :mode "\\.[hc]\\(pp\\)?\\'"
  :custom
  (simpc-indent-level 4))

;;; markdown
(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . markdown-mode))

;;; python
(setq-default python-indent-offset 4)

;;; ada
(setq-default ada-indent 4)

(defun display-current-time ()
  (interactive)
  (message (format-time-string "%d-%m-%Y %H:%M:%S")))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                   (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)


;;display-line-numbers-mode
(my-startup-mark "global-display-line-numbers-mode")
(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

(setq display-line-numbers-type 'relative)

(setq vc-handled-backends nil)
;;; magit
(my-startup-mark "magit")
(use-package magit
  :ensure t
  :defer t
  :bind (("C-c m s" . magit-status)
         ("C-c m l" . magit-log))
  :init
  (when (eq system-type 'windows-nt)
    (let ((win-git "C:/git/bin/git.exe"))
      (when (file-exists-p win-git)
        (setq magit-git-executable win-git))))
  
  (setq magit-auto-revert-mode nil)

  (run-with-idle-timer 3 nil (lambda () (require 'magit nil t)))
  
  :config
  (setq magit-sign-attach nil
        server-use-tcp nil
        magit-remote-executable nil
        magit-process-connection-type nil))

;;; multiple cursors
(my-startup-mark "multiple cursors")
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("C-\""        . mc/skip-to-next-like-this)
         ("C-;"         . mc/skip-to-previous-like-this)))

;;; Move Text
(my-startup-mark "move-text")
(use-package move-text
  :bind (("M-p" . move-text-up)
         ("M-n". move-text-down)))

;;; Emacs lisp
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-j")
                            (quote eval-print-last-sexp))))
(add-to-list 'auto-mode-alist '("Cask" . emacs-lisp-mode))

(setq comment-auto-fill-only-comments t)
(add-hook 'text-mode-hook
          (lambda () (auto-fill-mode -1)))

;;; yasnippet
(my-startup-mark "yasnippet")

;; (yas-global-mode 1)

(use-package yasnippet
  :ensure t
  :defer t
  :hook ((prog-mode . yas-minor-mode)
         (org-mode . yas-minor-mode))
  :config
  (setq yas-snippet-dirs (list (expand-file-name "snippets" user-emacs-directory)))
  (yas-reload-all)
  (yas-global-mode 1))

;;; Company
(my-startup-mark "company")

(use-package company
  ;; We turn it on automatically only in programming modes
  :ensure t
  :hook (prog-mode . company-mode)
  :custom
  (company-idle-delay nil)
  (company-minimum-prefix-length 1)
  :bind ("C-M-/" . company-complete))

;;; helm
(my-startup-mark "helm")

;; helm
(use-package helm
  :ensure t
  :bind (("C-c h t"   . helm-cmd-t)
         ("C-c g s"   . helm-imenu)
         ("C-c h f"   . helm-find)
         ("C-c h a"   . helm-org-agenda-files-headings)
         ("C-c h r"   . helm-recentf))
  :custom
  (helm-ff-transformer-show-only-basename nil))

(use-package helm-projectile
  :bind (("C-c p f" . helm-projectile-find-file)))

(use-package helm-git-grep
  :bind (("C-c p s" . helm-do-grep-ag)))

(use-package helm-ls-git
  :bind (("C-c h g l" . helm-ls-git-ls)))


(global-set-key (kbd "C-x p f") 'find-file-in-repository)
(global-set-key (kbd "C-c v s") 'vc-git-grep)

(my-startup-mark "dead-grip")
(use-package deadgrep
  :ensure t
  :bind (("C-c g d" . deadgrep)))

(setq my-rg-args
      '("-nH" "--no-heading" "--color" "never" "-S"
        "-I" ;; ignore binaries
        "--max-columns" "200"
        "--hidden"
        "--glob" "!.git" "--glob" "!node_modules"
        "--glob" "!dist" "--glob" "!build"))

(setq grep-program "rg")
(setq grep-command "rg -irn --vimgrep --no-heading --color never --max-columns 200 ")

(defun my-find-file-rg ()
  (interactive)
  (let ((files (split-string (shell-command-to-string "rg --files --hidden --glob '!.git/*'") "\n" t)))
    (find-file (completing-read "File: " files))))

(global-set-key (kbd "C-c f f") 'my-find-file-rg)

;;; dired
(my-startup-mark "dired")
(use-package dired
  :defer t
  :bind (:map dired-mode-map
              ("q" . kill-current-buffer))
  :config
  ;; load dired-x only after dired itself.
  (require 'dired-x)
  (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
  (setq-default dired-dwim-target t)
  (setq dired-listing-switches "-alh")
  (setq dired-mouse-drag-files t)
  (setq ls-lisp-dirs-first t)
  
  ;; dired sort
  (defun my-dired-sort()
    "Sort dired listings with directories first."
    (interactive)
    (save-excursion
      (let (buffer-read-only)
        (forward-line 2) ;; beyond dir. header 
        (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
      (set-buffer-modified-p nil)))

  (add-hook 'dired-after-readin-hook #'my-dired-sort))

(setq dired-dwim-target t)

;; Source: http://www.emacswiki.org/emacs-en/download/misc-cmds.el
(defun my-revert-buffer-no-confirm()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm))
(put 'downcase-region 'disabled nil)

(defun my-smart-open-line-above()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "M-o") 'my-smart-open-line)
(global-set-key (kbd "M-O") 'my-smart-open-line-above)

(defun my-kill-compilation-tree()
  "Kill current compilation process tree on Windows."
  (interactive)
  (let ((proc (get-buffer-process "*compilation*")))
    (if (and proc (process-live-p proc))
        (shell-command
         (format "taskkill /PID %d /T /F >NUL 2>&1"
                 (process-id proc)))
      (message "No live compilation process"))))

(global-set-key (kbd "C-c C-M-k") #'my-kill-compilation-tree)
(global-set-key (kbd "C-c d") 'duplicate-line)

(my-startup-mark "load custom-file")
(add-hook 'after-init-hook
          (lambda ()
            (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
            (when (file-exists-p custom-file)
              (load custom-file nil t))))

(my-startup-mark "END")
