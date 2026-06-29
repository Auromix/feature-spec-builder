# Changelog

All notable changes to this project are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-06-29

First public release.

### Added
- **Core skill** (`SKILL.md`): two-layer interactive clarification (positioning → behavioral
  detail), one-question-at-a-time with candidate answers, never deciding trade-offs for the user,
  a Definition-of-Ready output template, and decision traceability.
- **Requirement splitting** step — detect when one fragment hides multiple latent features and let
  the user decide which to spec this round.
- **Cross-layer routing** (`references/cross-layer-routing.md`): a 4-layer implementation model
  (SDK / firmware·middleware / algorithm / hardware) orthogonal to the capability tiers, feasibility
  falsification with a "not deliverable by the SDK layer alone" flag, conclusion write-back to
  prevent *false readiness*, cross-team to-confirm triplets, layer handoff contracts, and a
  *master spec + per-layer sub-spec* output form.
- **Product-principles gate** (`references/product-principles.md`): 10 built-in default principles
  for platform/SDK products, a pre-output self-check gate, a red-flag list, and an NFR dimension
  checklist. Configurable per team.
- **Second-layer probe library** (`references/detail-probes.md`): archetype-specific probes (A–G),
  including archetype G for exposing existing low-level capability.
- **Configuration block** with groups A–E, including an implementation-layer × department map.
- **Interface naming rule** enforced via the product principles and interface-contract section:
  snake_case, full words, no abbreviations.
- End-to-end single-layer worked example (`references/example.md`) and a cross-layer worked
  example embedded in `cross-layer-routing.md`.
- Packaging script (`scripts/build-skill.sh`) and CI workflow.

[1.0.0]: https://github.com/auromix/feature-spec-builder/releases/tag/v1.0.0
