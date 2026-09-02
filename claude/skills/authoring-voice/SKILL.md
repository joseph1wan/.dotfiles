---
name: authoring-voice
description: Use when drafting or rewriting a proposal, RFC, HLD, design doc, or formal written request that will go out under Joseph's name — matches his register instead of the default AI-memo register.
---

# Authoring in Joseph's voice

Scope: **formal written proposals and requests.** Proposal docs, RFCs, HLDs,
design docs, and posts like the Slack briefing in `corpus/001` — which is a
formal request even though the surface is chat. One register, not three; do not
pre-split by surface.

Out of scope: informal conversation, commit messages, code comments, PR bodies.

## How to use this

1. Read `corpus/001-sdd-team-briefing.md` before drafting. It is a
   rejected-draft / accepted-version pair on identical content, so the delta is
   register in isolation. Sections A and B are the evidence; C is the summary.
2. Draft.
3. Run the checks at the bottom. They are failure modes observed in A, not
   generic writing advice.

**Every rule below cites the sample.** If a rule can't point at corpus
evidence, it doesn't belong here — that's what went wrong with the pasted
style guide this replaced, which encoded another model's inferences about a
corpus neither of us had read.

## Rules with evidence

**Locate the idea before explaining it.** Open with where this sits — what
other teams are doing, what the org is or isn't ready for, what the team has
already raised. The problem statement comes after. (B ¶1 spends five sentences
on Autodesk-wide context before "Here is my proposal:". A opens on a reframe of
the problem and never establishes external context at all.)

**Name the claim, then define it.** State the thesis as its own short line, then
give a labelled paragraph per component. Don't withhold it and build toward it.
(B: "Spec-driven development with intense focus on trust" standing alone,
followed by `Spec driven:` and `Intense focus on trust:`.)

**Credit whoever raised the problem.** (B: "The problem (that many of you have
raised)". A informs the reader instead.)

**Own past decisions, then revise them.** Give the original reasoning honestly
before saying why it no longer holds. Don't argue that it was wrong. (B: "We
made that decision because doc drift was a real problem, but the cons of saying
'forget doc maintenance' are now outweighing the pros.")

**Minimize distance from the target.** Say how close we already are and name
what's already happening. The reader should finish thinking this is reachable.
(B: "we're not that far from this", "We're already doing this with our
proposal-HLD-LLD work", "which again, we're already doing". A: "we aren't
getting the speed", framed as a gap.)

**Short declaratives for a causal chain.** One clause each, no subordination,
let them accumulate. (B: "The code review is the bottleneck. It's also the pain
point for humans. So what usually happens is we just accept the PRs. That will
cause problems down the line." A compresses the same chain into one sentence
with a "because" in it.)

**Don't front-load the strongest line.** The sharpest sentence can sit in the
middle of a paragraph, reached by the chain above. (B places the PR-acceptance
admission mid-paragraph; A puts its strongest claim first.)

**Keep the hedges that carry real confidence.** "essentially", "should address
this", "the main issue I see", "we're not there yet as an org" are calibration,
not weakness. Removing them overstates certainty. (B throughout; A strips them
for force.)

**Leave unfinished thinking visibly unfinished.** "etc", "some processes" mark
a thing not yet worked out. Flatten them and you misrepresent the state of the
idea. Flag the vagueness separately if it's a problem; don't resolve it in the
prose. (B: "tests against internal knowlege docs, code readability, etc".)

**End by lowering the stakes.** Ask for thought, point at the artifact, promise
the real document. Not an instruction. (B: "I'd like everyone to think about
this... I'll have a real RFC out soon, but wanted to get this conversation
started." A: "Read the proposal and push back on the trust section
specifically.")

**Bullets only inside a section, only when items are independent.** Prefer
labelled plain paragraphs for structure. (B has one three-item list, inside
`Intense focus on trust:`. A uses four parallel bolded blocks as the spine.)

**No em dashes.** (B: zero. A: five.)

## Checks before returning

- Does it open on position, or on the problem? Should be position.
- Is the thesis stated plainly and early, or withheld for effect?
- Is the team's contribution credited anywhere?
- Would the reader finish this thinking we're close, or far?
- Any sentence carrying three clauses that should be three sentences?
- Did I delete a hedge to make a claim land harder? Put it back.
- Did I resolve a vagueness the author left deliberately open?
- Does it end with an ask that lowers stakes, or an order?
- Em dash count: 0.
- Is any structure there because it looks organized rather than because the
  content has parts?

## Known gaps

Read these as limits on the rules above, not caveats to ignore.

- **One sample, one subject.** Everything here derives from a briefing about
  process change. Rules may encode "how Joseph writes about workflow" rather
  than how he writes. A sample about a system rather than a process is the
  highest-value next addition.
- **Document-level rules are unproven.** Section ordering, where the ask goes,
  and length calibration for an RFC versus a proposal versus a post are not
  evidenced. Don't invent them here.
- **Cost.** Joseph's version omits cost entirely; when Claude adds it, he keeps
  it. So the omission looks like register discipline for short-form, not
  disagreement. Unresolved for long-form — in a full RFC, include it.

## Maintenance

Corpus is the source of truth; this file is derived. When they conflict, the
corpus wins.

Add samples as `corpus/NNN-<slug>.md`. Rejection pairs — Claude's draft next to
the published version — are worth more than standalone samples, because they
isolate preference from content. Capture at the moment of correction, not
completion: two sentences on what was changed and why beats a whole extra
document.

Re-derive and **prune** every three or four new samples. Rules must keep citing
evidence or come out. If the instruction body outgrows roughly a page, it has
started failing the way the guide it replaced failed.
