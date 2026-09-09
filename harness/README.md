# Harness

The **harness** is everything around the model that lets it do stable work here: the repository layout, the instruction files, the feature contract, the test and validation loop, and the record of what has already happened. The code is the deliverable; the harness is what makes the next session able to continue it without re-deriving the last one.

The term was named in February 2026 and both labs published on it:

| Source | What this repository takes from it |
|---|---|
| [Anthropic — Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) | The `feature_list.json` convention (category, description, verification steps, boolean `passes`), a progress log read at session start, an init script, and the rule that a feature is only marked complete after it has actually been tested. |
| [Anthropic — Harness design for long-running application development](https://www.anthropic.com/engineering/harness-design-long-running-apps) | Agents communicate through **files**, not conversation: one writes, the next reads and answers in that file or a new one. Work is negotiated as a contract with testable acceptance criteria before implementation starts. |
| [OpenAI — Harness engineering: leveraging Codex in an agent-first world](https://openai.com/index/harness-engineering/) | The repository is structured for **agent legibility**, not only correctness. The development loop — testing, validation, review, recovery — is encoded in the repo itself, and drift is swept periodically rather than allowed to accumulate. |
| [Martin Fowler — Harness engineering for coding agents](https://martinfowler.com/articles/harness-engineering.html) | The split between *feedforward guides* (AGENTS.md, architecture.md — what to do before acting) and *feedback sensors* (type checker, linter, tests — what tells you it went wrong). |

> Retrieved 2026-09-08. The OpenAI post could not be fetched directly from this environment (HTTP 403); its content here is drawn from the published summaries listed above and from the Fowler article, which covers the same ground. Treat the OpenAI row as second-hand until someone opens the original.

## The files

| File | Role | Article it comes from |
|---|---|---|
| [feature-list.json](feature-list.json) | Machine-readable feature contract. Every entry carries verification steps and a `passes` boolean. | Anthropic, long-running agents |
| [features.md](features.md) | The same contract for humans, plus what is deliberately *not* built yet. | — |
| [tests.md](tests.md) | What is tested, how to run it, and what the suite provably cannot catch. | OpenAI / Fowler (feedback sensors) |
| [architecture.md](architecture.md) | Module boundaries and the invariants an agent must not break. | Fowler (feedforward guide) |
| [progress.md](progress.md) | Append-only session log. Read this first. | Anthropic, long-running agents |
| [init.sh](init.sh) | Bootstrap: check out the code, install, validate, run. | Anthropic, long-running agents |
| [../planning/changelog.md](../planning/changelog.md) | What changed and why, in prose, newest first. | — |
| [../AGENTS.md](../AGENTS.md) | Project instructions. The root feedforward guide. | Fowler / OpenAI |

## The loop

```
read  progress.md + feature-list.json     ← where things stand
  ↓
plan  a design note under experiments/    ← contract before code
  ↓
build in the fork                         ← code is not vendored here
  ↓
sense bun run validate                    ← type-check, lint, format, tests
  ↓
verify against the real dataset           ← measured, not assumed
  ↓
record passes:true, progress.md, changelog.md
```

**A feature is not done because it was written.** `passes` may only be set true by an agent that ran the listed verification. `passes: false` in this repo means "not verified by that method yet", not "broken" — the `note` field says which.

## Feedback sensors available here

| Sensor | Command | Catches |
|---|---|---|
| Type checker | `bun run type-check` | Contract drift between modules |
| Linter | `bun run lint` | Unused code, React hook mistakes |
| Formatter | `bun run format:check` | Diff noise |
| Unit tests | `bun test` | Pure-logic regressions |
| Data check | scripts over `data/raw/` | Claims about the dataset that are actually false |

## Known gap: no browser sensor

The most valuable verification for this project runs in a browser, and the last implementation round found five defects that unit tests could not — a map stealing a global keyboard shortcut, a fit being silently undone, a documented kill switch that was never called. There is currently **no automated browser sensor wired into this repository**. Browser checks are manual, which is why several entries in the feature list sit at `passes: false` with a note rather than being asserted.

Closing that gap — a Playwright MCP server, or a Playwright suite in the fork — is the single highest-value addition to this harness. Tracked in [../planning/todo.md](../planning/todo.md).
