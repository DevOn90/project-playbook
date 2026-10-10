# Temporary Documentation

## ADR-001: Type of Architecture

### Context
There are three possible ways to structure the architecture:

1. Monolithic Architecture
2. Microservices Architecture
3. Hybrid Architecture

Each architecture type has its way of implementation to project-playbook module.

### Decision
The decision will be based on market demand per architecture type. For Java specifically, the 2024 Jakarta EE developer survey found:

Market demand per architecture type:
- Monolithic Architecture: 18%
- Microservices Architecture: 31%
- Hybrid Architecture: 46%

Key considerations for each architecture type:
- Scalability (ability to handle increased load)
- Frequent changes (e.g. feature updates and bug fixes)
- Failure isolation (integration-service with e.g. API Gateway)
- Security boundaries (protection of sensitive data and access control)

As a result, the `Hybrid Architecture` is the most favored choice based on market demand and key considerations.

### Consequences