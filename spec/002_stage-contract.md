---
id: SPEC-002
title: Capability Stage Contract
status: Accepted
version: 0.1.0
date: 2026-09-25
commit: 1400b1aa2b4f6bf9e56c5bfe3e4e5f39c20b1ce1
---

# Capability Stage Contract

## 1. Purpose

A capability stage is a versioned, opt-in slice of the generated project. It adds structure, configuration, documentation, validation, and automation for one concern.

A stage is not complete when it only creates a directory.

## 2. Stage manifest

Each implemented stage must declare:

```yaml
id: docs
version: 0.1.0
requires:
  - core
conflicts: []
owners:
  - documentation
commands:
  - docs
validation:
  - mkdocs build
```

The final manifest format may evolve, but dependency and ownership information are mandatory.

## 3. Stage requirements

Every stage must provide:

1. renderable template content;
2. explicit dependencies and conflicts;
3. project metadata updates;
4. user and maintainer documentation;
5. deterministic validation;
6. security and secret-handling rules;
7. local and CI command definitions;
8. rollback or removal guidance;
9. tests or smoke checks appropriate to the stage.

## 4. Dependency rules

The initial dependency graph is:

```text
core
├── docs
├── automation
├── application
├── container
├── release
├── terraform
├── ansible
└── kubernetes
    ├── argocd
    └── observability
```

This graph is a default, not a restriction on future stages. New dependencies require an ADR when they alter the universal contract.

## 5. Activation rules

A stage is active only when:

- its template content exists;
- its metadata is enabled;
- its dependencies are active;
- its validation is available;
- its documentation is present.

No empty placeholder stage is generated.

## 6. Conflict rules

Stage installation must not silently overwrite project-owned files. Files should be classified as:

- create-only;
- generator-managed;
- user-managed.

Conflicts require review before generation or update proceeds.

## 7. Acceptance gate

A stage is ready for release only when a temporary project can be generated with that stage, its validation passes, and an update from the previous template revision behaves as documented.
