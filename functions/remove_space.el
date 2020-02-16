;;; ~/.doom.d/remove_space.el -*- lexical-binding: t; -*-

(defun remove-duplicate-spaces ()
  "Removes duplicate spaces in the current string."
  (interactive)
  (save-excursion
    (let ((start (search-backward "\""))
          (end (progn (forward-char) (search-forward "\""))))
      (replace-regexp "  " " " nil start end)
      )))
