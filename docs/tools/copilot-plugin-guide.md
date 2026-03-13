# GitHub Copilot CLI Plugin Guide

How to create, distribute, and contribute to a plugin for your team.

---

## What Is a Plugin?

A **plugin** is an installable package that bundles Copilot CLI customizations — skills, custom agents, hooks, and MCP server configurations — into a single installable unit. Plugins make it easy to share a consistent Copilot setup across a team without manual configuration.

---

## Prerequisites

- GitHub Copilot CLI installed (`copilot` available in your terminal)
- An active GitHub account and Copilot subscription
- A GitHub repository to host your plugin and marketplace (for team distribution)

---

## Plugin Structure

At minimum, a plugin is a directory containing a `plugin.json` manifest file. Everything else is optional.

```
my-plugin/
├── plugin.json           # Required manifest
├── agents/               # Custom agents (optional)
│   └── my-agent.agent.md
├── skills/               # Skills (optional)
│   └── my-skill/
│       └── SKILL.md
├── hooks.json            # Hook configuration (optional)
├── .mcp.json             # MCP server config (optional)
└── scripts/              # Scripts referenced by skills/hooks (optional)
    └── my-script.sh
```

---

## Step 1: Create the Plugin Manifest

Create a directory and add a `plugin.json` file at the root:

```json
{
  "name": "my-team-tools",
  "description": "Shared tools and workflows for our team",
  "version": "1.0.0",
  "author": {
    "name": "Your Team",
    "email": "team@example.com"
  },
  "license": "MIT",
  "keywords": ["team", "workflow"],
  "agents": "agents/",
  "skills": "skills/",
  "hooks": "hooks.json",
  "mcpServers": ".mcp.json"
}
```

**Required field:** `name` (kebab-case, max 64 chars)

**Component path fields** — omit any you aren't using; the CLI will use the defaults shown below:

| Field        | Default     | What it points to              |
|--------------|-------------|--------------------------------|
| `agents`     | `agents/`   | `.agent.md` files              |
| `skills`     | `skills/`   | Directories containing `SKILL.md` |
| `hooks`      | —           | A `hooks.json` file            |
| `mcpServers` | —           | A `.mcp.json` file             |

---

## Step 2: Add Skills

Skills are task-specific instruction sets. Create one directory per skill under `skills/`:

```
skills/
└── pr-checklist/
    └── SKILL.md
```

**`skills/pr-checklist/SKILL.md`:**

```markdown
---
name: pr-checklist
description: Run a pre-PR checklist before opening a pull request. Use this when asked to prepare or review a PR.
---

Before opening a pull request, verify the following:

1. Run the test suite and confirm all tests pass.
2. Check for linting errors.
3. Ensure the PR description explains the "what" and "why".
4. Confirm there are no debug statements or commented-out code.
5. Verify the branch is up to date with the base branch.

Report any failures clearly to the user.
```

---

## Step 3: Add a Custom Agent

Agents are specialized Copilot personas. Create `.agent.md` files under `agents/`:

**`agents/security-auditor.agent.md`:**

```markdown
---
name: security-auditor
description: Reviews code for security vulnerabilities. Use this agent when asked to audit, seccheck, or security-review code files.
tools: ["bash", "view", "grep", "glob"]
---

You are a security expert. When reviewing code, check for:

- Hardcoded secrets or credentials
- SQL injection vulnerabilities
- Cross-site scripting (XSS)
- Insecure dependencies
- Authentication bypass risks
- Exposed sensitive data in logs

Provide a structured report with risk level (High/Medium/Low) and recommended fix for each issue.
```

---

## Step 4: Add Hooks (Optional)

Hooks run shell commands at lifecycle events. Create a `hooks.json` file:

```json
{
  "version": 1,
  "hooks": {
    "sessionStart": [
      {
        "type": "command",
        "bash": "echo \"[$(date)] Session started in $(pwd)\" >> ~/.copilot/session.log",
        "timeoutSec": 5
      }
    ],
    "preToolUse": [
      {
        "type": "command",
        "bash": "./scripts/pre-tool-check.sh",
        "timeoutSec": 10
      }
    ]
  }
}
```

**Available hook triggers:**

| Hook                  | When it runs                             |
|-----------------------|------------------------------------------|
| `sessionStart`        | When a CLI session begins                |
| `sessionEnd`          | When a CLI session ends                  |
| `userPromptSubmitted` | When a user submits a prompt             |
| `preToolUse`          | Before a tool runs (e.g., `bash`, `edit`) |
| `postToolUse`         | After a tool runs                        |
| `errorOccurred`       | When an error occurs                     |

---

## Step 5: Add an MCP Server (Optional)

MCP servers extend Copilot with external tools. Add a `.mcp.json` file:

```json
{
  "mcpServers": {
    "internal-tools": {
      "command": "npx",
      "args": ["-y", "@your-org/internal-mcp-server"],
      "env": {
        "API_KEY": "${INTERNAL_API_KEY}"
      }
    }
  }
}
```

---

## Step 6: Install and Test Locally

```bash
# Install from local path
copilot plugin install ./my-team-tools

# Verify it loaded
copilot plugin list

# In an interactive session, verify components:
/agent           # Check custom agents loaded
/skills list     # Check skills loaded
```

After making changes, reinstall to pick up updates:

```bash
copilot plugin install ./my-team-tools
```

---

## Step 7: Distribute to Your Team via a Marketplace

### 7a. Set Up the GitHub Repository

Create a repository (e.g., `your-org/copilot-plugins`) with this structure:

```
copilot-plugins/
├── .github/
│   └── plugin/
│       └── marketplace.json    # Marketplace manifest
└── plugins/
    └── my-team-tools/          # Your plugin directory
        ├── plugin.json
        ├── agents/
        ├── skills/
        └── hooks.json
```

### 7b. Create the Marketplace Manifest

**`.github/plugin/marketplace.json`:**

```json
{
  "name": "team-plugins",
  "owner": {
    "name": "Your Organization",
    "email": "team@example.com"
  },
  "metadata": {
    "description": "Internal Copilot plugins for our engineering team",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "my-team-tools",
      "description": "Shared tools and workflows for our team",
      "version": "1.0.0",
      "source": "./plugins/my-team-tools"
    }
  ]
}
```

### 7c. Push to GitHub

```bash
git add .
git commit -m "Add my-team-tools plugin"
git push
```

### 7d. Team Members Register and Install

```bash
# Register the marketplace (one-time setup)
copilot plugin marketplace add your-org/copilot-plugins

# Browse available plugins
copilot plugin marketplace browse team-plugins

# Install the plugin
copilot plugin install my-team-tools@team-plugins

# Keep it updated
copilot plugin update my-team-tools
```

---

## Step 8: Contribution Workflow

Since the plugin lives in a GitHub repo, your team contributes using standard pull requests:

1. **Fork or branch** the plugin repository
2. **Make changes** — add a new skill, update an agent, fix a hook
3. **Test locally** — `copilot plugin install ./plugins/my-team-tools`
4. **Bump the version** in `plugin.json` (follow semver: `1.0.0` → `1.0.1` for fixes, `1.1.0` for new features)
5. **Update `marketplace.json`** with the new version number
6. **Open a pull request** for team review
7. After merge, teammates run `copilot plugin update my-team-tools` to get the update

---

## Plugin Management Commands Reference

| Command | Description |
|---|---|
| `copilot plugin install ./path` | Install from local path |
| `copilot plugin install owner/repo` | Install from GitHub repo |
| `copilot plugin install name@marketplace` | Install from marketplace |
| `copilot plugin list` | List installed plugins |
| `copilot plugin update NAME` | Update a plugin |
| `copilot plugin update --all` | Update all plugins |
| `copilot plugin uninstall NAME` | Remove a plugin |
| `copilot plugin disable NAME` | Temporarily disable |
| `copilot plugin enable NAME` | Re-enable a plugin |
| `copilot plugin marketplace add OWNER/REPO` | Register a marketplace |
| `copilot plugin marketplace list` | List registered marketplaces |
| `copilot plugin marketplace browse NAME` | Browse a marketplace |
| `copilot plugin marketplace remove NAME` | Unregister a marketplace |

---

## Where Plugins Are Stored

| Type | Location |
|---|---|
| Installed from marketplace | `~/.copilot/state/installed-plugins/MARKETPLACE/PLUGIN-NAME/` |
| Installed directly | `~/.copilot/state/installed-plugins/PLUGIN-NAME/` |
| Marketplace cache | `~/.copilot/state/marketplace-cache/` |

---

## Further Reading

- [Creating a plugin](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating)
- [Finding and installing plugins](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing)
- [Creating a marketplace](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-marketplace)
- [Plugin reference](https://docs.github.com/en/copilot/reference/cli-plugin-reference)
- [Example: github/awesome-copilot](https://github.com/github/awesome-copilot)
- [Example: github/copilot-plugins](https://github.com/github/copilot-plugins)
