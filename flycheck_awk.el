;;; ~/.doom.d/flycheck_awk.el -*- lexical-binding: t; -*-

(defun my-flycheck-gawk-fix-message (err)
  "Remove the repeated file-name/line from the error message of ERR."
  (setf (flycheck-error-message err)
        (replace-regexp-in-string
         "^\\([ \t]*\\)\\(.*\n\\)\\1"
         "\\2"
         (replace-regexp-in-string
          "\ngawk: [^ ]*:"
          "\n"
          (flycheck-error-message err))))
  err)

(defun my-flycheck-gawk-error-filter (errors)
  (seq-do #'my-flycheck-gawk-fix-message errors)
  errors)

(flycheck-define-checker gawk
  "GNU awk's built-in --lint checker."
  :command ("gawk"
            ;; Avoid code execution https://github.com/w0rp/ale/pull/1411
            "--source" "'BEGIN{exit} END{exit 1}'"
            "-f"
            source-original
            "--lint"
            "/dev/null")
  :standard-input nil
  :error-patterns
  ((warning line-start
            "gawk: "
            (file-name) ":" line ":" (optional column ":")
            (message (one-or-more not-newline)
                     (optional "\n"
                               (one-or-more not-newline)
                               " ^ "
                               (one-or-more not-newline)))
            line-end))
  :error-filter my-flycheck-gawk-error-filter
  :modes awk-mode)
(add-to-list 'flycheck-checkers 'gawk)
