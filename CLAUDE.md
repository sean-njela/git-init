# Repository Guidelines

## Project Overview

`git-init` is a contract-driven, Copier-based seed for universal open-source
project templates. Its stable contract is the software development lifecycle
and project governance; language, framework, runtime, deployment platform, and
infrastructure remain configurable.

The repository now contains the accepted repository, generator, and stage
contracts plus a minimal Copier core template. It does not yet contain the
documentation, application, infrastructure, Kubernetes, Argo CD, or
observability stages. Treat the root `README.md` and `spec/` as authoritative.

### Reference-book data flow

The book describes a provider- and stack-specific example flow, which must not be mistaken for an implemented repository workflow:

1. Archive a local project and transfer it to a VM with `scp`.
2. Run a FastAPI backend with Uvicorn, then Gunicorn/Uvicorn workers behind a Unix socket supervised by Supervisor.
3. Build a Vue frontend with Node/pnpm; serve its built assets through Nginx.
4. Keep Meilisearch internal and firewall-protected; export/import data when migrating.
5. Route DNS and TLS through the documented edge/Nginx/Certbot setup.
6. Feed Nginx logs to GoAccess and observe/load-test the system with Btop and Locust.

This is instructional prose for a hypothetical Vue/FastAPI/Meilisearch deployment. It is not a required architecture for `git-init` or for projects generated from it.

### Intended future architecture

The intended baseline is GitHub-first and Copier-generated. GitHub Actions,
Issues, Projects, pull requests, security automation, Releases/Packages, and
GitHub Pages with MkDocs are the default integrations. Stack-specific behavior
belongs in profiles and capability stages. Kubernetes, Argo CD, and
cloud-specific controllers are optional and isolated from the universal
contract.

## Key Directories

- `spec/` — normative repository, generator, and capability-stage contracts.
- `template/` — renderable Copier content; generated projects do not receive
  the maintainer repository outside this boundary.
- `copier.yml` — Copier questionnaire and template settings.
- `book/` — deployment and operations reference material.
- Root metadata — `README.md`, `LICENSE`, and `.gitignore`.

The archive `book/FullStackDeploymentHandbook-main.zip` and rendered artifact
`book/full_stack_deployment_guide.pdf` are retained for provenance and
migration work. They are not the source of truth for repository behavior.

## Development Commands

The current repository's first generation workflow is:

```bash
uvx copier copy . /tmp/git-init-generated --vcs-ref HEAD
```

The generated core project exposes `task status`, `task validate`, and
`task check`. The repository itself does not yet have a project-wide build,
run, lint, documentation-build, or deployment command.

Do not claim that a command is supported unless a corresponding configuration
or executable file has been added.

Useful current metadata checks are:

```bash
git status --short --branch
git remote get-url origin
```

The following commands appear in the deployment book as examples only; they are not commands for validating this repository:

```bash
pre-commit run --all-files
ruff check .
ruff format . --check
pytest tests/unit --tb=short
pytest tests/integration --tb=short -v
pnpm run lint
pnpm run test:coverage
pnpm run test:e2e
```

Run operational commands from the book only in an explicitly provisioned target environment, after replacing placeholders such as `<your_domain>` and `<your_username>` and reviewing their security impact. Never execute privileged, destructive, or `curl | sh`/`curl | bash` examples merely because they appear in documentation.

## Code Conventions & Common Patterns

- Preserve technology neutrality in root-level guidance.
- Keep stack-specific behavior behind profiles and capability stages.
- Use Copier for generation and versioned template updates.
- Use GitHub as the default collaboration and automation platform.
- Keep Terraform and Ansible under `infra/`; keep Kubernetes, Argo CD, and
  observability under `platform/` in generated projects.
- Every normative specification must contain front matter with a full reviewed
  Git commit SHA.
- Do not treat prose snippets, screenshots, PDFs, or the source ZIP as
  executable configuration.

There is no application code convention yet. Establish dependency injection,
state management, async design, error handling, and formatting conventions in
the relevant profile when implementation code is added.

## Important Files

- `README.md` — authoritative repository purpose and current implementation.
- `spec/000_repository-contract.md` — generated-project contract.
- `spec/001_generator-contract.md` — Copier generation and update contract.
- `spec/002_stage-contract.md` — capability-stage requirements.
- `copier.yml` — Copier template settings and questionnaire.
- `template/` — generated-project source content.
- `LICENSE` — MIT license and repository ownership metadata.
- `book/README.md` — reference index and explicit statement that the book is
  not the final project contract.
- `book/00_introduction.md` — reference scope, example stack, and placeholder
  conventions.
- `book/01_foundation.md` — VM provisioning and SSH/security examples.
- `book/02_application-runtime.md` — example application transfer, runtime,
  process, and Nginx flow.
- `book/03_data-and-search.md` — Meilisearch isolation and migration examples.
- `book/04_global-delivery-security.md` — DNS, TLS, edge delivery, and Nginx
  hardening examples.
- `book/05_automation-pipeline.md` — illustrative branch protection, CI,
  testing, and security workflows.
- `book/06_optimization-maintenance.md` — illustrative observability, load
  testing, DAST, and maintenance procedures.
- `book/07_conclusion.md` — summary of the current reference posture.

## Runtime & Tooling Preferences

The generated core template requires no application runtime. Copier is the
current generator and can be run through `uvx`; generated projects select one
primary toolchain manager, such as `mise` or Devbox, when a later stage needs
one.

Future profiles must declare their runtime, package manager, pinned tool
versions, and reproducible commands.

The canonical Git remote is:

```text
git@github.com:sean-njela/git-init.git
```

## Testing & QA

The current repository has no full test suite or CI workflow. The initial
verification surface is Copier generation and the generated core Taskfile.
Future stages must add their own test and quality contract, wire it into
GitHub Actions, and document local reproduction commands.

`book/05_automation-pipeline.md` remains illustrative reference material and
must not be reported as current QA infrastructure.

## Assistant Workflow

1. Read `README.md` and the nearest relevant `book/` chapter before changing repository guidance.
2. Check `git status` and preserve unrelated user changes.
3. Distinguish current files from examples and future direction in every plan or implementation.
4. Prefer GitHub-native solutions and reusable configuration; isolate exceptions such as Kubernetes or Argo CD.
5. For documentation changes, verify relative links and avoid adding claims about tooling that is not present.
6. Before delivery, report exactly which checks were run; do not imply that absent tests or CI passed.
