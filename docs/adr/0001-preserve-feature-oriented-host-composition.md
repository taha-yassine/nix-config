# ADR-0001: Preserve feature-oriented host composition

- Status: Accepted
- Date: 2026-07-16

## Context

This configuration uses Den aspects to keep each independently selectable concern in a predictable place and to reuse it across hosts and platforms. An architecture review proposed consolidating workstation policy into a deeper module, but that would weaken the feature locality that makes changes such as GNOME configuration easy to find.

The fleet is small and every machine has exactly one human user. Despite that, several machines share stable roles, and the `nexus` host is being developed as the Linux desktop and primary gaming machine. Copying composition into each host would reduce indirection but would also duplicate policy and invite the hosts to drift.

Den is feature-first: aspects describe what a machine does, while hosts select aspects. Den also provides `host-aspects` to project user-relevant classes such as Home Manager from the host's aspect tree onto its users.

## Decision

Feature-oriented aspects remain the primary organization of the configuration.

- A leaf aspect represents an independently selectable concern.
- One canonical file or directory owns each aspect. A directory may split a single aspect's implementation into common and platform-specific files when the partition is predictable.
- Platform-specific implementation remains behind the aspect's interface and uses Den context, such as `host.class`, when host context is available.
- Host aspects are the composition roots. They select reusable role aspects and host-specific leaf aspects.
- Users remain Den entities for identity and Home Manager integration, but do not own authored configuration by default. The `host-aspects` battery projects the host's user-relevant configuration to its user.
- Shallow role aspects are acceptable when they name a stable, reused composition. The current role model is `developer` for cross-platform development configuration and `linux-workstation` for shared Linux workstation configuration.
- A role aspect is removed when deleting it only moves an include once. A role aspect is retained when deleting it duplicates a stable composition across hosts.

## Consequences

- Looking for a concern such as GNOME, terminal behavior, or gaming continues to have one obvious location.
- Adding a host usually means selecting a role aspect and then adding only genuine host-specific differences.
- The aspect graph and its small amount of indirection are intentional costs paid for locality and reuse.
- Role aspects must not become miscellaneous collections. Behavior that varies independently moves to a leaf aspect.
- User-specific aspects may be introduced later if the fleet gains users with genuinely different configuration.
- Architecture reviews should not recommend collapsing feature aspects solely to reduce the number of files or includes.

## Alternatives considered

### Consolidate workstation behavior into one deep module

Rejected because it would mix independently selectable concerns and make feature ownership less obvious. The current aspect interfaces provide useful locality even when their implementations are small.

### Compose every host independently

Rejected because `developer` and `linux-workstation` are real roles shared by multiple hosts. Repeating their include sets would trade navigational indirection for duplicated policy.

## References

- [Den core principles](https://den.denful.dev/explanation/core-principles/)
- [Den aspects and functors](https://den.denful.dev/explanation/aspects/)
- [Den batteries (`host-aspects`)](https://den.denful.dev/reference/batteries/)
