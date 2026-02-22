(require 'cl-lib)

(cl-defun agent-skill-select (&key file start end)
  "Open FILE in Emacs and select the region from START to END line."
  (find-file file)
  (goto-char (point-min))
  (forward-line (1- start))
  (set-mark (point))
  (forward-line (- end start))
  (end-of-line)
  (activate-mark))

(provide 'agent-skill-select)
