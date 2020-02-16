;;; ~/.doom.d/replace_placeholders.el -*- lexical-binding: t; -*-

(defun replace-placeholders ()
  "Removes duplicate spaces in the current string."
  (interactive)
  (save-excursion
      ;; (replace-regexp "\[(.+?)]" "\" << _\,(downcase \1) << \"" nil start end)
      (if (use-region-p)
          (progn
            (message "beg %d end %d" (region-beginning) (region-end))
            (goto-char (region-beginning))
            (while (re-search-forward "LOL" (region-end))
              (replace-match
               (concat "\" << _" );(downcase (match-string 1)) " << \"")
               t))))))

;;" "LOL << _[" << _] << " "
