;; -*- lexical-binding: t; -*-

(load-theme 'wombat)
(setq inhibit-startup-message t)

(setq global-auto-revert-non-file-buffers t)
(global-auto-revert-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)

(scroll-bar-mode -1)  ; Turn off the scroll bar.
(tool-bar-mode -1)    ; Turn off the toolbar.
(tooltip-mode -1)     ; Turn off tooltips.
(set-fringe-mode 10)  ; Give some breathing room.
(menu-bar-mode -1)    ; Turn off the menu bar.

(setq truncate-lines t) ; Disable wrapping.
(setq visible-bell t)   ; Enable flashing bell.

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file nil 'silent)

(set-face-attribute 'default nil :font "Fira Code" :height 200)

(setq straight-use-package-by-default t)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package all-the-icons
  :if (display-graphic-p))

(use-package evil-nerd-commenter
  :bind ("C-/" . evilnc-comment-or-uncomment-lines))

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package keycast)

(use-package ivy
  :diminish
  :config
  (ivy-mode 1))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package doom-modeline
  :config
  (doom-modeline-mode 1)
  :custom
  ((doom-modeline-height 15)))

(setq warning-suppress-log-types '((comp)))

(column-number-mode)
(global-display-line-numbers-mode t)

(use-package vterm)

(dolist (mode '(org-mode-hook
		term-mode-hook
		vterm-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package base16-theme
  :config
  (load-theme 'base16-default-dark t))

(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))

(use-package racket-mode)
(use-package raku-mode)
(use-package go-mode)
(use-package haskell-mode)
(use-package powershell)

(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\`\\.clang-\\(format\\|tidy\\)\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(use-package meson-mode)

(use-package typescript-mode)
(use-package caml
  :config
  (add-to-list 'auto-mode-alist '("\\.ml" . caml-mode))
  (add-to-list 'auto-mode-alist '("\\.mli" . caml-mode)))
(use-package tree-sitter
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config
  (global-tree-sitter-mode)
  (add-to-list 'tree-sitter-major-mode-language-alist '(caml-mode . ocaml)))
(use-package tree-sitter-langs)
(use-package esy-mode
  :straight (esy-mode
	     :type git
	     :host github
	     :repo "ManasJayanth/esy-mode")
  :hook (caml-mode . esy-mode))

(use-package cmake-mode)

(use-package lsp-mode
  :after (typescript-mode esy-mode cmake-mode)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (add-to-list 'lsp-language-id-configuration '(racket-mode . "racket"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("racket" "-l" "racket-langserver"))
		    :major-modes '(racket-mode)
		    :activation-fn (lsp-activate-on "racket")
		    :server-id 'racketls))
  :hook
  (c-mode . lsp)
  (c++-mode . lsp)
  (cmake-mode . lsp)
  (go-mode . lsp)
  (typescript-mode . lsp)
  (rustic-mode . lsp)
  (esy-mode . lsp)
  (racket-mode . lsp))
(use-package lsp-ui)
(use-package company
  :config
  (global-company-mode))
(use-package lsp-ivy)

(use-package lsp-pyright
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp))))
(use-package poetry)

(use-package yasnippet)

(use-package rustic
  :after lsp-mode)

(use-package counsel
  :config
  (counsel-mode 1))

(use-package ivy-rich
  :config
  (ivy-rich-mode 1)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))

(use-package helpful
  :straight (helpful
	     :type git
	     :host github
	     :repo "Wilfred/helpful")
  :init
  (defvar read-symbol-positions-list nil)
  :bind (("C-h f" . helpful-callable)
	 ("C-h v" . helpful-variable)
	 ("C-h k" . helpful-key))
  :config
  (setq counsel-describe-function-function #'helpful-callable)
  (setq counsel-describe-variable-function #'helpful-variable))

(use-package magit)

(defun directory-dirs (dir)
  "Find all directories in DIR."
  (when (file-directory-p dir)
    (let ((dirs '())
	  (files (directory-files dir nil nil t)))
      (dolist (file files)
	(unless (member file '("." ".."))
	  (let ((file (concat (file-name-as-directory dir) file)))
	    (when (file-directory-p file)
	      (setq dirs (cons file dirs))))))
      dirs)))

(defun my/flatten (l)
  (apply #'append l))

(use-package s)

(defun my/find-git-repos (path)
  (if (file-directory-p path)
      (s-split "\n" (s-trim
		     (shell-command-to-string (concat "fd --exact-depth 2 . " path))))
    '()))

(defun my/discover-projects ()
  (dolist (dir (my/flatten (list (my/find-git-repos "~/Code/Git")
				 (directory-dirs "~/Documents"))))
    (when (file-exists-p dir)
      (projectile-add-known-project dir))))

(use-package projectile
  :bind
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode 1)
  (my/discover-projects))

(use-package ripgrep)

(use-package counsel-projectile
  :after (counsel projectile)
  :bind (([remap projectile-find-dir]         . counsel-projectile-find-dir))
  ([remap projectile-switch-to-buffer] . counsel-projectile-switch-to-buffer)
  ([remap projectile-grep]             . counsel-projectile-grep)
  ([remap projectile-ag]               . counsel-projectile-ag)
  ([remap projectile-switch-project]   . counsel-projectile-switch-project))

(use-package format-all)

(use-package json-mode)

(use-package restart-emacs)

(use-package pdf-tools
  :config
  (pdf-tools-install))

(defun my/find-init-file ()
  (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory)))

(defun my/search-project ()
  (interactive)
  (if (fboundp 'projectile-project-root)
      (counsel-rg nil (projectile-project-root))
    (counsel-rg)))

(defun my/kill-buffer ()
  (interactive)
  (kill-buffer nil))

(defun my/dired-current ()
  (interactive)
  (dired nil))

(use-package evil-leader
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-undo-system 'undo-tree)
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "bb" 'counsel-switch-buffer
    "bd" 'my/kill-buffer
    "bi" 'ibuffer
    "bn" 'next-buffer
    "bp" 'previous-buffer
    "bs" 'save-buffer
    "ca" 'lsp-execute-code-action
    "cc" 'compile
    "cf" 'format-all-buffer
    "fc" 'my/search-project
    "fd" 'counsel-dired
    "ff" 'counsel-find-file
    "fP" 'my/find-init-file
    "gc" 'magit-clone
    "gg" 'magit
    "gi" 'magit-init
    "o-" 'my/dired-current
    "ot" 'vterm
    "p!" 'projectile-run-shell-command-in-root
    "p&" 'projectile-run-async-shell-command-in-root
    "pa" 'projectile-add-known-project
    "pc" 'projectile-compile-project
    "pf" 'projectile-find-file
    "pg" 'projectile-configure-project
    "pp" 'projectile-switch-project
    "pr" 'project-compile
    "ps" 'projectile-save-project-buffers
    "pt" 'projectile-run-eshell
    "qq" 'save-buffers-kill-terminal
    "qr" 'restart-emacs))

(use-package undo-tree
  :config
  (global-undo-tree-mode))

(use-package evil
  :after evil-leader
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package elcord
  :config
  (elcord-mode))

(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)
(add-hook 'cmake-mode-hook #'lsp)
