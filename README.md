# emacs-skills

Claude Code skills for Emacs integration.

## Skills

### /dired

Open files from the latest agent interaction in an Emacs dired buffer via `emacsclient`.

- **Same directory**: Opens dired at the parent directory with the relevant files marked, showing them in context alongside sibling files.
- **Multiple directories**: Creates a curated `*agent-files*` dired buffer containing only the relevant files, using relative paths from a common ancestor.

#### Requirements

- Emacs running a server (`M-x server-start` or `(server-start)` in your init file)
- `emacsclient` available on `$PATH`

#### Usage

After an interaction that generates or references files:

```
/dired
```

## Installation

Add this repository as a Claude Code plugin:

```sh
claude plugin add --url https://github.com/xenodium/emacs-skills
```

Or copy individual skill directories into your project's `.claude/skills/` or `~/.claude/skills/`.

## Uninstall

```sh
claude plugin remove --url https://github.com/xenodium/emacs-skills
```

Or remove the skill directories from `.claude/skills/` or `~/.claude/skills/`.
