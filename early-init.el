;; -*- lexical-binding: t; -*-

(defvar my-early-start-time (current-time))

(defun my-early-startup-mark (name)
  (message "[EARLY %.3fs] %s"
           (float-time
            (time-subtract (current-time) my-early-start-time))
           name))

(my-early-startup-mark "BEGIN")

;; increasing the limit for launch time (~50 MB).
(setq gc-cons-threshold (* 50 1000 1000))

;; return a comfortable 20 MB after a full download
(add-hook 'emacs-startup-hook
          (lambda () 
            (setq gc-cons-threshold (* 20 1000 1000))))

;; turn off internal emacs git checking
(setq vc-handled-backends nil)

;; disabling bidirectional text (Bidi) checking
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)
;; disabling the register when searching for modes
(setq auto-mode-case-fold nil)
;; deferred syntax highlighting (JIT Lock Defer)
(setq jit-lock-defer-time 0.01)

;; disable the UI elements before creating the window
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

;; disable the start screen
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(setq package-enable-at-startup nil)

(setq package-quickstart t)

(setq native-comp-deferred-compilation t)

;; Package repositories
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))


;;; Font
(set-face-attribute 'default nil :height 140)
(when (eq system-type 'windows-nt)
  (add-to-list 'default-frame-alist '(font . "Consolas")))

(my-early-startup-mark "END")
