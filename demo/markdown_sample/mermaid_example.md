# Markdown & Mermaid Diagram Demo

This file demonstrates in-buffer rich markdown styling and Mermaid diagram rendering.

## 1. Flowchart Example

```mermaid
flowchart TD
    Client[Web Client / Neovim] -->|API Request| Gateway[API Gateway]
    Gateway --> Auth{Authenticated?}
    Auth -->|Yes| CoreService[Backend Microservice]
    Auth -->|No| Reject[401 Unauthorized]
    CoreService --> DB[(PostgreSQL Database)]
    CoreService --> Cache[(Redis Cache)]
```

## 2. Sequence Diagram Example

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant Editor as Neovim (diagram.nvim)
    participant CLI as Mermaid CLI (mmdc)
    participant Terminal as Kitty/Ghostty Graphics

    User->>Editor: Edit Markdown buffer
    Editor->>CLI: Generate diagram PNG (async)
    CLI-->>Editor: Diagram rendered to cache
    Editor->>Terminal: Render inline graphic via protocol
    Terminal-->>User: High-resolution in-buffer diagram!
```

## 3. Keybindings Quick Reference

- `<leader>mr`: Toggle rich markdown styling (`render-markdown.nvim`)
- `<leader>md`: Open rendered diagram at cursor in a dedicated tab/popup
- `<leader>mD`: Force refresh / re-render in-buffer diagrams
- `<leader>mc`: Clear rendered in-buffer diagram graphics
- `<leader>mp`: Toggle live browser preview (`markdown-preview.nvim`)
