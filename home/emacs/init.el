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

;; theme
(use-package doom-themes
  :init (load-theme 'doom-gruvbox t))
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 10)))
(with-eval-after-load 'doom-themes
  ;; Darken the overall background color (for Gruvbox Dark)
  (set-face-attribute 'default nil :background "#1b1d1e")

  ;; Increase contrast for comments
  (set-face-attribute 'font-lock-comment-face nil
                      :foreground "#a99984"
                      :italic t))

;; fonts
(set-face-attribute 'default nil :font "Fira Code" :height 130)
(set-face-attribute 'fixed-pitch nil :font "Fira Code" :height 130)
(set-face-attribute 'variable-pitch nil :font "Fira Code" :height 130 :weight 'regular)

;; ido
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-separator "\n")
(setq ido-show-dot-for-dired t)
(use-package ido-completing-read+)
(ido-ubiquitous-mode 1)
(define-key ido-common-completion-map (kbd "C-n") 'ido-next-match)
(define-key ido-common-completion-map (kbd "C-p") 'ido-prev-match)

;; amx
(use-package amx)
(amx-mode 1)

;; company
(use-package company)
(global-company-mode)

;; magit
(use-package magit)
(define-key magit-mode-map (kbd "x") 'magit-discard)

;; current-window-only
(load "~/.config/emacs/current-window-only/current-window-only.el")
(use-package current-window-only)
(current-window-only-mode)

;; vterm
(use-package vterm)

;; Helpers
(defun create-keymap (keymap-name bindings)
  (define-prefix-command keymap-name)
  (mapc (lambda (binding)
          (define-key keymap-name (car binding) (cdr binding)))
        bindings))
(defun sudo-edit (file)
  "Edit FILE with root privileges."
  (interactive "FOpen file as root: ")
  (find-file (concat "/sudo::" file)))
(defun open-init-file ()
  (interactive)
  (sudo-edit "/etc/nixos/home/emacs/init.el"))
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

;; shell to use aliases
(setq shell-file-name "bash")
(setq shell-command-switch "-ic")

;; buffer-map
(create-keymap
 'buffer-map
 '(("k" . kill-current-buffer)
   ("s" . save-buffer)))

;; compile-map
(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
(create-keymap
 'compile-map
 '(("k" . compile)
   ("s" . compile-with-input)
   ("f" . open-compilation-buffer)
   ("r" . recompile)))

;; eval-map
(create-keymap
 'eval-map
 '(("b" . eval-buffer)
   ("r" . eval-region)))

;; file-map
(create-keymap
 'file-map
 '(("f" . ido-find-file)
   ("i" . open-init-file)
   ("s" . scratch-buffer)
   ))

;; window-map
(create-keymap
 'window-map
 '(("o" . delete-other-windows)
   ("d" . delete-window)
   ("s" . split-window-below)
   ("v" . split-window-right)
   ("h" . windmove-left)
   ("j" . windmove-down)
   ("k" . windmove-up)
   ("l" . windmove-right)
   ("b" . balance-windows)
   ("w" . next-window-any-frame)))

;; meow-mode
(use-package meow)

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
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
   '("b" . buffer-map)
   '("k" . compile-map)
   '("e" . eval-map)
   '("f" . file-map)
   '("w" . window-map))
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
   '("S" . meow-back-word)
   '("s" . meow-back-symbol)
   '("l" . meow-change)
   ;'("-" . meow-delete)
   ;'("_" . meow-backward-delete)
   '("F" . meow-next-word)
   '("f" . meow-next-symbol)
   '("z" . meow-find)
   '("g" . meow-cancel-selection)
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
   '("r" . meow-line)
   ;;'("X" . meow-goto-line)
   '("u" . meow-save)
   '("U" . meow-sync-grab)
   '("å" . meow-pop-selection)
   '("'" . repeat)
   '("<down>" . meow-page-down)
   '("<up>" . meow-page-up)
   '("<escape>" . ignore)))

(with-eval-after-load 'meow
  ;; Bind `x` to start recording a macro
  (define-key meow-normal-state-keymap (kbd "x") 'kmacro-start-macro-or-insert-counter)
  ;; Bind `X` to stop recording a macro
  (define-key meow-normal-state-keymap (kbd "X") 'kmacro-end-or-call-macro))

(with-eval-after-load 'meow
  ;; Copy original meow-char-thing-table and modify
  (setq meow-char-thing-table
	'((?f . round)
          (?d . square)
          (?s . curly)
          (?a . string)
          (?j . symbol)
          (?k . window)
          (?h . buffer)
          (?g . paragraph)
          (?l . line)
          (?r . defun)
          (?u . sentence))))

(meow-setup)
(meow-global-mode 1)

;; Langs

;; nix
(use-package nix-mode
  :mode "\\.nix\\'")
