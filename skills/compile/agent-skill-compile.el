(require 'cl-lib)

(cl-defun agent-skill-compile (&key dir command)
  "Run COMMAND in an Emacs compilation buffer with DIR as `default-directory'."
  (let ((default-directory (file-name-as-directory dir)))
    (compile command)))

(provide 'agent-skill-compile)
