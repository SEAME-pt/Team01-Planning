---
id: URD-001                  # Unique ID, e.g. URD-001
header: "Short Title"        # Brief, descriptive title
text: |
  Detailed requirement statement goes here. This should clearly explain what the user (or system) needs and why.

tsf_type: "Assertion"        # Assertion, Claim, Request, or combination
verification_method: "User acceptance testing, demonstration, inspection, etc."

children:                    # Down-traceability: references to requirements in next refinement level (e.g. SRD)
  - id: SRD-001

parents: []                  # Optional: references to parent requirements (for e.g. LLTC, SWD)

reviewers:
  - name: "<Reviewer Name>"
    email: "<Reviewer Email>"

reviewed: ''                       # "YYYY-MM-DD - Approved by <Name> <Email>"

references:
  - type: "file"
    path: relative/path/to/file_or_artifact
  # - type: "url"
  #   path: https://github.com/org/repo/pull/123

active: true                 # true if currently valid
derived: false               # true if this is derived from other reqs, false if primary/original
normative: true              # true if this is a normative requirement (false if e.g. informative)
level: 1.0                   # 1.0=URD, 2.0=SRD, 3.0=SWD, 4.0=LLTC
tags: ["feature", "user", "priority-high"]  # Optional: extra keywords/tags

---
# Requirement Statement

A complete statement of the user requirement goes here, with as much detail as needed for implementation and validation.
