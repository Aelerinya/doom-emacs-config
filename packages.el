;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! cff)
(package! meson-mode)
(package! elcord)
(package! flycheck-grammalecte)
(package! dockerfile-mode)
(package! emojify)
(package! epitech-emacs
  :recipe (:host github :repo "Ersikan/epitech-emacs-package"))
;(package! smartparens :disable t)
;(package! rustic :disable t)
;(package! racer :disable t)
;(package! lsp-mode)
