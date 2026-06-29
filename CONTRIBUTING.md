# Contributing to feature-spec-builder

Thanks for your interest! This project is a **Claude skill** — a methodology expressed as instructions an agent reads (`SKILL.md` + reference files), not a conventional codebase. That shapes what "a good contribution" looks like.

## Most valuable contributions

1. **A real case the skill mishandled.** You ran the skill on an actual one-line request and it missed a gap, mis-classified the layer, skipped a cross-team dependency, or produced a spec that engineering rejected. Open an issue with:
   - the raw request you gave it,
   - what it produced,
   - what it *should* have asked or produced.
2. **A fix to the relevant dimension / probe / section.** The skill improves by adding or sharpening: a first-layer positioning dimension, a second-layer probe (`references/detail-probes.md`), a product principle (`references/product-principles.md`), or cross-layer logic (`references/cross-layer-routing.md`).

## Design invariants — please preserve these

The skill's value comes from a few non-negotiable behaviors. PRs that break them will be asked to change:

- **Two-layer clarification**: positioning (coarse) before behavioral detail (fine).
- **One question at a time**, each with *why it's asked* + candidate answers.
- **Never decide trade-offs for the user** — unresolved items are marked `[待确認]`, not silently filled.
- **Output stops at the feature spec** — no task breakdown / implementation plan.
- **No hard section numbers** inside the doc — reference sections by name (so inserting a section never desyncs cross-references).
- **Workflow step numbering stays self-consistent** (currently 1–7).

## Making a change

1. Edit files under `skill/feature-spec-builder/`.
2. Keep `SKILL.md` lean — push heavy methodology into `references/` for progressive disclosure.
3. Sanity-check the package builds:
   ```bash
   ./scripts/build-skill.sh
   ```
4. If you changed the workflow steps or section names, grep for stale references:
   ```bash
   grep -rnE "第 ?[0-9]+ ?(步|节)" skill/   # step refs should be 1–7; there should be no hard 第N节
   ```
5. Open a PR describing the gap your change closes.

## Style

- The skill content is written in **中文**; keep new content in the same language and register.
- Match the surrounding tone: direct, imperative, with concrete "why".

## License

By contributing, you agree your contributions are licensed under the [Apache License 2.0](LICENSE).
