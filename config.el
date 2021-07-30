(setq user-full-name "Rajat"
      user-mail-address "rajat241994@gmail.com")

(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "SauceCodePro Nerd Font Mono" :size 13)
      doom-variable-pitch-font (font-spec :family "Monaco" :size 15)
      doom-big-font (font-spec :family "Source Code Pro" :size 24))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(defun my/org-mode/load-prettify-symbols () "Prettify org mode keywords"
  (interactive)
  (setq prettify-symbols-alist
    (mapcan (lambda (x) (list x (cons (upcase (car x)) (cdr x))))
          '(("#+begin_src" . ?)
            ("#+end_src" . ?―)
            ("#+begin_example" . ?)
            ("#+end_example" . ?)
            ("#+DATE:" . ?⏱)
            ("#+AUTHOR:" . ?✏)
            ("[ ]" .  ?☐)
            ("[X]" . ?☑ )
            ("[-]" . ?❍ )
            ("lambda" . ?λ)
            ("#+header:" . ?)
            ("#+name:" . ?﮸)
            ("#+results:" . ?)
            ("#+call:" . ?)
            (":properties:" . ?)
            (":logbook:" . ?))))
  (prettify-symbols-mode 1))
(add-hook 'org-mode-hook #'my/org-mode/load-prettify-symbols)

(setq org-directory "~/org/")

;; Add keybinding for org-babel-tangle
(map! :after evil-org
      :map evil-org-mode-map
      :localleader
      :desc "Tangle org file"
      :n "B" #'org-babel-tangle)

(global-display-line-numbers-mode) ;; only works with emacs >= 26
(setq display-line-numbers-type 'relative)

;; Auto-load files when changed
(global-auto-revert-mode t)

;; Auto-save files.
(setq auto-save-default t)

(map! :desc "Copy till end of line"
      :n "Y" "y$")
(map! :desc "Jump backward"
      :n "[ g" 'evil-jump-backward)
(map! :desc "Jump forward"
      :n "] g" 'evil-jump-forward)
(map! :leader
      :desc "Rename buffer"
      :n "b R" 'rename-buffer)
(map! :desc "Previous error"
      :n "[ e" #'flycheck-previous-error)
(map! :desc "Next error"
      :n "] e" #'flycheck-next-error)

(setq evil-split-window-below t)
(setq evil-vsplit-window-right t)

(use-package flyspell
  :config
  (setq ispell-program-name "aspell")
  (setq flyspell-prog-text-faces
        (delq 'font-lock-string-face
              flyspell-prog-text-faces))
  (add-hook 'text-mode-hook 'flyspell-mode)
  (add-hook 'prog-mode-hook 'flyspell-prog-mode))

(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :init
)

;;Optional - provides fancier overlays.
(setq lsp-ui-doc-enable nil
      lsp-ui-peek-enable t
      lsp-ui-sideline-enable t
      lsp-ui-imenu-enable t
      lsp-ui-flycheck-enable t)

(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp-deferred))))

(setq lsp-gopls-staticcheck t)
(setq lsp-eldoc-render-all nil)
(setq lsp-gopls-complete-unimported t)

;;Set up before-save hooks to format buffer and add/delete imports.
;;Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;;Company mode is a standard completion package that works well with lsp-mode.
;;company-lsp integrates company mode completion with lsp-mode.
;;completion-at-point also works out of the box but doesn't support snippets.

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1))

(use-package company-lsp
  :ensure t
  :commands company-lsp)

;; disable company mode in eshell (major nuisance)
(setq company-global-modes '(not eshell-mode))

;;Optional - provides snippet support.
(use-package yasnippet
  :ensure t
  :commands yas-minor-mode
  :hook (go-mode . yas-minor-mode))

(setq eshell-rc-script (expand-file-name "eshell/profile" doom-private-dir)
      eshell-aliases-file (expand-file-name "eshell/aliases" doom-private-dir)
      eshell-history-file-name (expand-file-name "eshell/history" doom-private-dir)
      eshell-history-size 5000
      eshell-buffer-maximum-lines 5000
      eshell-hist-ignoredups t
      eshell-scroll-to-bottom-on-input t
      eshell-kill-on-exit t
      eshell-destroy-buffer-when-process-dies t
      eshell-visual-commands'("bash" "htop" "ssh" "top" "zsh" "less"))

(map! :leader
      :desc "Eshell" "e s" #'eshell
      :desc "Counsel eshell history" "e h" #'counsel-esh-history)

(setq doom-modeline-vcs-max-length 25)

(setq vterm-kill-buffer-on-exit t
      vterm-max-scrollback 5000)
;; Ensure mode line is not hidden for vterm, makes it easier to see the current mode(nvi).
(remove-hook 'vterm-mode-hook 'hide-mode-line-mode)
