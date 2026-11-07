#!/usr/bin/env python3
"""Build docs/MercLab-Book.epub from docs/src (same content and order as mdBook).

Usage:  python3 docs/tools/make-epub.py [repo-root]     (needs pandoc on PATH)
Usually run via:  nix run .#epub   or   mcli epub
"""
import os, re, subprocess, sys, tempfile, datetime

root = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.getcwd())
docs = os.path.join(root, "docs")
src = os.path.join(docs, "src")
out = os.path.join(docs, "MercLab-Book.epub")
if not os.path.isfile(os.path.join(src, "SUMMARY.md")):
    sys.exit(f"Can't find docs/src/SUMMARY.md under {root} — run from the MercLab repo.")


def slug(path):  # docs/src-relative path -> chapter id
    return re.sub(r"[^a-z0-9]+", "-", path[:-3].lower()).strip("-")


def heading_id(text):  # same rules mdBook uses for #fragments
    t = re.sub(r"[`*_]", "", text.strip().lower())
    t = re.sub(r"[^a-z0-9 \-]", "", t)
    return re.sub(r"\s", "-", t)


# 1. Reading order from SUMMARY.md
order = []  # ("part", title) | ("chapter", path)
for line in open(os.path.join(src, "SUMMARY.md"), encoding="utf-8"):
    m = re.match(r"^# (.+)$", line)
    if m and m.group(1) != "Summary":
        order.append(("part", m.group(1).strip()))
        continue
    m = re.search(r"\]\(([^)]+\.md)\)", line)
    if m:
        order.append(("chapter", m.group(1)))


def convert(path, shift):
    here = os.path.dirname(path)
    cid = slug(path)
    lines, fence, first, seen = [], None, True, {}
    for line in open(os.path.join(src, path), encoding="utf-8").read().splitlines():
        f = re.match(r"^(\s*)(`{3,}|~{3,})", line)
        if f:
            if fence is None:
                fence = f.group(2)
            elif f.group(2).startswith(fence[0]) and len(f.group(2)) >= len(fence):
                fence = None
            lines.append(line)
            continue
        if fence is None:
            h = re.match(r"^(#{1,6}) (.+?)\s*$", line)
            if h:
                text = h.group(2)
                if first:
                    hid, first = cid, False
                else:
                    base = heading_id(text)
                    n = seen.get(base, 0)
                    seen[base] = n + 1
                    hid = f"{cid}--{base}" + (f"-{n}" if n else "")
                line = f"{'#' * min(6, len(h.group(1)) + shift)} {text} {{#{hid}}}"
            else:
                # internal links -> in-book anchors
                def fix(m):
                    target = m.group(2)
                    if re.match(r"^[a-z]+:", target) or ".md" not in target:
                        return m.group(0)
                    file, _, frag = target.partition("#")
                    t = slug(os.path.normpath(os.path.join(here, file)).replace(os.sep, "/") + "")
                    return f"{m.group(1)}(#{t + ('--' + frag if frag else '')})"
                line = re.sub(r"(\]\s?)\(([^)\s]+)\)", fix, line)
                if path == "reference/modules.md" and line.startswith("|"):
                    cells = line.strip().strip("|").split("|")
                    if len(cells) == 3:  # drop the File column: too wide for phones
                        line = "|" + "|".join(cells[:2]) + "|"
        lines.append(line)
    return "\n".join(lines) + "\n"


# 2. Assemble one Markdown document: parts = level 1, chapters = level 2
body = []
for kind, value in order:
    if kind == "part":
        body.append(f"\n# {value} {{#part-{slug(value + '.md')} .unnumbered}}\n")
    else:
        body.append(convert(value, 0 if value == "README.md" else 1))

meta = f"""---
title: The MercLab Book
subtitle: Owning, running and growing the Mercury NixOS configuration
author: mercury
lang: en-US
date: {datetime.date.today().isoformat()}
---
"""

with tempfile.NamedTemporaryFile("w", suffix=".md", delete=False, encoding="utf-8") as tmp:
    tmp.write(meta + "\n".join(body))
    combined = tmp.name

cmd = [
    "pandoc", combined, "-o", out,
    "--from", "markdown+pipe_tables+task_lists+fenced_code_blocks+backtick_code_blocks-implicit_figures",
    "--to", "epub3",
    "--toc", "--toc-depth=2", "--split-level=2",
    "--css", os.path.join(docs, "tools", "epub.css"),
    "--highlight-style", "tango",
]
cover = os.path.join(docs, "cover.png")
if os.path.isfile(cover):
    cmd += ["--epub-cover-image", cover]
subprocess.run(cmd, check=True)
os.unlink(combined)
print(f"Wrote {out}")
