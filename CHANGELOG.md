# Changelog

All notable changes to this project are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-06-29

### Added
- **Archetype H — Ecosystem integration / reference implementation / developer docs** in
  `references/detail-probes.md` (e.g. SDK↔ROS/ROS2 bridge examples, third-party framework adapters,
  Docker samples, language bindings, quickstart repos, docs-site sections). 5 probes centered on
  *support level, version matrix + EOL, deliverable form, example anti-rot, and our-maintenance vs
  customer-owned boundary* — because for this class the low level already supports it; the real risk
  is the support boundary and keeping examples from rotting.
- **Two non-runtime implementation layers** in the config-zone layer map and step-4 routing:
  *docs / developer-portal layer* (DevRel/docs/site owner) and *build / distribution-infra layer*
  (SDK-build/DevOps owner) — so example/packaging/docs deliverables aren't mis-assigned to
  firmware/algorithm/hardware.
- **External-dependency axis** in `references/cross-layer-routing.md`: for needs that depend on an
  external framework/OS/runtime (ROS distro, DDS, Ubuntu, CPython…), whose EOL clock no internal
  team owns — with an "external-dependency to-confirm" (conservative-assumption) discipline.
- **New NFR must-answer "support level & maintenance commitment"** and a principle-4 extension
  (example code / message schema / docs anchors also become de-facto contracts that can break
  downstream) in `references/product-principles.md`.
- Requirement-splitting heuristics: *heterogeneous-deliverable* smell and the *shared-source
  related-feature cluster* pattern.
- Worked example `references/example-ros-integration.md` demonstrating archetype H end-to-end.

## [1.1.0] - 2026-06-29

### Changed
- **Output form: one feature = one Markdown file, divided by reading audience.** Replaced the
  earlier "master doc + per-layer sub-spec files" form. A feature — even a cross-layer one — is
  now produced as a **single `.md`**; cross-layer / cross-department content is organized into
  per-audience sections (product/review, SDK, firmware, algorithm, hardware) under a top-of-doc
  **Reader Guide**, so the whole requirement stays trackable in one document. Multiple *features*
  are still split into separate files (never mixed); this change is about not fragmenting a
  *single* feature across files.
- Updated `SKILL.md` (step 4 output form, template conventions, cross-layer section note, added a
  Reader-Guide element) and `references/cross-layer-routing.md` §9 (per-audience section template
  + Reader-Guide template, replacing the sub-spec-file template).

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

[1.2.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.2.0
[1.1.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.1.0
[1.0.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.0.0
