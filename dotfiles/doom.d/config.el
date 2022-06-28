(setq doom-font (font-spec :family "Rec Mono Casual" :size 15))
(set-fontset-font t nil (font-spec :size 15 :name "JetBrainsMono Nerd Font Mono"))
(setq doom-theme 'catppuccin)

;; accept completion from copilot and fallback to company
(defun my-tab ()
  (interactive)
  (or (copilot-accept-completion)
      (company-indent-or-complete-common nil)))

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (("C-TAB" . 'copilot-accept-completion-by-word)
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         :map company-active-map
         ("<tab>" . 'my-tab)
         ("TAB" . 'my-tab)
         :map company-mode-map
         ("<tab>" . 'my-tab)
         ("TAB" . 'my-tab)))
