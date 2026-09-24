# git-init

`git-init` is a universal starting point for open-source software projects.

It is intended to bootstrap the full software development lifecycle without
assuming a programming language, application framework, deployment platform, or
runtime architecture. A project can begin here as a web application, API,
library, CLI, service, infrastructure repository, or another software product,
then be configured for its chosen stack.

## Purpose

This repository is being developed as a reusable project template and
engineering baseline. The stable part should be the project lifecycle and
governance; the implementation details should remain configurable.

The target lifecycle covers:

- requirements, scope, and project planning;
- architecture, design documentation, and decision records;
- implementation and developer workflows;
- automated quality, testing, and security checks;
- documentation for users, contributors, and operators;
- packaging, versioning, releases, and publishing;
- deployment, environments, migrations, and rollback;
- observability, incident response, maintenance, and continuous improvement.

## GitHub-first operating model

GitHub is the default platform for the template:

- GitHub Actions for CI/CD and reusable automation;
- GitHub Issues, Projects, and pull requests for collaboration;
- GitHub security automation for dependency, code, and secret checks;
- GitHub Releases and Packages for distribution;
- GitHub Pages with MkDocs for project documentation.

External DevOps systems are exceptions, not the baseline. Tools such as
Argo CD, Kubernetes operators, or cloud-specific controllers may be introduced
when GitHub cannot provide the required runtime or reconciliation capability.
Those integrations should remain isolated and configurable.

## Technology-neutral design

The template must not require Python, JavaScript, Django, Rails, React, Vue,
Docker, or any other specific stack. Stack-specific behavior belongs in
profiles, adapters, or project configuration.

Kubernetes-oriented deployment and DevOps workflows are part of the intended
direction, alongside simpler VM, container, and bare-metal deployment options.
They should extend the baseline rather than redefine the universal project
contract.

## Repository contents

- **[book/](book/)** - Current deployment and operations reference material.
  The source archive used to import this material is retained inside that
  directory for provenance and migration work.

The deployment book is source material for the evolving template. It is not
the definition of the repository's final shape.

## Documentation direction

The documentation system is intended to become an MkDocs-based site with
sections for:

- project definition and requirements;
- architecture and technical decisions;
- development and contribution;
- testing and quality;
- security and supply-chain controls;
- GitHub workflows and releases;
- deployment and Kubernetes operations;
- observability, maintenance, and incident response.

## Canonical repository

```text
git@github.com:sean-njela/git-init.git
```

## Contributing

Contributions should improve the reusable project baseline, preserve
technology neutrality, and avoid introducing a second competing workflow.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for
details.