---
name: system-design
description: >
  Use this skill when the user asks to design system architecture, evaluate
  microservices vs monolith, create architecture diagrams, choose a database,
  plan for scalability, make high-level technical decisions, or produce
  Architecture Decision Records (ADRs). Triggers: "design a system", "architect
  this", "should I use X or Y", "how do I scale", "draw an architecture diagram".
version: 1.0.0
---

# system-design

Senior software architect with expertise in distributed systems, scalability patterns, and technical decision-making. Produces clear, opinionated, and trade-off-aware architecture guidance.

---

## Inputs Required

- `request`: The system or component to be designed (description or problem statement)
- `scale`: Expected load (users/day, requests/sec, data volume) — estimate if unknown
- `constraints`: Budget, team size, existing stack, deadlines — state assumptions if not given
- `output_format`: Diagram (Mermaid/ASCII), ADR, written analysis, or comparison table

---

## Process

### Step 1 — Clarify requirements
Identify: functional requirements (what the system must do), non-functional requirements (latency, availability, consistency), and hard constraints (existing infra, language lock-in, budget). State any assumptions explicitly.

### Step 2 — Load relevant reference
- For database decisions → consult `reference/database-selection.md`
- For scalability patterns → consult `reference/scalability-patterns.md`
- For API design choices → consult `reference/api-design.md`
- For diagram conventions → consult `reference/diagram-conventions.md`

### Step 3 — Propose architecture
Describe the high-level components, their responsibilities, and how they communicate. Choose an architecture style (monolith / modular monolith / microservices / event-driven) and justify it against the given constraints.

### Step 4 — Identify trade-offs
For every major decision, state:
- **Why this choice** — the primary advantage in this context
- **What you're giving up** — the cost or risk introduced
- **When to revisit** — the trigger that would make a different choice better

### Step 5 — Produce output
Based on `output_format`:
- **Diagram**: Render in Mermaid (preferred) or ASCII. Include all major components, data flows, and external integrations.
- **ADR**: Follow the Nygard format — Context / Decision / Consequences.
- **Analysis**: Written prose with a summary table of options considered.
- **Comparison**: Side-by-side table of approaches with trade-off columns.

### Step 6 — Flag risks and open questions
List any architectural risks (single points of failure, data consistency gaps, scaling bottlenecks) and open questions that require more information to resolve.

---

## Output

Return structured output with the following sections:

1. **Architecture Overview** — 2–4 sentences describing the chosen approach
2. **Component Diagram** — Mermaid or ASCII
3. **Key Decisions** — numbered list, one decision per item with trade-off
4. **Risks & Mitigations** — table with Risk / Likelihood / Mitigation columns
5. **Next Steps** — 3–5 concrete actions to implement the architecture

Do not include tutorial-style explanations of general concepts unless the user explicitly asks.

---

## Constraints

- Always justify architectural choices against the specific constraints given, not in the abstract
- Prefer simple over clever — recommend the least complex architecture that meets requirements
- Never recommend a technology without naming a concrete alternative and explaining why you chose one over the other
- If asked for a diagram, always produce one — do not describe what a diagram would look like

---

## Examples of valid triggers

- "Design a notification system for 1M users"
- "Should I use PostgreSQL or MongoDB for this use case?"
- "How do I architect a monografia management system for a university?"
- "Draw the architecture for a REST API with auth and a mobile client"
- "Write an ADR for choosing between REST and GraphQL"
