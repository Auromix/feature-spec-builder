# Changelog

All notable changes to this project are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.8.0] - 2026-07-01

### Added
- **Company-level collaboration via a local, private org/process config.** Each company's
  people/roles/process/version-cadence differ and are private, so they are NOT baked into the skill.
  New `references/org-process-config.md` ships a **de-sensitized template + mechanism** (no real names),
  and `scripts/init-org-config.sh` scaffolds a local, **gitignored** `org-process.local.md` the user
  fills in. When present, the skill uses it to route owners to real people, list the delivery gates &
  artifacts a feature must pass (requirement-lock / design review / self-test = test-entry / acceptance
  / release review), tie the feature to a target version and pipeline capacity (person-days), and flag
  post-lock changes as needing CCB. Config-zone group **F** + an 影响评估 "版本与流程协同" line reference it.
- Distilled the de-sensitized *patterns* of a real company release process (5-stage delivery, role map,
  gates, version cadence & pipeline capacity, CCB change control, N-version maintenance) into the template
  so the skill fits company-level requirement planning — without storing any company's private data.

### Security
- `.gitignore` now excludes `org-process.local.md` / `*.local.md`; real names & internal process live
  only in the local config, never in the skill or repo.

## [1.7.0] - 2026-07-01

Consolidation / maturity pass after A~J organic growth (audited via a 5-lens workflow + adversarial critic). No new capability — consistency, readability, and self-consistency of the skill's own examples.

### Added
- **Prototype quick-select index** at the top of `detail-probes.md`: a one-line-per-archetype table
  (trigger signal, deliverable form, whether it drills into firmware/algorithm/hardware) so the right
  archetype (A~J) can be picked at a glance. Pure navigation; fields stay authoritative in each section.

### Changed
- **Modernized the 3 older worked examples** (`example.md` 迎宾导览, `example-ros-integration.md`,
  `example-offline-install.md`) to the current writing rules — added a Reader Guide (with a Testing/QA
  row), a Glossary, and a Testing/QA section — so the skill's own "good output" samples follow the
  rules the skill now mandates. Clarification chains and contracts were left intact (additive only).
- Added a Testing/QA row to the cross-layer Reader-Guide template.

### Fixed
- Terminology unified: `构建/分发基建层`, `文档门户层`, `算法服务层`/`硬件层` used consistently.
- `example-offline-install.md`: repaired two Markdown tables missing separator rows, and a stale
  in-doc anchor (`【构建/分发层】` → `【构建/分发基建层】`).
- Cross-references now use section names (e.g. cross-layer 《八》节) instead of positional "末尾".

## [1.6.0] - 2026-07-01

### Added
- **Archetype J — Hardware end-effector / physical-interface spec & modification resources.** For
  features whose deliverable is *hardware-interface documentation* a customer uses to bolt a custom
  end-effector onto the robot — where the **external contract is a physical interface** (mechanical:
  mounting flange / bolt pattern / tolerances / payload / torque; electrical: connector part number /
  pinout / power envelope / protocol), **not a software API**. 6 probes (physical-contract matrix;
  model × hardware-revision lock; drawing↔as-built consistency; **physical safety red lines**
  payload/torque/power + no-touch zones + liability/authorization; deliverable precision STEP/DXF/PDF
  + self-check; copyable reference end-effector). Reuses H's skeleton (support level, version matrix,
  anti-rot, copyability) with physical content.
- **"Interface contract" generalized** in SKILL.md: contracts are either *software* (signature/params/
  errors) or *physical* (mechanical/electrical) — physical-interface features use J's physical fields,
  not software fields.
- **Safety dimension generalized** from "dangerous API call" to also cover **"dangerous physical
  modification"** (dimension 13 + principle 6): payload/torque/power red lines, no-touch zones,
  re-calibration after end-effector change, authorization / warranty / liability / disclaimer.
- Worked example `references/example-hardware-mod.md`.

## [1.5.1] - 2026-07-01

### Added
- **Testing / QA as a first-class role** in the Reader Guide (roles are chosen per feature type;
  Testing/QA is always included — it cares about acceptance criteria, the platform matrix to cover,
  and whether the external contract is testable). Guidance to organize the body into by-role chapters.
- **"Plain but rigorous" rule**: prose stays plain, but anything that is an *external output standard*
  (interface definitions, message/data formats, the full platform matrix, deliverable form, acceptance
  criteria) must be precise, unambiguous, and testable — collected in an "external contract" chapter.

## [1.5.0] - 2026-07-01

### Added
- **Writing-quality & readability rules.** Specs must read as plain, connected prose (not a pile of
  fragments), be structured as *shared background + per-audience sections + a glossary*, and
  **constrain the external delivery form (interfaces, product form, deliverable format, supported
  platforms, acceptance) while leaving internal technical implementation to R&D** (implementation
  choices become "R&D decides" or non-binding suggestions — a spec is not a design doc).
- Output template now includes a **《名词解释》(glossary)** section and an explicit "shared
  background, read first" convention in the Reader Guide.

## [1.4.1] - 2026-07-01

### Fixed
- **Standard output-directory convention (was undefined).** The skill produced specs but never said
  *where the file lands*. Now step 7 and the output-template conventions require writing the produced
  doc to **`feature-specs/<feature-name>/<feature-name>.md`** (one subfolder per feature, default root
  `feature-specs/`, overridable via a new config-zone knob) — not just pasting it into chat.

## [1.4.0] - 2026-07-01

### Added
- **Archetype I — Packaging / distribution / offline-install / deployment.** For features whose
  deliverable is *an artifact you install onto a target machine* (offline/air-gapped installers,
  one-command install scripts, prebuilt-artifact distribution, Docker/K8s deploy bundles, private
  offline repos). A~H didn't cover the installer itself; the risk isn't "does the low level support
  it" (it exists) but "can the artifact install cleanly, verifiably, upgradeably on the target".
  5 net-new probes (dependency-bundling incl. redistribution-license gate; install form + interactive
  vs silent boundary; integrity/signature fail-closed; install-time lifecycle self-check/idempotency/
  upgrade/uninstall/coexistence; permission landing) — platform matrix / EOL / support level / DX
  anchor are *reused* from H②③⑥ + the external-dependency axis, not re-listed.
- **H↔I mutual-exclusion rule** (installable package/script itself → I; sample/docs to copy → H),
  plus a note that H/I never drill down to firmware/algorithm/hardware.
- **L-Tier N/A exit for non-runtime features** (delivery/distribution/install/docs) in step-3
  classification and the Capability-Positioning template section.
- **Build/distribution-infra layer as bottom-most layer**: a sub-checklist + a high-risk
  mis-assignment red flag ("packaging/distribution/install defaulted to the SDK team") in
  `references/cross-layer-routing.md`.
- Worked example `references/example-offline-install.md`.
- Surfaced while running the skill on an offline-install requirement (network-failure / air-gapped).

## [1.3.0] - 2026-07-01

### Added
- **Archetype H probe ⑥ — copyability / extension-pattern & simplicity.** For reference-example
  features, whether a customer can *follow the pattern to adapt other interfaces themselves* often
  matters more than "does it run". Adds: is there one uniform, copyable mapping/adapter pattern
  (add-your-own = copy one unit + register one line)? a "how to add your own X" doc + a runnable
  add-on example? is it simple enough / anti-over-engineering? Acceptance anchor: an outsider can
  add one in N minutes. Surfaced while running the skill on the ROS requirement ("要有充分的参考
  意义，客户能仿照着自己去新适配 SDK 的其他接口，足够简单"). Reflected in the ROS worked example too.

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

[1.8.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.8.0
[1.7.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.7.0
[1.6.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.6.0
[1.5.1]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.5.1
[1.5.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.5.0
[1.4.1]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.4.1
[1.4.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.4.0
[1.3.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.3.0
[1.2.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.2.0
[1.1.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.1.0
[1.0.0]: https://github.com/Auromix/feature-spec-builder/releases/tag/v1.0.0
