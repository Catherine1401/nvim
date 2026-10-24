In Neovim configuration files, literals may be used directly; the user-level rule requiring every literal to be named does not apply.
Leader keymaps must use at most two keypresses after the leader: one group key and one action key, with no nested subgroups or conflicting mappings.

## Repo workflow

Run `nvim --headless -l scripts/check.lua` after every change to `lua/`, `docs/keymaps.md`, or `scripts/`; it must exit 0. Also run `nvim --headless +qa` and confirm there is no output. Check UI behavior in tmux, not headless.

Change checklist (files that change together, in one commit):
- New plugin: one file `lua/plugins/<repo name in snake_case>.lua`, indented with tabs.
- New or changed key: update `docs/keymaps.md` (English, tracked). A new leader group also needs `{ "<leader>x", group = "..." }` in `lua/plugins/which_key.lua`.
- Removed plugin: delete its file, and remove its group from `which_key.lua` and its section from `docs/keymaps.md`. Do not commit `lazy-lock.json` (gitignored).
- New module in `lua/config/`: `local M = {}` with `M.setup()`, called from the plugin's `config`/`init`. List it in the Structure block of `docs/structure.md`.
- Changed tool requirement: keep `lua/config/health.lua` and `install.sh` in sync (`MIN_TREE_SITTER` is defined in both).

Conventions:
- Match each file's existing indentation (tabs in most files; `neoscroll.lua`, `autocmds.lua`, `lazy.lua` use 2 spaces). Never reformat a whole file or run a formatter over the repo.
- Code comments: Vietnamese, one line. Tracked docs, README and installer messages: English. `.docs/` is local, untracked, Vietnamese; `.ignore` is local and only exists so ripgrep pickers see `.docs/`; do not commit either.
- Each file at most 1000 lines, each function at most 100 lines. `scripts/check.lua` enforces both; do not add entries to its `KNOWN` table.

Git:
- Commit straight to `main`, one commit per independent task, message `type(scope): imperative object` on one line, no ticket, no co-author trailer.
- List the exact hunks and the message, then wait for explicit approval before committing.
