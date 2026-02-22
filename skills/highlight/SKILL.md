---
name: highlight
description: 'This skill should be used when the user invokes "/highlight" to highlight relevant regions in one or more files in Emacs via emacsclient.'
tools: Bash
disable-model-invocation: true
---

# Highlight regions in Emacs

Highlight relevant regions in a file in Emacs using `emacsclient --eval`. The file is opened in a temporary read-only minor mode (`agent-skill-highlight-mode`) with highlighted overlays. The user presses `q` to exit the mode and remove all highlights.

Determine the relevant file and line ranges from the most recent interaction context.

## How to highlight

The elisp below defines the minor mode (if not already defined), opens the file, creates highlight overlays, and enables the mode. Replace the file path and overlay regions as needed.

Each overlay is defined by a start line and the number of lines to highlight.

```sh
emacsclient --eval '
(progn
  (unless (fboundp (quote agent-skill-highlight-mode))
    (defvar-local agent-skill-highlight--overlays nil)
    (defvar-local agent-skill-highlight--was-read-only nil)
    (defun agent-skill-highlight--remove-overlays ()
      (mapc (function delete-overlay) agent-skill-highlight--overlays)
      (setq agent-skill-highlight--overlays nil))
    (defun agent-skill-highlight-exit ()
      (interactive)
      (agent-skill-highlight-mode -1))
    (define-minor-mode agent-skill-highlight-mode
      "Temporary read-only mode with highlighted regions. Press q to exit."
      :lighter " Highlight"
      :keymap (let ((map (make-sparse-keymap)))
                (define-key map (kbd "q") (function agent-skill-highlight-exit))
                map)
      (if agent-skill-highlight-mode
          (progn
            (setq agent-skill-highlight--was-read-only buffer-read-only)
            (read-only-mode 1)
            (message "Press q to exit highlights"))
        (agent-skill-highlight--remove-overlays)
        (unless agent-skill-highlight--was-read-only
          (read-only-mode -1)))))
  (find-file "/path/to/file")
  (let ((ov1 (make-overlay
               (progn (goto-char (point-min)) (forward-line START_LINE_MINUS_1) (point))
               (progn (forward-line NUM_LINES) (point))))
        (ov2 (make-overlay
               (progn (goto-char (point-min)) (forward-line START_LINE_MINUS_1) (point))
               (progn (forward-line NUM_LINES) (point)))))
    (overlay-put ov1 (quote face) (quote hi-yellow))
    (overlay-put ov2 (quote face) (quote hi-yellow))
    (push ov1 agent-skill-highlight--overlays)
    (push ov2 agent-skill-highlight--overlays))
  (agent-skill-highlight-mode 1))'
```

Replace `START_LINE_MINUS_1` with the 0-indexed start line (line number minus 1) and `NUM_LINES` with how many lines the region spans. Add or remove overlay `let` bindings as needed for the number of regions.

## Multiple files

When the context involves regions across multiple files, repeat the `find-file` + overlays + `agent-skill-highlight-mode` block for each file within the same `progn` (after the minor mode definition). The mode is buffer-local, so each file gets its own highlights and independent `q` to exit.

## Rules

- Use absolute paths for files.
- Use `hi-yellow` as the overlay face.
- Add as many overlays as needed to highlight all relevant regions.
- When regions span multiple files, enable the mode in each file.
- If no relevant file or regions exist in the recent interaction, inform the user.
- Run the `emacsclient --eval` command via the Bash tool.
