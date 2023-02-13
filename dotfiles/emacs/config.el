;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'catppuccin)

(use-package! autothemer
  :ensure t)

(use-package! copilot
  :config (setq copilot--base-dir (getenv "EMACS_PATH_COPILOT"))
  :hook (prog-mode . copilot-mode)
  :bind (("C-TAB" . 'copilot-accept-completion-by-word)
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         :map copilot-completion-map
         ("<tab>" . 'copilot-accept-completion)
         ("TAB" . 'copilot-accept-completion)))

(setq user-full-name "Mars"
      user-mail-address "mars@pupbrained.xyz")

(setq org-directory "~/org/")

(setq doom-font (font-spec :family "CartographCF Nerd Font" :size 16)
      doom-variable-pitch-font (font-spec :family "Google Sans")
      doom-unicode-font (font-spec :family "CartographCF Nerd Font")
      doom-big-font (font-spec :family "CartographCF Nerd Font" :size 20))

(setq display-line-numbers-type 'relative)
