# Git

The repo is your backup, your history and your undo button.

## The everyday loop

```bash
cd ~/MercLab
git status                 # what changed
git diff                   # exactly how
git add -A                 # stage everything (needed for NEW files before building)
git commit -m "laptop: enable printing"
git push
```

On another machine: `git pull`, then `mcli switch`.

## Commit messages

Start with the area: `desktop: …`, `laptop: …`, `hypr: …`, `nvim: …`,
`docs: …`, `flake: update inputs`. Future-you searches history with
`git log --oneline --grep laptop`.

## Undo

| Situation | Command |
|-----------|---------|
| throw away uncommitted edits to a file | `git restore path/to/file` |
| unstage a file | `git restore --staged path` |
| undo the last commit, keep changes | `git reset --soft HEAD~1` |
| undo a pushed commit safely | `git revert <hash>` |
| see an old version of a file | `git show <hash>:path/to/file` |
| find when something broke | `git bisect start; git bisect bad; git bisect good <hash>` |

## Branches for experiments

```bash
git switch -c try-niri      # new branch
# … edit, mcli test …
git switch main             # back; the experiment stays on its branch
git branch -D try-niri      # or delete it
```

`mcli test` activates a build without adding it to the boot menu — a reboot
returns you to the last `switch`.

## Tags for known-good states

```bash
git tag -a good-2026-11 -m "all machines working"
git push --tags
```

If an update goes badly, `git checkout good-2026-11 -- flake.lock` restores the
exact package versions from that point.
