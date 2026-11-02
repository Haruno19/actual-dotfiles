# dotfiles

<img width="1512" height="982" alt="Screenshot 2026-11-01 at 22 07 38" src="https://github.com/user-attachments/assets/364551a8-a102-417e-ab6b-85c23a6bcf6a" />


macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
The repo lives at `~/dotfiles` and its contents are symlinked into `~` via `stow .`.

---

## Clean restore on a new Mac

### 1. Install the prerequisites

Stow only creates the symlinks — it does **not** install any of the programs the
configs depend on. Install these first, otherwise the shell will throw errors on
every launch and `stow .` won't be available at all.

**Required for the restore itself:**

- [Homebrew](https://brew.sh) — package manager, also provides `brew shellenv` used in `.zprofile`
- `stow` — `brew install stow`
- `git` — to clone this repo (preinstalled with Xcode Command Line Tools)

**Referenced by `.zshrc` / `.zprofile` (shell errors until installed):**

- `coreutils` — provides `gls` / `gdircolors` (the `ls` alias and `LS_COLORS` setup)
- `zoxide` — the `cd` alias and `eval "$(zoxide init zsh)"`
- `fzf` — `eval "$(fzf --zsh)"`
- `pyenv` — Python version manager (`PYENV_ROOT`, `pyenv init`)
- `gh` — GitHub CLI (config tracked, but auth is not — see step 5)
- `dotnet@9` — `DOTNET_ROOT` is derived from `brew --prefix dotnet@9`
- `gcc` / `g++` 13 — the `gncc` / `gn++` aliases (`gcc-13`, `g++-13`)
- Docker Desktop — completions sourced at the end of `.zshrc`

**Apps with configs tracked under `.config/` (install if you use them):**

bottom · fastfetch · ghostty · htop · zed · mole

### 2. Clone the repo (with submodules)

The zsh plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`,
`zsh-shift-select`) are git submodules sourced directly by `.zshrc`. A plain
clone leaves them as empty dirs and the shell errors out.

```bash
git clone --recurse-submodules <repo-url> ~/dotfiles
```

Already cloned without them?

```bash
cd ~/dotfiles && git submodule update --init --recursive
```

### 3. Clear conflicting files from `~`

Stow refuses to overwrite a real file where it wants to place a symlink, and a
fresh macOS install ships some of these by default. Check `~` for the following
**before** stowing and remove/back up any that exist as real files (not already
symlinks into this repo):

- `~/.zprofile`
- `~/.zshrc`
- `~/.bash_profile`
- `~/.gitconfig`
- `~/.zprofile` / login-shell defaults created by Terminal/iTerm on first launch
- Any `~/.config/<app>/` that an app created before you stowed (e.g. `gh`, `git`, `zed`)
- `~/Library/Application Support/Code/User/settings.json` — VS Code creates it on
  first launch

Quick check for what's a real file vs. already a symlink:

```bash
ls -la ~ | grep -vE '\->'   # lines without -> are real files/dirs
```

### 4. Stow

```bash
cd ~/dotfiles && stow .
```

If stow reports conflicts, resolve them as in step 3 and re-run. `stow -n .`
does a dry run that prints what *would* happen without touching anything.

### 5. Post-stow manual steps

- **`gh` auth:** the OAuth token lives in the macOS Keychain, not in the tracked
  config. Run `gh auth login` to re-authenticate.
- **SSH:** `~/.ssh/config` is not tracked (it holds server addresses). Recreate
  it by hand. Ensure perms: `chmod 700 ~/.ssh` and `chmod 600 ~/.ssh/*`.
- **Restart the shell** (or `exec zsh`) to pick everything up.

---

## Layout notes

- `.stowrc` — ignores history files, caches, backups, and `.zcompdump*` during stow,
  plus `.ssh/` and `scripts/` (the latter is on `PATH` via `.zshrc` instead).
- `.gitignore` — tracks configs only; excludes secrets (SSH keys, `known_hosts`),
  caches, and runtime data.
- `.gitmodules` — the three zsh plugins under `.zsh/plugins/`.
- `Library/Application Support/Code/User/settings.json` — VS Code user settings;
  stow links just this file into `~/Library`. Before committing, check its diff:
  VS Code writes machine-specific entries into it (e.g. `remote.SSH.remotePlatform`
  host IPs).
