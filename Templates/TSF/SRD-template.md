---
id: SRD-<UNIQUE_ID>
header: "Short Requirement Title Here"
text: |
  Detailed software/system requirement statement goes here. Clearly describe what the software must do, including inputs, outputs, update rates, accuracy, error handling, or other critical properties.

tsf_type: "Assertion"        # Usually "Assertion", "Claim", or specific system requirement type
verification_method: "Test, inspection, simulation, code review, etc."

children:                    # Trace down to SWD or other requirements
  - id: SWD-<CHILD_REF>

parents:                     # Link back to relevant URD(s)
  - id: URD-<PARENT_REF>

reviewers:
  - name: "<Reviewer Name>"
    email: "<Reviewer Email>"

reviewed: ''                 # Fill upon approval: "YYYY-MM-DD - Approved by <Name> <Email>"

references:
  - type: "file"
    path: requirements/srd/<artifact_or_doc.md>
  # - type: "url"
  #   path: <URL to code, design, or issue/pull request>

active: true                 # Set to false if deprecated
derived: false               # true if derived from other requirements, false if original
normative: true              # true if this is a normative requirement
level: 2.0                   # 2.0 indicates this is SRD (requirements refinement stage)
tags: ["feature", "software", "priority-high"]  # Optional: add project-specific tags

---
# Software Requirement Statement

Expanded software/system requirement statement.  
- Clearly describe expected behavior  
- Specify inputs/outputs  
- Address timing/performance/accuracy  
- Mention any error handling or safety requirements
