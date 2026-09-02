# Sample 001 — SDD team briefing (Slack, formal request)

**Date:** 2026-08-28
**Surface:** Slack post to the CP team
**Register:** formal request / proposal
**Subject:** process change (AI SDLC adoption)
**Type:** rejection pair — Claude draft vs. Joseph's version

Both versions had the same brief, the same evidence, and the same set of
decisions behind them. The delta is register, not content. Rules in
`../SKILL.md` cite line-level evidence from Section B and, where the
contrast matters, from Section A.

---

## A. Claude's draft (rejected)

> ## Why I want us to move to spec-driven delivery
>
> We keep treating doc drift, late design review, and slow delivery as three problems. They're one: we have agents that write, test, and review code faster than we can supervise them, and a process built for humans typing. Docs drift because keeping them current was never on the critical path. Designs get reviewed after the code ships because the review gate was never wired to the merge gate. And speed doesn't improve, because every acceleration downstream pushes work into the stage that didn't get faster — a person reading a diff.
>
> So this isn't "adopt OpenSpec." It's four changes.
>
> **Monorepo.** An agent can only reason about what it can see. Split repos mean every cross-cutting change starts with a guess about the other half. cp-ingestion-core joining is a prerequisite, not a follow-up — there's refactoring first, so phase 2, but APS can't adopt this until it lands.
>
> **Front-load the design.** An agent implements a bad design faithfully and fast, so a vague instruction produces a large, confident, wrong diff. Writing the requirement down first is the input the agent needs, not ceremony.
>
> **Tie the spec to the code.** Each behavioural requirement carries an id and names the test that proves it; CI checks both directions. Drift becomes a failing build in the PR that caused it, not a stale page someone notices in six months.
>
> **Trust in the AI's output.** The one I care most about and am least sure of. The reviewable unit becomes the requirement delta — what changed, and what proves it — not the diff. Agents can block; they can't approve, because an opinion isn't proof. Agent code holds the same readability bar as ours: you shouldn't have to read it to trust it, and you must always be able to.
>
> The real test isn't shipping a small feature faster. It's whether we can take on the content ingestion migration — broad, touching code nobody has read in months — and know the result is right.
>
> Cost: specs for capabilities that lack them, roughly 14.5 engineer-days of test coverage for `merge` alone (may be worse for `storage`), and deleting documentation we were never actually maintaining.
>
> Read the proposal and push back on the trust section specifically.

---

## B. Joseph's version (the target)

> I have a proposal for what I'm calling our "AI SDLC". I've been looking around Autodesk and there are many teams that are working on the same thing. There are individuals who are able to get incredible throughput because they have a system that works for them. Now they're trying to figure out how to extend their system to work for their teams. There's also talk of extending those systems to work across GET. We're not there yet as an org, so we need to figure out what makes sense for our team. Here is my proposal:
>
> Spec-driven development with intense focus on trust
>
> Spec driven: Front load the work into good architecture design. We're already doing this with our proposal-HLD-LLD work. The problem (that many of you have raised) is that, once we implement, the design is stale and we don't benefit from the design and decisions because docs are in Confluence. We made that decision because doc drift was a real problem, but the cons of saying "forget doc maintenance" are now outweighing the pros. Using the OpenSpec framework and a clear process should address this
>
> Intense focus on trust: The main issue I see with agentic workflows is the code review. The code review is the bottleneck. It's also the pain point for humans. So what usually happens is we just accept the PRs. That will cause problems down the line. We need to build a system that give us high trust, high readability, low friction for PR acceptance. This includes:
> - Spec driven, so decisions are clear and review means making sure the code did what we intended
> - Lots of good tests. Lots of attention paid to integration tests, which should mirror the specs. In fact, specs need to be verified by passing tests
> - More tests. Not just unit/integration, but tests against internal knowlege docs, code readability, etc
>
> The good news is that we're not that far from this. We're already doing spec-driven development, essentially. Now it's just putting the specs in the code and adding some processes enforced by CI and Beacode, which again, we're already doing. And we are about to cut over to the monorepo which is what will enable all of this.
>
> I'd like everyone to think about this and look at this diagram I created as a proposal for how this might work. I'll have a real RFC out soon, but wanted to get this conversation started.

---

## C. What the delta shows

| Dimension | Claude's draft | Joseph's version |
|---|---|---|
| Opening | the problem, stated as a reframe | where the idea sits in the org; what other teams are doing |
| Central claim | withheld; built to across four bullets | named in a standalone line, then defined |
| Relationship to team | reader is informed | reader is credited ("that many of you have raised") |
| Past decisions | argued against | owned, then revised |
| Distance from target | large ("we aren't getting the speed") | small ("we're not that far from this", "we're already doing X") |
| Cost | itemized with numbers | absent |
| Ending | an instruction | lowered stakes + a real RFC promised |
| Hedges | removed for force | kept: "essentially", "should address this", "the main issue I see" |
| Em dashes | 5 | 0 |

Two structural notes:

1. Claude's draft used **hierarchy of emphasis** (bolded lead-ins, four parallel
   blocks). Joseph's uses **plain labelled paragraphs** — `Spec driven:` and
   `Intense focus on trust:` — with a bullet list only inside the second, where
   the items are genuinely independent.
2. Claude front-loaded the strongest sentence. Joseph put his — "So what
   usually happens is we just accept the PRs" — in the middle of the second
   paragraph, reached by a chain of four short declaratives.
