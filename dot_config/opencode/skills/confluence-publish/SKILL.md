---
name: confluence-publish
description: Prepare and publish markdown documents to Confluence using the mark CLI tool
license: MIT
compatibility: opencode
metadata:
  tool: mark
  docs: https://github.com/kovetskiy/mark
---

## Overview

Prepare and publish markdown documents to Confluence using the `mark` CLI tool.

## When to Use

- Publishing documentation to Confluence from markdown files
- Creating hierarchical page structures in Confluence
- Converting markdown with diagrams (mermaid) to Confluence

## Prerequisites

The `mark` CLI tool and Confluence credentials are already configured via environment variables:
- `MARK_BASE_URL` - Confluence instance URL
- `MARK_SPACE` - Target space key  
- `MARK_USERNAME` / `MARK_PASSWORD` - Authentication credentials
- MARK_EDIT_LOCK - true (optional, locks pages for manual editing after publishing)
- MARK_H1_DROP - true (optional, drops H1 from content since Confluence uses page title as H1)
- MARK_MERMAID_PROVIDER - mermaid-go (optional, specifies mermaid rendering provider)

No additional setup required.

## Critical Rules

1. **Title = Identifier**: Once a page title is set, DO NOT change it. The combination of `Title + Parent` is the page's unique identifier in Confluence. Changing the title creates a duplicate page.

2. **Always dry-run first**: Use `mark -f <file> --dry-run` before publishing to preview changes.

3. **Parents must exist or be created first**: If specifying a parent page, ensure it exists or will be created by publishing it first.

## Document Structure

Every markdown file must start with HTML comment metadata:

```markdown
<!-- Title: Page Title Here -->
<!-- Parent: Parent Page Title -->
```

### Standard Header Template

Include this at the top of every document:

```markdown
<!-- Title: Your Page Title -->
<!-- Parent: Parent Page Name -->
<!-- Macro: JIRA\:([A-Z]+\-\d+)
   Template: ac:jira:ticket
   Ticket: ${1} -->
<!-- Macro: :toc:
     Template: ac:toc
     Printable: 'false'
     MaxLevel: 3
     MinLevel: 2 -->

# Page Heading

:toc:

## Content starts here...
```

### Understanding Macros

Macros use regex patterns to transform text into Confluence components:
- `Macro:` defines a regex pattern to match
- `Template:` specifies the Confluence macro to use (e.g., `ac:jira:ticket`, `ac:toc`, `ac:image`)
- Capture groups `${1}`, `${2}` extract matched values

## Attachments

To attach files (zip archives, scripts, etc.):

```markdown
<!-- Attachment: ./path/to/file.zip -->
```

Reference the attachment in content using standard markdown links.

## Images

For images, add both an attachment and use markdown syntax:

```markdown
<!-- Attachment: assets/diagram.png -->

![Diagram description](assets/diagram.png)
```

### Images with Custom Width

Define this macro once in the header, then use the special syntax:

```markdown
<!-- Macro: \!\[.*\]\((.+)\)\<\!\-\- width=(.*) \-\-\>
     Template: ac:image
     Attachment: ${1}
     Width: ${2} -->

![description](assets/image.png)<!-- width=500 -->
```

## Info/Warning/Note Panels

Use GitHub-style alerts (must be at root level, not nested):

```markdown
> [!NOTE]
> This renders as a blue Info panel in Confluence

> [!TIP]
> This renders as a green Tip panel

> [!WARNING]
> This renders as a yellow Note panel (caution)

> [!CAUTION]
> This renders as a red Warning panel (danger)
```

## In-Document Features

| Syntax              | Result                     |
| ------------------- | -------------------------- |
| `:toc:`               | Table of contents          |
| `JIRA:PROJ-123`       | Clickable Jira ticket link |
| `:children:`          | List of child pages        |
| Mermaid code blocks | Rendered diagrams          |

## Page Hierarchy

**Parent page** (`main.md`):
```markdown
<!-- Title: Project Documentation -->

# Project Documentation

:children:
```

**Child page** (`design.md`):
```markdown
<!-- Title: Design Document -->
<!-- Parent: Project Documentation -->

# Design Document
```

Publish parent pages before child pages to ensure hierarchy is created correctly.

## Publishing Commands

```bash
# Preview without publishing (ALWAYS do this first)
mark -f path/to/document.md --dry-run

# Publish a single file
mark -f path/to/document.md

# Publish all markdown files in directory
mark -f path/to/directory/
```

## Error Recovery

| Problem                   | Solution                                                                           |
| ------------------------- | ---------------------------------------------------------------------------------- |
| Duplicate page created    | Delete the duplicate in Confluence manually; ensure title matches original exactly |
| Page not found error      | Check that parent page exists and title spelling matches exactly                   |
| Authentication failed     | Verify `MARK_PASSWORD` env var contains valid API token                              |
| Attachments not uploading | Ensure file paths are relative to the markdown file location                       |

## Common Mistakes to Avoid

1. **Changing page titles** - Creates duplicates (delete manually in Confluence)
2. **Missing Title metadata** - Page won't be created
3. **Nested blockquotes** - Won't convert to panels (must be root level)
4. **Publishing without dry-run** - May cause unintended changes
5. **Publishing child before parent** - Parent page won't exist, may create orphan
