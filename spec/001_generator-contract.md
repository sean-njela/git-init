---
id: SPEC-001
title: Copier Generator Contract
status: Accepted
version: 0.1.0
date: 2026-09-25
commit: 1400b1aa2b4f6bf9e56c5bfe3e4e5f39c20b1ce1
---

# Copier Generator Contract

## 1. Decision

`git-init` uses Copier as its project-generation and template-update engine. A custom renderer or custom merge engine is not part of the initial implementation.

The repository contract remains independent of Copier. Copier renders the contract, records answers, and performs versioned updates.

## 2. Template boundary

The repository contains maintainer files at its root and renderable project files below `template/`.

The Copier configuration uses:

```yaml
_subdirectory: template
```

The generated project does not contain the generator repository's maintainer documentation, template source, or test fixtures.

## 3. Required generated metadata

Copier writes `.copier-answers.yml`. The template also writes `.project/project.yaml` with:

- schema version;
- project name and slug;
- project kind;
- selected profile;
- enabled capabilities;
- contract version;
- generator engine identifier.

The answers file must not be edited manually. Changes to generation choices are made through Copier commands such as `copier update --data`.

## 4. Initial generation

The supported initial workflow is:

```bash
copier copy gh:sean-njela/git-init ./project --vcs-ref v0.1.0
```

A generated project should be created in an empty destination. Generation must be deterministic for the same template revision and answers.

## 5. Updates

Template releases are consumed by Git tag or explicit Git revision:

```bash
copier update --vcs-ref v0.2.0
```

Projects must be clean before updates. Conflicts require manual review and must not be merged with unresolved conflict markers or rejection files.

## 6. Safety rules

The generator must not:

- store secret values;
- run Terraform apply, Ansible execution, or Kubernetes mutation;
- install arbitrary project dependencies without explicit project commands;
- overwrite project-owned changes silently;
- follow the template repository's moving default branch by default.

Hooks are limited to validation and safe metadata generation.

## 7. Questionnaire contract

The initial questionnaire defines:

```text
project_name
project_slug
project_kind
profile
project_description
license_holder
```

Capability questions are added only when their corresponding stages are implemented. An answer must never enable a stage whose template and validation are absent.

## 8. Future wrapper

A branded `git-init` executable may later wrap Copier to provide commands such as:

```text
new
list
status
validate
```

That wrapper is a convenience interface, not a second rendering engine. It is intentionally deferred until direct Copier workflows and stage composition have been proven.
