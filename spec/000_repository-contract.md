---
id: SPEC-000
title: Repository Contract
status: Accepted
version: 0.1.0
date: 2026-09-25
commit: 1400b1aa2b4f6bf9e56c5bfe3e4e5f39c20b1ce1
---

# Repository Contract

## 1. Purpose

`git-init` is a contract-driven, Copier-based project template. It creates and evolves projects with a consistent software-development lifecycle without requiring a programming language, application framework, cloud provider, or deployment platform.

The contract is deliberately smaller than any individual project. Technology-specific behavior belongs in profiles and capability stages.

## 2. Permanent invariants

1. The contract is the source of truth; the generator renders it and must not duplicate architectural rules.
2. A project starts with a minimal core and adds capabilities incrementally.
3. One concern has one authoritative owner and one documented workflow.
4. Secrets, credentials, runtime state, and generated output do not become template source.
5. Every generated change is deterministic, reviewable, and safe to rerun.
6. GitHub is the default collaboration and automation platform.
7. Kubernetes, Argo CD, Terraform, Ansible, and observability are optional capabilities.
8. A generated project must be able to evolve without blindly overwriting project-owned changes.

## 3. Project model

A generated project has four independent attributes:

- **Kind**: `service`, `application`, `library`, `cli`, `documentation`, `infrastructure`, or `platform`.
- **Profile**: the selected language, framework, package manager, or infrastructure tool convention.
- **Capability stage**: an enabled concern such as documentation, Terraform, Kubernetes, or observability.
- **Environment**: `local`, `development`, `staging`, or `production`.

Kinds describe intent. Profiles describe implementation. Stages describe capabilities. Environments describe deployment targets.

## 4. Generated project boundaries

Only selected template content is generated. The generator implementation and template-authoring files are not copied into generated projects.

Possible generated top-level directories are:

```text
.project/
.github/
spec/
docs/
src/
tests/
infra/
platform/
scripts/
Taskfile.yml
```

Directories are created only when their capability is enabled.

## 5. Ownership map

| Area | Owner | Boundary |
|---|---|---|
| Project metadata | `.project/` | Selected kind, profile, stages, and contract version |
| Collaboration and CI | `.github/` | GitHub workflows, issue forms, and pull-request policy |
| Normative decisions | `spec/` | Requirements, contracts, technical specifications, and ADRs |
| Explanatory guidance | `docs/` | User, contributor, developer, security, delivery, and operations docs |
| Product code | `src/` or profile-defined roots | Application, library, or service implementation |
| Tests | `tests/` or profile-defined roots | Unit, integration, E2E, and fixtures |
| Infrastructure | `infra/` | Terraform provisioning and Ansible configuration |
| Runtime platform | `platform/` | Kubernetes, Argo CD, and observability |
| Repository automation | `Taskfile.yml` and `scripts/` | Safe, deterministic local and CI commands |

## 6. Capability stages

The core stage is always present. Other stages are opt-in:

- `docs`: MkDocs-based documentation and publishing.
- `automation`: Taskfile, toolchain, pre-commit, and CI extensions.
- `application`: Product source and test profile.
- `container`: Container packaging and image supply chain.
- `release`: Versioning, artifacts, and publishing.
- `terraform`: Infrastructure provisioning.
- `ansible`: Machine and system configuration.
- `kubernetes`: Kubernetes workloads and policies.
- `argocd`: GitOps reconciliation for Kubernetes.
- `observability`: Metrics, logs, traces, dashboards, alerts, and runbooks.

Stage dependencies are declared explicitly. Argo CD requires Kubernetes; no other optional stage is implied by the contract.

## 7. Automation contract

Taskfile is the standard human-facing automation facade. A project exposes only commands that are implemented by its active stages.

Canonical command names are:

```text
setup check status test build package release deploy rollback cleanup
```

`docs` is available when the documentation stage is enabled. No command may silently act as a placeholder or no-op.

A project selects one primary toolchain manager, such as `mise` or Devbox, and commits its lockfile when that manager supports locking.

## 8. Delivery contract

GitHub Actions validates source and publishes immutable artifacts. For Kubernetes projects, deployment intent is reconciled by Argo CD. CI must not normally mutate a production cluster directly.

The preferred flow is:

```text
pull request
  -> validation and security checks
  -> build and sign immutable artifact
  -> publish artifact
  -> update deployment intent
  -> Argo CD reconciliation
  -> health verification and rollback if required
```

## 9. Specification provenance

Every normative specification has YAML front matter containing:

- `id`;
- `title`;
- `status`;
- `version`;
- `date`;
- `commit`.

`commit` is the full Git SHA of the repository revision against which that specification was reviewed or approved. It does not need to equal the containing commit because that would create a circular hash requirement.

## 10. Evolution rules

A new capability is introduced as a vertical slice containing:

1. template content;
2. metadata and dependencies;
3. documentation;
4. validation;
5. security rules;
6. automation;
7. rollback or removal guidance;
8. an ADR when the choice is architectural.

A capability is not considered implemented when only its directory exists.

Breaking contract changes require a major contract version and migration guidance. Additive optional capabilities are minor changes. Documentation and validation fixes are patch changes.

## 11. Current implementation boundary

This initial implementation provides the core Copier template and contract specifications only. Documentation, application, infrastructure, Kubernetes, Argo CD, and observability stages are planned extensions and are not generated by default.
