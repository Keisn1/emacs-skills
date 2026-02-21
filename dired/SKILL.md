---
name: dired
description: 'This skill should be used when the user invokes "/dired" to open files from the latest interaction in an Emacs dired buffer via emacsclient.'
tools: Bash
disable-model-invocation: true
---

# Open files in Emacs dired

Open files from the most recent interaction in an Emacs dired buffer using `emacsclient --eval`. Only include files relevant to the latest interaction (files just generated, edited, listed, or produced by the most recent tool output), not all files mentioned throughout the conversation.

## Strategy

Determine whether the relevant files all reside in the same directory or span multiple directories, then use the appropriate approach.

### Same directory

When all files share the same parent directory, open dired at that directory and mark the specific files. This shows them in context alongside sibling files.

```sh
emacsclient --eval '
(progn
  (dired "/path/to/directory")
  (dired-unmark-all-marks)
  (dolist (file (quote ("file1.txt" "file2.txt")))
    (dired-goto-file (expand-file-name file "/path/to/directory"))
    (dired-mark 1)))'
```

### Multiple directories

When files span different directories, create a curated dired buffer containing only the relevant files. Use the cons cell form of `dired` where the first element is the buffer name and the rest are relative file paths. Set `default-directory` to the common ancestor directory so relative paths resolve correctly.

```sh
emacsclient --eval '
(let ((default-directory "/common/ancestor/"))
  (dired (quote ("*agent-files*"
                 "relative/path/file1.txt"
                 "other/path/file2.txt")))
  (dired-unmark-all-marks)
  (dired-toggle-marks))'
```

## Rules

- Set `default-directory` to the appropriate base directory and use relative paths.
- For the same-directory case, use `dired-goto-file` with `expand-file-name` to ensure reliable matching.
- For the multi-directory case, name the buffer `*agent-files*`.
- If no relevant files exist in the recent interaction, inform the user that there are no files to open.
- Run the `emacsclient --eval` command via the Bash tool.
