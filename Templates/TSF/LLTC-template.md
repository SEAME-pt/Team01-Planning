---
id: SWD-<UNIQUE_ID>
header: "Short Design Title"
text: |
  This section details how the system/software will fulfill the associated requirement. 
  Include relevant architecture, algorithms, workflows, interface definitions, error handling, and diagrams if available.

tsf_type: "Design"                 # Use "Design" or equivalent
verification_method: "Design review, code inspection, simulation, test, etc."

children:                          # Link down to LLTC or sub-designs
  - id: LLTC-<CHILD_REF>

parents:                           # Link up to SRD or other parent items
  - id: SRD-<PARENT_REF>

reviewers:
  - name: "<Reviewer Name>"
    email: "<Reviewer Email>"

reviewed: ''                       # "YYYY-MM-DD - Approved by <Name> <Email>"

references:
  - type: "file"
    path: requirements/swd/<design_doc_or_diagram.md>
  # - type: "url"
  #   path: <link to design artifact or issue/PR>

active: true
derived: false
normative: true
level: 3.0                         # 3.0 = SWD
tags: ["design", "software", "interface"]        # Optional/project-specific

---
# Software Design Description

## 1. Purpose
Briefly state what this design covers and which requirement(s) it satisfies.

## 2. Architecture/Structure
Describe the main modules, classes, or components involved (diagrams or pseudocode welcome).

## 3. Interfaces
Detail key interfaces (function signatures, APIs, data structures, etc.).

## 4. Algorithms
Provide a summary or pseudocode of any essential algorithms.

## 5. Error Handling & Edge Cases
Describe how the design handles faults or abnormal conditions.

## 6. Links to lower levels
Reference any related LLTC items or test strategies.
