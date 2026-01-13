# Ut & IT Design Rules
This section defines the rules and structure for unit and integration tests, 
ensuring consistency, traceability to requirements 
and reliable validation of safety-critical behavior across the project.

# General Rules
 - Each test shall verify exactly one behavior.
 - Each test shall be traceable to at least one requirement ID (SWR/RSR).
 - Tests shall be deterministic and repeatable.
 - Tests shall not depend on execution order.
 - Tests shall clean up all external state they create.
 - Tests shall not require manual interaction.
 - Tests shall fail clearly and early on invalid conditions.

### Unit Test Rules (UT)
 - Unit tests shall test pure logic or isolated modules.
 - Unit tests shall not depend on hardware.
 - OS, drivers, sockets, and peripherals shall be mocked or virtualized.
 - Each unit test file shall target one logical module.
 - Unit tests shall run in CI without elevated privileges whenever possible.

### Integration Test Rules (IT)
 - Integration tests shall verify interaction between components.
 - Integration tests may use:
    - Virtual interfaces (e.g. vcan).
    - OS services.
 - Integration tests shall explicitly state required system setup.
 - Integration tests shall clean up system state in TearDown.
 - Integration tests may require elevated permissions, but:
    - This shall be documented.
    - CI shall explicitly enable it.

# Traceability Rules
 - Each test shall reference the requirement(s) it verifies.
 - Requirement IDs shall appear:
    - In test file headers.
    - Or as comments above the test case.
 - Tests shall be referenced back in:
    - The requirement.
    - The traceability matrix.

# Naming Convencion
Test suite names shall reflect the module under test
Test names shall describe expected behavior
Avoid generic names like Test1, BasicTest
After
