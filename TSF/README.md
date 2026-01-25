# TSF — Installation Guide

A short, clear guide to install TSF on a Linux machine.

## Index

Use this index to jump to the section you need:

- [Prerequisites](#prerequisites-)
- [Quick install](#quick-install-)
- [Quick test / usage](#quick-test--usage-)
- [Troubleshooting](#troubleshooting-)
- [Uninstall](#uninstall)
- [More info & support](#more-info--support-)
- [Project summary — Trustable Software Framework (TSF)](#project-summary--trustable-software-framework-tsf)
	- [Core Assumptions](#core-assumptions)
	- [Evidence and Artefacts](#evidence-and-artefacts)
	- [TSF Graph Model](#tsf-graph-model)
	- [Assumptions](#assumptions)
	- [Confidence Scoring Model](#confidence-scoring-model)
	- [TSF Six Tenets](#tsf-six-tenets)
	- [Example: Applying TSF to a C++ Project](#example-applying-tsf-to-a-c-project)
	- [Mastery Checklist](#mastery-checklist)

---

## Prerequisites

- **OS:** Linux
- **Tools:** `git`, `python3` (recommended 3.8+), `pip`
- Optional: a POSIX shell like `zsh`

---

## Quick install

```bash
# Clone (SSH)
git clone git@github.com:SEAME-pt/Team01-Planning.git
# Or clone (HTTPS)
git clone https://github.com/SEAME-pt/Team01-Planning
cd Team01-Planning

# Create and activate a virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Upgrade pip and install dependencies
python3 -m pip install --upgrade pip pyyaml typing_extensions

# Install trudag (official TSF tool)
# Note: trudag is part of the trustable project
git clone https://gitlab.com/CodethinkLabs/trustable/trustable.git /tmp/trustable
cd /tmp/trustable
python3 -m pip install .
cd -

# Verify installation
trudag --version
```

> Tip: use `python3 -m pip` to ensure you run the `pip` associated with the active interpreter/venv.

---

## Quick usage
- Get help for the installed tool:
```bash
trudag --help
```

---

## Troubleshooting ⚠️

- If `trudag` is not found: ensure the virtual environment is activated (`source .venv/bin/activate`) and that `which trudag` points to `.venv/bin`.
- Permission errors: avoid `sudo pip install`; prefer using a virtual environment or a user install.
- SSH clone/SSL errors: check your SSH keys, network, or use the HTTPS clone URL.
- If installation fails during `pip install .` in the `trustable` repo, inspect the pip output for missing build dependencies and install them (e.g., build-essential, python3-dev).

---

## Uninstall

To remove the installed package (while in the venv):
```bash
python3 -m pip uninstall trustable
```

---

## More info & support 💡

- trudag / trustable repo: https://gitlab.com/CodethinkLabs/trustable/trustable

---

## Project summary — Trustable Software Framework (TSF)

> The TSF summary below is included here for convenience. The original standalone `TSF-RESUME.md` is still available if you prefer a separate document.

### Trustable Software Framework (TSF)

#### Core Assumptions

• Trust must always be based on verifiable evidence, not unverified claims or reputation.  
• Software risk is continuous and dynamic; confidence must be maintained, not assumed.  
• Traditional engineering processes are insufficient without continuous, evidence-based validation.  
• Traceability, auditability, and quantitative confidence are essential to evaluating trust.  
• TSF applies to both open-source and proprietary projects, emphasizing transparency and reproducibility.  

#### Evidence and Artefacts

In TSF, artefacts (British spelling of 'artifacts') are any tangible pieces of evidence that support a claim about the software. They are the recorded outputs, reports, and documents that prove what was done, when, and by whom.

• Source control artefacts – commit logs, tags, and author information proving traceability.  
• Build artefacts – compiler outputs, build logs, and CI/CD records proving reproducibility.  
• Test artefacts – unit and integration test reports verifying behavior against expectations.  
• Dependency artefacts – SBOMs, license manifests, and checksums proving component provenance.  
• Operational artefacts – runtime metrics, crash reports, and uptime data showing actual behavior.  
• Documentation artefacts – requirements, designs, and architecture documents clarifying intent.  

#### TSF Graph Model

TSF represents the relationship between evidence and trust through a directed acyclic graph (DAG). Each node in this graph represents an expectation, assertion, evidence artefact, or assumption. The connections between them describe how general goals are supported by specific claims and their proof.

For example:

```
[Expectation] The system is secure
	↓
[Assertion] All dependencies are verified
	↓
[Evidence] Dependency list, SBOM, CI security log
```

#### Assumptions

Assumptions are the beliefs or premises your evidence relies on. They represent areas where you depend on external trust or accept uncertainty due to incomplete verification.  
In the TSF graph, assumptions are connected to assertions or evidence nodes to make explicit what is being trusted indirectly.

Example structure:

```
[Expectation] Software is secure
	↓
[Assertion] All dependencies are verified
	↓
[Evidence] Dependency list and audit log
	↘
[Assumption] Upstream repository signatures are authentic
```

Common examples of assumptions include:

• Assuming external repositories are genuine and not compromised.  
• Assuming the compiler output is correct and deterministic.  
• Assuming regression tests are comprehensive enough to detect major faults.  
• Assuming production telemetry accurately reflects real runtime conditions.  
• Assuming hardware and firmware components behave as documented by the manufacturer.  

For example, if you build your software on a Raspberry Pi and rely on its manufacturer’s documentation, you make the assumption that the Raspberry Pi hardware and firmware function correctly as specified. This is valid but must be declared, as it represents a dependency on external trust.  

#### Confidence Scoring Model

The TSF confidence model quantifies the strength of trust based on the completeness and credibility of evidence. Each assertion receives a confidence value from 0 to 1, representing the degree of trust justified by supporting artefacts.

• An assertion starts with a base confidence value derived from its evidence quality and traceability.  
• Assumptions reduce this score proportionally to their importance and uncertainty.  
• Expectations inherit a weighted average of the confidence scores of their supporting assertions.  
• Each tenet (Provenance, Construction, Change, Expectations, Results, Confidence) aggregates its expectations’ scores.  
• The overall system confidence is computed as a composite of all tenets, weighted by criticality.  
• Confidence can also be interpreted qualitatively: High (0.9–1.0), Medium (0.6–0.9), Low (<0.6).  
• Declaring assumptions ensures transparency about uncertainty and prevents inflated confidence.  

#### TSF Six Tenets

1. Provenance – The documented origin, authorship, and integrity of all components.  
2. Construction – The methods and tools used to build, test, and deploy software.  
3. Change – How modifications, patches, and regressions are tracked and controlled.  
4. Expectations – The explicit definitions of what the system must and must not do.  
5. Results – The measured outcomes and behaviors observed in testing and production.  
6. Confidence – The overall quantified trust derived from all supporting evidence.  

#### Example: Applying TSF to a C++ Project

Suppose you are developing a C++ game engine and want to evaluate its trust level using TSF. You would define expectations such as performance and stability, then trace supporting assertions and evidence.

• Define Expectations – The engine must load assets within 100 milliseconds and not crash on malformed input.  
• Define Assertions – All asset loaders have unit tests; fuzz testing is applied to input handlers.  
• Capture Evidence – CI logs, coverage reports, dependency lists, and build artefacts.  
• List Assumptions – The compiler and Raspberry Pi platform behave as documented.  
• Calculate Confidence Scores – Each assertion receives a numeric confidence value, adjusted for assumptions.  
• Aggregate confidence scores by tenet to produce an overall trust profile.  

#### Mastery Checklist

• Understand that trust must be supported by recorded, verifiable evidence.  
• Recognize the TSF graph model linking expectations, assertions, evidence, and assumptions.  
• Be able to identify and document all assumptions explicitly.  
• Use confidence scoring to express the completeness of trust objectively.  
• Apply the six tenets as a structured way to measure and communicate confidence.  
• Replace assumptions with evidence over time to increase measurable trust.  
