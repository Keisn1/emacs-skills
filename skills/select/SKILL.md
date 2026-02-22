---
name: select
description: 'This skill should be used when the user invokes "/select" to open a file in Emacs and select a region relevant to the current discussion via emacsclient.'
tools: Bash
disable-model-invocation: true
---

# Select region in Emacs

Open a file in Emacs and select (activate the region around) the code or text most relevant to the current discussion using `emacsclient --eval`. This allows the user to immediately act on the selection: narrow, copy, refactor, comment, etc.

Determine the relevant file and line range from the most recent interaction context.

## How to select

First, locate `agent-skill-select.el` which lives alongside this skill file at `skills/select/agent-skill-select.el` in the emacs-skills plugin directory.

```sh
emacsclient --eval '
(progn
  (load "/path/to/skills/select/agent-skill-select.el" nil t)
  (agent-skill-select
    :file "/path/to/file"
    :start 10
    :end 25))'
```

- `:start` is the 1-indexed start line.
- `:end` is the 1-indexed end line.

## Rules

- Use absolute paths for files.
- Choose the region most relevant to the current discussion (e.g., a function just modified, a block with an error, code just generated).
- If no specific region is apparent, select the entire relevant function or block.
- Locate `agent-skill-select.el` relative to this skill file's directory.
- If no relevant file or region exists in the recent interaction, inform the user.
- Run the `emacsclient --eval` command via the Bash tool.
