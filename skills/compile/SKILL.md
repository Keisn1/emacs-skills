---
name: compile
description: 'This skill should be used when the user invokes "/compile" to run a command in an Emacs compilation buffer via emacsclient instead of in the terminal.'
tools: Bash
disable-model-invocation: true
---

# Run command in Emacs compilation buffer

Instead of running a command in the terminal, run it in an Emacs `*compilation*` buffer using `emacsclient --eval`. The compilation buffer makes errors and warnings clickable, allowing easy navigation to source locations.

Use whatever command is relevant from the current context. If the user provides a specific command (e.g., `/compile npm test`), use that command.

## How to run

First, locate `agent-skill-compile.el` which lives alongside this skill file at `skills/compile/agent-skill-compile.el` in the emacs-skills plugin directory.

```sh
emacsclient --eval '
(progn
  (load "/path/to/skills/compile/agent-skill-compile.el" nil t)
  (agent-skill-compile
    :dir "/path/to/project"
    :command "make"))'
```

## Rules

- Set `:dir` to the project root.
- If no command is apparent from context and the user didn't specify one, ask the user what to run.
- Locate `agent-skill-compile.el` relative to this skill file's directory.
- Run the `emacsclient --eval` command via the Bash tool.
