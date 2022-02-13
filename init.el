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

(setq custom-file "~/.config/emacs.custom/custom.el")
(load custom-file)

(set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 140)

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
  (load-theme 'base16-tomorrow t))

(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))

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

(use-package yasnippet)

(use-package lsp-mode
  :after (typescript-mode esy-mode)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  (c-mode . lsp)
  (c++-mode . lsp)
  (cmake-mode . lsp)
  (typescript-mode . lsp)
  (rustic-mode . lsp)
  (esy-mode . lsp))
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
	     :repo "Wilfred/helpful"
	     :fork (:host github
			  :repo "rhaps0dy/helpful"))
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
  (unless (file-directory-p dir)
    (error "Not a directory: `%s'" dir))
  (let ((dirs '())
	(files (directory-files dir nil nil t)))
    (dolist (file files)
      (unless (member file '("." ".."))
	(let ((file (concat (file-name-as-directory dir) file)))
	  (when (file-directory-p file)
	    (setq dirs (cons file dirs))))))
    dirs))

(use-package projectile
  :bind
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode 1)
  (dolist (dir (directory-dirs "~/Code/"))
    (projectile-add-known-project dir)))

(use-package ripgrep)

(use-package counsel-projectile
  :after (counsel projectile)
  :bind (([remap projectile-find-dir]         . counsel-projectile-find-dir))
  ([remap projectile-switch-to-buffer] . counsel-projectile-switch-to-buffer)
  ([remap projectile-grep]             . counsel-projectile-grep)
  ([remap projectile-ag]               . counsel-projectile-ag)
  ([remap projectile-switch-project]   . counsel-projectile-switch-project))

(use-package format-all)

(require 'cmake-mode)
(use-package json-mode)

(defun my/find-init-file ()
  (interactive)
  (find-file "~/.config/emacs.custom/init.el"))

(defun my/search-project ()
  (interactive)
  (if (fboundp 'projectile-project-root)
      (counsel-rg nil (projectile-project-root))
    (counsel-rg)))

(defun my/kill-buffer ()
  (interactive)
  (kill-buffer nil))

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
    "ot" 'eshell
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
    "qq" 'save-buffers-kill-terminal))

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
