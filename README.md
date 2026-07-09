# QB-Winget

## Purpose and boundaries

QB64/InForm desktop interface and tooling for Windows Package Manager workflows.

This document is the internal governance and handoff entry point. Existing `README.md`, process documents, source, tests, and built artifacts remain project evidence and should be consulted for operational detail.

## Governance

- [Project manifest](QB-Winget.manifest.toml)
- [Modification instructions](AGENTS.md)
- [DRS canonical standard](D:/.library/aptlantis_core/DRS/README.md)
- [Workspace Governance Standard](D:/.library/aptlantis_core/WGS/README.md)

## Current state

Governance metadata was reconciled on 2026-07-08: version `1.0.0`, lifecycle `active`, stage `active`. Evidence reviewed: README.md, executable, and legacy manifest. The build, tests, shipping artifact, and release posture were not executed during this metadata pass, so this classification is not a release-readiness claim.

## Structure and relationships

This is registered as one independently governed project.

Legacy manifests, when listed in `QB-Winget.manifest.toml`, are retained as migration evidence rather than parallel authority.

## Build and verification

Follow the existing README and InForm/QB64 workflow; verify the built executable and its winget interactions.

Record verified commands, artifacts, versions, and current test results here as project-specific reconciliation proceeds.

## Known gaps and next review

- Confirm the project lifecycle and active-development state.
- Confirm build, run, test, packaging, and release commands from current source.
- Reconcile useful fields from legacy manifests without deleting historical evidence.
- Replace inferred descriptions with project-owner language where needed.
