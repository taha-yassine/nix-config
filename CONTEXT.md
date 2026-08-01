# Configuration Domain

## Aspect

A Den configuration concern that may span NixOS, Darwin, and Home Manager classes. One canonical file or directory owns each aspect.

## Leaf aspect

An independently selectable capability, such as GNOME, gaming, Android, terminal behavior, or Open WebUI. Platform-specific files may contribute implementation to the same leaf aspect without becoming separately selectable aspects.

## Role aspect

A reused composition describing what kind of machine a host is. Role aspects are ordinary Den aspects and are usually shallow composition manifests. A role exists only when multiple hosts share a stable selection.

## Developer role

The cross-platform development environment shared by Linux and macOS hosts. It includes terminal, Git, Nix, editor, container, development, and AI development tooling.

## Linux workstation role

The common Linux graphical workstation environment. It includes the Developer role, GNOME as the default desktop environment, shared desktop applications, and invariant workstation defaults. Experimental desktop environments and host-varying capabilities are selected by host aspects.

## Host composition

Host aspects are the composition roots. They select role aspects and independently varying leaf aspects, then add hardware and machine-specific implementation. `framework` is a portable gaming and Android workstation; `nexus` is the primary desktop gaming workstation.

## User projection

Users are Den entities that provide identity and Home Manager integration but own no authored configuration by default. Den's `host-aspects` battery projects user-relevant classes from each host's aspect tree to its user.

See [ADR-0001](docs/adr/0001-preserve-feature-oriented-host-composition.md) for the architectural rationale.
