;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; Load theme
(setq doom-theme 'molokai)

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
;; (require 'elcord)
;; (elcord-mode)

;; Setup flycheck-grammalecte
;; (require 'flycheck-grammalecte)
;; Flycheck checker chains
;; (flycheck-add-next-checker 'francais-grammalecte 'tex-chktex)

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
;; (setq rustic-format-on-save t)

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

;; Chck syntax automatically
(after! flycheck
  (setq flycheck-check-syntax-automatically '(save idle-change new-line mode-enabled)))

;; Use rust analyser instead of rls
(setq rustic-lsp-server 'rust-analyzer)

(setq lsp-rust-all-features t)

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
;; (defun rename-file-and-buffer (new-name)
;;   "Renames both current buffer and file it's visiting to NEW-NAME."
;;   (interactive "sNew name: ")
;;   (let ((name (buffer-name))
;;         (filename (buffer-file-name)))
;;     (if (not filename)
;;         (message "Buffer '%s' is not visiting a file!" name)
;;       (if (get-buffer new-name)
;;           (message "A buffer named '%s' already exists!" new-name)
;;         (progn
;;           (rename-file filename new-name 1)
;;           (rename-buffer new-name)
;;           (set-visited-file-name new-name)
;;           (set-buffer-modified-p nil))))))

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let* ((name (buffer-name))
         (filename (buffer-file-name))
         (basename (file-name-nondirectory filename)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " (file-name-directory filename) basename nil basename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

;; Disable c++-clang and c++-gcc as syntax checker
(setq-default flycheck-disabled-checkers (list 'c/c++-clang 'c/c++-gcc))

;; Disable completion edits for c mode
(add-hook! (c-mode c++-mode)
  (setq lsp-completion-enable-additional-text-edit nil))

;; Julia lsp setup
(setq lsp-julia-default-environment "~/.julia/environments/v1.0")
(setq lsp-enable-folding t)

;; Solidity setup
;; (setq solidity-flycheck-solc-checker-active t)
;; (setq solidity-flycheck-solium-checker-active t)

(add-hook 'magit-mode-hook (lambda () (magit-delta-mode +1)))

;; Copy file name
(defun copy-buffer-file-path ()
  "Copies the file path associated with the buffer to the kill ring"
  (interactive)
  (kill-new (let ((project-root (projectile-project-root))
                  (buffer-path (buffer-file-name)))
              (if project-root
                  (string-remove-prefix project-root buffer-path)
                buffer-path)) ))

(map! :leader (:prefix "p" :n "y" #'copy-buffer-file-path))
