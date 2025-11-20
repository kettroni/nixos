;; sane defaults
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(setq visible-bell t)
(column-number-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt use-short-answers t)
(setq frame-resize-pixelwise t)
(global-visual-line-mode 1)

;; theme
(setq custom-safe-themes t)
(use-package gruber-darker-theme
  :init (load-theme 'gruber-darker))
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 5)))


;; fonts
(set-face-attribute 'default nil :font "Fira Code" :height 170)
(set-face-attribute 'fixed-pitch nil :font "Fira Code" :height 170)
(set-face-attribute 'variable-pitch nil :font "Fira Code" :height 170 :weight 'regular)

;; ido
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)
(setq ido-separator "\n")
(setq ido-show-dot-for-dired t)
(use-package ido-completing-read+)
(ido-ubiquitous-mode 1)
(define-key ido-common-completion-map (kbd "C-n") 'ido-next-match)
(define-key ido-common-completion-map (kbd "C-p") 'ido-prev-match)

;; amx
(use-package amx
  :config (amx-mode 1))

;; company
(use-package company
  :config (global-company-mode))

;; magit
(use-package magit
  :bind
  (:map magit-mode-map
   ("x" . magit-discard)))

(defun magit-status-fullscreen ()
  (interactive)
  (command-and-close-others 'magit-status))

;; auto-recompile
(load "~/.config/emacs/auto-recompile/auto-recompile.el")
(use-package auto-recompile)

;; direnv
(use-package direnv
  :config (direnv-mode))

;; vterm
(use-package vterm)

;; harpoon
(use-package harpoon
  :bind
  ("C-1" . 'harpoon-go-to-1)
  ("C-2" . 'harpoon-go-to-2)
  ("C-3" . 'harpoon-go-to-3)
  ("C-4" . 'harpoon-go-to-4)
  ("C-5" . 'harpoon-go-to-5)
  ("C-6" . 'harpoon-go-to-6)
  ("C-7" . 'harpoon-go-to-7)
  ("C-8" . 'harpoon-go-to-8)
  ("C-9" . 'harpoon-go-to-9)
  ("C-0" . 'harpoon-add-file))

;; drag-stuff
(use-package drag-stuff)
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

;; Helpers
(defun create-keymap (keymap-name bindings)
  (define-prefix-command keymap-name)
  (mapc (lambda (binding)
          (define-key keymap-name (car binding) (cdr binding)))
        bindings))
(defun open-init-file ()
  (interactive)
  (find-file "/home/kettroni/nixos/home/emacs/init.el"))
(defun compile-with-input ()
  (interactive)
  (let ((current-prefix-arg '(4)))
    (call-interactively 'compile)
    (delete-other-windows)))
(defun open-compilation-buffer ()
  (interactive)
  (let ((compilation-buffer "*compilation*"))
    (if (get-buffer compilation-buffer)
    (progn (pop-to-buffer compilation-buffer)
           (delete-other-windows))
      (message "No compilation buffer exists."))))

(defun command-and-close-others (command)
  (interactive)
  (call-interactively command)
  (delete-other-windows-internal))

;; buffer-map
(create-keymap 'buffer-map
               '(("k" . kill-current-buffer)
                 ("f" . save-buffer)
                 ("j" . meow-last-buffer)))

;; compile-map
(add-to-list 'compilation-error-regexp-alist
             'my-purs-errors)

(add-to-list 'compilation-error-regexp-alist-alist
             '(my-purs-errors
               "\\[.*?\\] \\([^:]+\\):\\([0-9]+\\):\\([0-9]+\\)"
               1 2 3))
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
(create-keymap 'compile-map
               '(("k" . compile)
                 ("s" . compile-with-input)
                 ("f" . open-compilation-buffer)
                 ("l" . recompile)
                 ("j" . amx)))

;; eval-map
(create-keymap 'eval-map
               '(("f" . eval-buffer)
                 ("j" . eval-region)))

;; file-map
(create-keymap 'file-map
               '(("j" . ido-find-file)
                 ("i" . open-init-file)
                 ("s" . scratch-buffer)
                 ("k" . ido-switch-buffer)
                 ))

(defun project-find-thing-at-point (word)
  (interactive)
  (project-find-regexp word))

;; project-map
(create-keymap 'project-map
               '(("l" . project-switch-project)
                 ("k" . project-compile)
                 ("f" . project-find-file)
                 ("d" . project-dired)
                 ("s" . project-find-regexp)
                 ))

;; window-map
(create-keymap 'window-map
               '(("j" . delete-other-windows-internal)
                 ("k" . delete-window)
                 ("s" . split-window-below)
                 ("d" . split-window-right)
                 ;; ("h" . windmove-left)
                 ;; ("j" . windmove-down)
                 ;; ("k" . windmove-up)
                 ;; ("l" . windmove-right)
                 ("f" . next-window-any-frame)))

;; meow-mode
(use-package meow)

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-define-keys
   'insert
   '("C-ö" . meow-insert-exit))
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet)
   '("." . ido-find-file)
   '("," . switch-to-buffer)
   '("d" . buffer-map)
   '("k" . compile-map)
   '("a" . magit-status-fullscreen)
   '("ö" . eval-map)
   '("f" . file-map)
   '("j" . project-map)
   '("l" . window-map))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("_" . negative-argument)
   '("-" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("e" . meow-beginning-of-thing)
   '("i" . meow-end-of-thing)
   '("ö" . meow-append)
   '("Ö" . meow-open-below)
   ;; '("S" . meow-back-word)
   '("s" . meow-back-symbol)
   '("l" . meow-change)
   ;'("-" . meow-delete)
   ;'("_" . meow-backward-delete)
   '("R" . meow-next-word)
   '("r" . meow-next-symbol)
   '("z" . meow-find)
   '("m" . meow-cancel-selection)
   '("G" . meow-grab)
   ;'("h" . meow-left)
   ;'("H" . meow-left-expand)
   '("a" . meow-insert)
   '("A" . meow-open-above)
   ;'("u" . meow-next)
   ;'("U" . meow-next-expand)
   ;'("i" . meow-prev)
   ;'("I" . meow-prev-expand)
   ;'("l" . meow-right)
   ;'("L" . meow-right-expand)
   '("w" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("k" . meow-yank)
   '("q" . meow-quit)
   ;'("Q" . meow-goto-line)
   '("h" . meow-replace)
   '("H" . meow-swap-grab)
   '("j" . meow-kill)
   '("t" . meow-till)
   '("p" . meow-undo)
   '("P" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("d" . meow-mark-word)
   '("D" . meow-mark-symbol)
   '("f" . meow-line)
   ;;'("X" . meow-goto-line)
   '("u" . meow-save)
   '("U" . meow-sync-grab)
   '("å" . meow-pop-selection)
   '("'" . repeat)
   '("<down>" . meow-page-down)
   '("<up>" . meow-page-up)
   '("C-." . comment-dwim)
   '("<escape>" . ignore)))

(with-eval-after-load 'meow
  ;; Bind `x` to start recording a macro
  (define-key meow-normal-state-keymap (kbd "x") 'kmacro-start-macro-or-insert-counter)
  ;; Bind `X` to stop recording a macro
  (define-key meow-normal-state-keymap (kbd "X") 'kmacro-end-or-call-macro)
  ;; Bind to do the macro
  (define-key meow-normal-state-keymap (kbd "C-q") 'kmacro-call-macro))

(with-eval-after-load 'meow
  ;; Copy original meow-char-thing-table and modify
  (setq meow-char-thing-table
    '((?f . round)
          (?d . square)
          (?s . curly)
          (?a . string)
          (?g . symbol)
          (?l . window)
          (?k . buffer)
          (?j . paragraph)
          (?h . line)
          (?m . defun)
          (?u . sentence))))

(global-set-key (kbd "C-ö") 'keyboard-escape-quit)

(meow-setup)
(meow-global-mode 1)

;; langs

;; nix
(use-package nix-mode
  :mode "\\.nix\\'")

;; python
(use-package python-mode)

;; hy
(use-package hy-mode)

;; purescript
(use-package purescript-mode)
(use-package psc-ide)
(use-package repl-toggle)
(use-package psci)

(add-hook 'purescript-mode-hook
  (lambda ()
    (psc-ide-mode)
    (company-mode)
    (flycheck-mode)
    (turn-on-purescript-indentation)
    (inferior-psci-mode)))

(add-to-list 'rtog/mode-repl-alist '(purescript-mode . psci))

;; clojure
(use-package clojure-mode)

(defun cider-switch-repl ()
  (interactive)
  (command-and-close-others 'cider-switch-to-repl-buffer))

(defun cider-switch-clj ()
  (interactive)
  (command-and-close-others 'cider-switch-to-last-clojure-buffer))

(defun cider-reload-and-rerun-test ()
  (interactive)
  (cider-load-buffer)
  (cider-test-rerun-test))

(defun cider-doc-fs ()
  (interactive)
  (command-and-close-others 'cider-doc))

(use-package cider
  :init
  (setq cider-default-cljs-repl 'nbb)
  :bind
  (:map clojure-mode-map
        ("M-o" . cider-switch-repl)
        ("M-r" . cider-eval-dwim)
        ("M-t" . cider-reload-and-rerun-test)
        ("M-K" . cider-doc-fs)
        ("M-L" . cider-load-buffer)
   :map cider-repl-mode-map
        ("M-o" . cider-switch-clj)))

;; jank
(add-to-list 'auto-mode-alist '("\\.jank\\'" . clojure-mode))

;; fsharp
(use-package fsharp-mode)

;; dired
(setq dired-dwim-target t)
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "-") 'dired-up-directory))

;; global
(keymap-global-set "C-+" 'text-scale-increase)
(keymap-global-set "C--" 'text-scale-decrease)
(keymap-global-set "C-c i" 'man)

;; This helper adds advice, which will maximize the buffer created from fn
(defun add-advice-maximize (fn-name)
  (advice-add fn-name :around
              (lambda (orig-fun &rest args)
                (let ((result (apply orig-fun args)))
                  (delete-window)
                  result))))
(add-advice-maximize 'compile)
(add-advice-maximize 'recompile)
(add-advice-maximize 'man)

;; Disable tabs and use spaces instead
(setq-default indent-tabs-mode nil) ; Use spaces instead of tabs
(setq-default tab-width 4)          ; Set the default tab width to 4 spaces
(setq-default standard-indent 4)    ; Set standard indentation to 4 spaces

;; lsp
(use-package lsp-mode
  :init
  (add-hook 'clojure-mode-hook #'lsp)
  :config
  (setq lsp-headerline-breadcrumb-enable nil)
  (lsp-enable-which-key-integration t))
