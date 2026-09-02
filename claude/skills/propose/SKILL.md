---
name: propose
description: Use when the user asks you to confirm an approach before coding, says "before writing code confirm", "what's your plan", "check with me first", or when a task has 2+ real forks that change the work. Lightweight alternative to brainstorming/grill-me — one round of decision questions, one short written approach, then stop.
---

# Propose

One round of questions. One short approach. Stop for approval. That's it.

Not a planning doc. Not an interview. If it needs more than one round, the task is too big for this skill — use `superpowers:brainstorming`.

## Steps

1. **Probe cheaply first.** Read the target file(s), grep for related code, run one read-only command to verify a key assumption (does the path exist, does the endpoint respond, what's the file count). Facts beat guesses and shrink the question set.

2. **Ask only forking decisions.** Use `AskUserQuestion`, max 3 questions, one round. A question qualifies only if different answers produce materially different code. Mark your pick `(Recommended)` and put it first. Skip anything you can settle from the repo, convention, or the probe.

3. **Write the approach.** Short. Numbered steps of what you'll actually do — files touched, functions added, commands run. Include concrete values from the probe (real paths, real counts). Then:
   - **Open Qs** — unverified assumptions, stated as assumptions, with an offer to verify.
   - Docs/tests you'll update, one line.

4. **Stop.** Do not write code. Wait for approval. If the user answers only some Open Qs, take the stated assumption on the rest and proceed.

## Rules

- Probe before asking — an answered question is cheaper than an asked one.
- No option surveys in prose. Forks go in `AskUserQuestion`; the write-up states one plan.
- Name real files and commands, not "the relevant module."
- Flag unverified assumptions explicitly. Don't smuggle guesses into the plan as facts.
- If the answers make the task trivial, say so and just do it — don't ceremony a one-liner.
