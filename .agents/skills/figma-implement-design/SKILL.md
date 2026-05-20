---
name: figma-implement-design
description: Translates Figma designs into production-ready application code with 1:1 visual fidelity. Use when implementing UI code from Figma files, when user mentions "implement design", "generate code", "implement component", provides Figma URLs, or asks to build components matching Figma specs. For Figma canvas writes via `use_figma`, use `figma-use`.
---

# Implement Design

## Overview

This skill provides a structured workflow for translating Figma designs into production-ready code with pixel-perfect accuracy. It ensures consistent integration with the Figma MCP server, proper use of design tokens, and 1:1 visual parity with designs.

## Skill Boundaries

- Use this skill when the deliverable is code in the user's repository.
- If the user asks to create/edit/delete nodes inside Figma itself, switch to [figma-use](../figma-use/SKILL.md).
- If the user asks to build or update a full-page screen in Figma from code or a description, switch to [figma-generate-design](../figma-generate-design/SKILL.md).
- If the user asks only for Code Connect mappings, switch to [figma-code-connect-components](../figma-code-connect-components/SKILL.md).
- If the user asks to author reusable agent rules (`CLAUDE.md`/`AGENTS.md`), switch to [figma-create-design-system-rules](../figma-create-design-system-rules/SKILL.md).

## Prerequisites

- Figma MCP server must be connected and accessible.
- User must provide a Figma URL in the format: `https://figma.com/design/:fileKey/:fileName?node-id=1-2`.
  - `:fileKey` is the file key.
  - `1-2` is the node ID.
- Or, when using `figma-desktop` MCP, user can select a node directly in the Figma desktop app.
- Project should have an established design system or component library.

## Required Workflow

Follow these steps in order. Do not skip steps.

### Step 1: Get Node ID

#### Option A: Parse from Figma URL

When the user provides a Figma URL, extract the file key and node ID to pass as arguments to MCP tools.

URL format: `https://figma.com/design/:fileKey/:fileName?node-id=1-2`

Extract:

- File key: `:fileKey`, the segment after `/design/`.
- Node ID: `1-2`, the value of the `node-id` query parameter.

When using the local desktop MCP (`figma-desktop`), `fileKey` is not passed as a parameter to tool calls. The server automatically uses the currently open file, so only `nodeId` is needed.

Example:

- URL: `https://figma.com/design/kL9xQn2VwM8pYrTb4ZcHjF/DesignSystem?node-id=42-15`
- File key: `kL9xQn2VwM8pYrTb4ZcHjF`
- Node ID: `42-15`

#### Option B: Use Current Selection from Figma Desktop App

When using the `figma-desktop` MCP and the user has not provided a URL, the tools automatically use the currently selected node from the open Figma file in the desktop app.

Selection-based prompting only works with the `figma-desktop` MCP server. The remote server requires a link to a frame or layer to extract context. The user must have the Figma desktop app open with a node selected.

### Step 2: Fetch Design Context

Run `get_design_context` with the extracted file key and node ID.

```text
get_design_context(fileKey=":fileKey", nodeId="1-2")
```

This provides structured data including:

- Layout properties such as Auto Layout, constraints, and sizing.
- Typography specifications.
- Color values and design tokens.
- Component structure and variants.
- Spacing and padding values.

If the response is too large or truncated:

1. Run `get_metadata(fileKey=":fileKey", nodeId="1-2")` to get the high-level node map.
2. Identify the specific child nodes needed from the metadata.
3. Fetch individual child nodes with `get_design_context(fileKey=":fileKey", nodeId=":childNodeId")`.

### Step 3: Capture Visual Reference

Run `get_screenshot` with the same file key and node ID for a visual reference.

```text
get_screenshot(fileKey=":fileKey", nodeId="1-2")
```

This screenshot serves as the source of truth for visual validation. Keep it accessible throughout implementation.

If the available Figma MCP tool already returns a screenshot as part of `get_design_context`, use that screenshot as the visual reference.

### Step 4: Download Required Assets

Download any assets, images, icons, or SVGs returned by the Figma MCP server.

Asset rules:

- If the Figma MCP server returns a `localhost` source for an image or SVG, use that source directly.
- Do not import or add new icon packages.
- Do not use or create placeholders if a `localhost` source is provided.
- Assets are served through the Figma MCP server's built-in assets endpoint.

### Step 5: Translate to Project Conventions

Translate the Figma output into this project's framework, styles, and conventions.

Key principles:

- Treat the Figma MCP output, often React and Tailwind, as a representation of design and behavior, not final code style.
- Replace Tailwind utility classes with the project's preferred utilities or design system tokens.
- Reuse existing components such as buttons, inputs, typography, and icon wrappers instead of duplicating functionality.
- Use the project's color system, typography scale, and spacing tokens consistently.
- Respect existing routing, state management, and data-fetch patterns.

### Step 6: Achieve 1:1 Visual Parity

Strive for pixel-perfect visual parity with the Figma design.

Guidelines:

- Prioritize Figma fidelity to match designs exactly.
- Avoid hardcoded values. Use design tokens from Figma where available.
- When conflicts arise between design system tokens and Figma specs, prefer design system tokens but adjust spacing or sizes minimally to match visuals.
- Follow WCAG requirements for accessibility.
- Add component documentation as needed.

### Step 7: Validate Against Figma

Before marking complete, validate the final UI against the Figma screenshot.

Validation checklist:

- Layout matches spacing, alignment, and sizing.
- Typography matches font, size, weight, and line height.
- Colors match exactly.
- Interactive states work as designed: hover, active, disabled.
- Responsive behavior follows Figma constraints.
- Assets render correctly.
- Accessibility standards are met.

## Implementation Rules

### Component Organization

- Place UI components in the project's designated design system directory.
- Follow the project's component naming conventions.
- Avoid inline styles unless truly necessary for dynamic values.

### Design System Integration

- Always use components from the project's design system when possible.
- Map Figma design tokens to project design tokens.
- When a matching component exists, extend it rather than creating a new one.
- Document any new components added to the design system.

### Code Quality

- Avoid hardcoded values. Extract to constants or design tokens.
- Keep components composable and reusable.
- Add TypeScript types for component props in TypeScript projects.
- Include JSDoc comments for exported components when appropriate for the project.

## Examples

### Example 1: Implementing a Button Component

User says: "Implement this Figma button component: https://figma.com/design/kL9xQn2VwM8pYrTb4ZcHjF/DesignSystem?node-id=42-15"

Actions:

1. Parse URL to extract file key `kL9xQn2VwM8pYrTb4ZcHjF` and node ID `42-15`.
2. Run `get_design_context(fileKey="kL9xQn2VwM8pYrTb4ZcHjF", nodeId="42-15")`.
3. Run or retain screenshot for visual reference.
4. Download any button icons from the assets endpoint.
5. Check if project has an existing button component.
6. If yes, extend it with a new variant; if no, create a new component using project conventions.
7. Map Figma colors to project design tokens.
8. Validate against screenshot for padding, border radius, and typography.

Result: Button component matching Figma design, integrated with project design system.

### Example 2: Building a Dashboard Layout

User says: "Build this dashboard: https://figma.com/design/pR8mNv5KqXzGwY2JtCfL4D/Dashboard?node-id=10-5"

Actions:

1. Parse URL to extract file key `pR8mNv5KqXzGwY2JtCfL4D` and node ID `10-5`.
2. Run `get_metadata(fileKey="pR8mNv5KqXzGwY2JtCfL4D", nodeId="10-5")` to understand the page structure.
3. Identify main sections from metadata and their child node IDs.
4. Run `get_design_context(fileKey="pR8mNv5KqXzGwY2JtCfL4D", nodeId=":childNodeId")` for each major section.
5. Capture or retain screenshot for the full page.
6. Download all assets such as logos, icons, and charts.
7. Build layout using project's layout primitives.
8. Implement each section using existing components where possible.
9. Validate responsive behavior against Figma constraints.

Result: Complete dashboard matching Figma design with responsive layout.

## Best Practices

- Never implement based on assumptions. Always fetch `get_design_context` and a screenshot first.
- Validate frequently during implementation, not just at the end.
- If deviating from Figma for accessibility or technical constraints, document why.
- Always check for existing components before creating new ones.
- When in doubt, prefer the project's design system patterns over literal Figma translation.

## Common Issues and Solutions

### Issue: Figma output is truncated

Cause: The design is too complex or has too many nested layers to return in a single response.

Solution: Use `get_metadata` to get the node structure, then fetch specific nodes individually with `get_design_context`.

### Issue: Design does not match after implementation

Cause: Visual discrepancies between the implemented code and the original Figma design.

Solution: Compare side-by-side with the screenshot from Step 3. Check spacing, colors, and typography values in the design context data.

### Issue: Assets are not loading

Cause: The Figma MCP server's assets endpoint is not accessible or the URLs are being modified.

Solution: Verify the Figma MCP server's assets endpoint is accessible. The server serves assets at `localhost` URLs. Use these directly without modification.

### Issue: Design token values differ from Figma

Cause: The project's design system tokens have different values than those specified in the Figma design.

Solution: When project tokens differ from Figma values, prefer project tokens for consistency but adjust spacing and sizing to maintain visual fidelity.

## Additional Resources

- [Figma MCP Server Documentation](https://developers.figma.com/docs/figma-mcp-server/)
- [Figma MCP Server Tools and Prompts](https://developers.figma.com/docs/figma-mcp-server/tools-and-prompts/)
- [Figma Variables and Design Tokens](https://help.figma.com/hc/en-us/articles/15339657135383-Guide-to-variables-in-Figma)
