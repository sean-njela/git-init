# Full-stack deployment reference

This directory contains the current deployment and operations reference that
informs the broader `git-init` project template. It is deliberately kept as a
separate body of material while the repository evolves toward a
language-agnostic, framework-agnostic full SDLC baseline.

The original source archive, `FullStackDeploymentHandbook-main.zip`, is kept
in this directory as provenance while the material is being adapted into the
broader template.

The reference covers six deployment modules:

- **[Module 1: The foundation](01_foundation.md)** - Provisioning cloud servers, rootless user management, and SSH hardening.
- **[Module 2: The application runtime](02_application-runtime.md)** - Manual stack deployment, memory swap optimization, Gunicorn process engineering, and Supervisor service management.
- **[Module 3: Data & search](03_data-and-search.md)** - Self-hosting and isolating database and indexing layers securely behind server firewalls.
- **[Module 4: Global delivery & security](04_global-delivery-security.md)** - Domain DNS configuration, edge proxy routing, end-to-end SSL/TLS certificates, and Nginx web-layer hardening.
- **[Module 5: The automation pipeline](05_automation-pipeline.md)** - Building a GitHub Actions CI/CD framework with SCA, SAST, integration tests, and zero-downtime deployments.
- **[Module 6: Optimization & maintenance](06_optimization-maintenance.md)** - Log-based traffic analytics, resource observation, DAST, and automated maintenance tasks.

The introductory and concluding material is also available:

- **[Introduction](00_introduction.md)**
- **[Conclusion](07_conclusion.md)**

This reference is not the final repository contract. The root
[repository README](../README.md) defines the broader project-template
direction, including GitHub-first CI/CD, MkDocs documentation, configurable
technology profiles, and future Kubernetes-oriented DevOps workflows.

## Contributing

Contributions are welcome. Open an issue or submit a pull request for
corrections, suggestions, or improvements.

## License

This project is licensed under the MIT License. See [LICENSE](../LICENSE) for
details.