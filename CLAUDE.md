# Repository Guidelines

## Project Overview

`git-init` is a documentation-first seed for a universal open-source project template. Its intended stable contract is the software development lifecycle and project governance; language, framework, runtime, deployment platform, and infrastructure remain configurable.

The repository is not currently an application, library, or runnable CI/CD system. It currently contains the project direction, licensing metadata, and a deployment reference book. Treat the root `README.md` as authoritative for the broader template direction.

## Architecture & Data Flow

### Current repository architecture

- `README.md` defines the technology-neutral project contract, GitHub-first operating model, and intended MkDocs/Kubernetes direction.
- `book/` contains the current full-stack deployment and operations reference. It is source material for the evolving template, not the final repository architecture.
- There is currently no application source tree, package manifest, test suite, CI workflow, MkDocs configuration, infrastructure manifest, or executable repository script.

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

The intended baseline is GitHub-first: GitHub Actions, Issues, Projects, pull requests, security automation, Releases/Packages, and GitHub Pages with MkDocs. Stack-specific behavior should live in profiles, adapters, or project configuration. Kubernetes, Argo CD, and cloud-specific controllers are optional integrations for capabilities GitHub cannot provide and must remain isolated from the universal contract.

## Key Directories

- `book/` — deployment and operations reference material.
- `book/images/` — diagrams and screenshots used by the reference chapters.
- Root metadata — `README.md`, `LICENSE`, and `.gitignore`.

The archive `book/FullStackDeploymentHandbook-main.zip` and rendered artifact `book/full_stack_deployment_guide.pdf` are retained for provenance and migration work. They are not the source of truth for repository behavior.

## Development Commands

No repository-level build, run, lint, test, documentation-build, or deployment command exists yet. Do not claim that a command is supported unless a corresponding configuration or executable file has been added.

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

- Preserve technology neutrality in root-level guidance. Do not promote the book's Python, Vue, Node, pnpm, Nginx, or Meilisearch examples into mandatory repository requirements.
- Keep stack-specific behavior behind a clearly named profile, adapter, or project configuration when those structures are introduced.
- Use GitHub as the default collaboration and automation platform. External DevOps systems are explicit, documented exceptions.
- Markdown chapters use numeric ordering (`00_` through `07_`) and descriptive lowercase filenames with hyphens where needed.
- Documentation placeholders use angle brackets, for example `<your_domain>`; replace them before execution and remove the brackets.
- Preserve least-privilege operational patterns from the book: SSH keys, non-root/system users, firewall isolation, and explicit service validation such as `nginx -t` before reload.
- Do not treat prose snippets, screenshots, PDFs, or the source ZIP as executable configuration.

There is no current application code convention for dependency injection, state management, async design, error handling, or formatting. Establish those conventions in the relevant stack profile when implementation code is added rather than inferring them from the deployment book.

## Important Files

- `README.md` — authoritative repository purpose, scope, GitHub-first model, and future direction.
- `LICENSE` — MIT license and repository ownership metadata.
- `.gitignore` — broad inherited ignore rules; it is not evidence that .NET, JavaScript, Python, or another runtime is active.
- `book/README.md` — reference index and explicit statement that the book is not the final project contract.
- `book/00_introduction.md` — reference scope, example stack, and placeholder conventions.
- `book/01_foundation.md` — VM provisioning and SSH/security examples.
- `book/02_application-runtime.md` — example application transfer, runtime, process, and Nginx flow.
- `book/03_data-and-search.md` — Meilisearch isolation and migration examples.
- `book/04_global-delivery-security.md` — DNS, TLS, edge delivery, and Nginx hardening examples.
- `book/05_automation-pipeline.md` — illustrative branch protection, pre-commit, CI, testing, and security workflows.
- `book/06_optimization-maintenance.md` — illustrative observability, load testing, DAST, and maintenance procedures.
- `book/07_conclusion.md` — summary of the current reference posture.

## Runtime & Tooling Preferences

The current repository has no required runtime, package manager, dependency lockfile, build tool, or documentation tool configuration. IntelliJ metadata mentioning JDK 21 is local IDE state and is not a project requirement.

The book's hypothetical deployment uses Python 3 with `pip` for the backend and Node/pnpm for a Vue frontend on Ubuntu. Those are reference choices only. Future project profiles must declare their own runtime, package manager, pinned tool versions, and reproducible commands.

The canonical Git remote is:

```text
git@github.com:sean-njela/git-init.git
```

## Testing & QA

No tests, test framework, fixtures, coverage configuration, lint/format configuration, CI checks, security scanners, or QA scripts currently exist. There is no repository-level coverage threshold.

`book/05_automation-pipeline.md` contains illustrative examples for unit, integration, and end-to-end tests, including pytest, frontend coverage, Playwright, dependency audits, Bandit, and DAST. These examples describe a future application pipeline and must not be reported as current QA infrastructure.

When executable project code is added, add its test and quality contract with the relevant stack profile and wire it into GitHub Actions. Document test discovery, required checks, coverage policy, security scanning, and local reproduction commands together; do not silently assume the book's example commands apply.

## Assistant Workflow

1. Read `README.md` and the nearest relevant `book/` chapter before changing repository guidance.
2. Check `git status` and preserve unrelated user changes.
3. Distinguish current files from examples and future direction in every plan or implementation.
4. Prefer GitHub-native solutions and reusable configuration; isolate exceptions such as Kubernetes or Argo CD.
5. For documentation changes, verify relative links and avoid adding claims about tooling that is not present.
6. Before delivery, report exactly which checks were run; do not imply that absent tests or CI passed.
