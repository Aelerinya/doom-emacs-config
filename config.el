;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(require 'cff)
;; defines shortcut for find source/header file for the current
;; file
(add-hook 'c++-mode-hook
           '(lambda ()
              (define-key c-mode-base-map (kbd "M-o") 'cff-find-other-file)))
(add-hook 'c-mode-hook
           '(lambda ()
              (define-key c-mode-base-map (kbd "M-o") 'cff-find-other-file)))

(setq doom-font (font-spec :family "Source Code Pro" :size 16))

;; Setup elcord
(require 'elcord)
(elcord-mode)

;; Setup flycheck-grammalecte
(require 'flycheck-grammalecte)

(setq neo-window-width 15
      neo-window-fixed-size nil)
;; Workaround for rustic automatic lsp-mode install
(after! rustic
  (defadvice! +rust--dont-install-packages-p (orig-fn &rest args)
    :around #'rustic-setup-lsp
    (cl-letf (;; `rustic-setup-lsp' uses `package-installed-p' to determine if
              ;; lsp-mode/elgot are available. This breaks because Doom doesn't
              ;; use package.el to begin with (and lazy loads it).
              ((symbol-function #'package-installed-p)
               (lambda (pkg)
                 (require pkg nil t)))
              ;; If lsp/elgot isn't available, it attempts to install lsp-mode
              ;; via package.el. Doom manages its own dependencies so we disable
              ;; that behavior.
              ((symbol-function #'rustic-install-lsp-client-p)
               (lambda (&rest _)
                 (message "No RLS server running"))))
      (apply orig-fn args))))
;; Automatic buffer formating for rsutic
(setq rustic-format-on-save t)

;; Flycheck checker chains
(flycheck-add-next-checker 'francais-grammalecte 'tex-chktex)

;; Start emojify
(add-hook 'after-init-hook #'global-emojify-mode)

;; Configure web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tera\\'" . web-mode))
(setq web-mode-engines-alist
      '(("jinja2"    . "\\.tera\\'"))
)

;; Workaround for emacs incompatibility with input methods managers
(require 'iso-transl)

;; Maybe fix lsp ?
(setq lsp-prefer-flymake nil)
