# Markdown (keeping this book alive)

The book is plain Markdown in `docs/src/`, built with mdBook. Update it in the
same commit as the change it describes — that's the habit that keeps a solo
project understandable a year later.

## Syntax you need

````markdown
# Page title
## Section

Plain paragraph. **bold**, *italic*, `inline code`, [link](../daily/mcli.md).

- bullet
- bullet

1. numbered

| Column | Column |
|--------|--------|
| cell   | cell   |

```nix
code block with highlighting
```

> A note.
````

## Adding a page

1. Create `docs/src/<section>/<page>.md`.
2. Add it to `docs/src/SUMMARY.md` — pages not listed there aren't built.
3. Preview: `mcli book` (live-reloads as you save).
4. Rebuild the phone copy: `mcli epub` → `docs/MercLab-Book.epub`. Commit it, and
   you can always download the latest from GitHub on your phone.

## What to write down

- Why you made a non-obvious choice (the *why* is what you forget).
- Any manual step a machine needed (BIOS settings, bus IDs, a one-time command).
- Fixes for errors you hit — add them to [Troubleshooting](../maintain/troubleshooting.md).
