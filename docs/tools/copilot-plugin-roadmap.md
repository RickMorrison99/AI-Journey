# GitHub Copilot CLI Plugin Roadmap

A step-by-step guide building a real plugin — `team-devops` — from a bare skeleton to a fully-featured team plugin.

---

## Overview

| Stage | What's Added | Complexity |
|-------|-------------|------------|
| [Stage 1](#stage-1-skeleton) | `plugin.json` only | ⭐ |
| [Stage 2](#stage-2-single-skill) | One skill | ⭐⭐ |
| [Stage 3](#stage-3-multi-skill) | Multiple skills | ⭐⭐ |
| [Stage 4](#stage-4-custom-agent) | Custom agent | ⭐⭐⭐ |
| [Stage 5](#stage-5-hooks) | Hooks + scripts | ⭐⭐⭐ |
| [Stage 6](#stage-6-complex-plugin) | MCP server + full integration | ⭐⭐⭐⭐ |

---

## Stage 1: Skeleton

The minimum viable plugin. Useful for learning the install/distribute flow before adding functionality.

### Structure

```
team-devops/
└── plugin.json
```

### Files

**`plugin.json`**
```json
{
  "name": "team-devops",
  "description": "DevOps tooling for our engineering team",
  "version": "0.1.0",
  "author": {
    "name": "Platform Team",
    "email": "platform@example.com"
  },
  "license": "MIT"
}
```

### Install and Verify

```bash
copilot plugin install ./team-devops
copilot plugin list
# Output: team-devops  0.1.0  ...
```

**What you learn:** The install/uninstall cycle, how plugins are listed, where they're stored (`~/.copilot/state/installed-plugins/team-devops/`).

---

## Stage 2: Single Skill

Add one practical skill the whole team can use immediately.

### Structure

```
team-devops/
├── plugin.json
└── skills/
    └── pre-commit/
        └── SKILL.md
```

### Files

**`plugin.json`** (updated)
```json
{
  "name": "team-devops",
  "description": "DevOps tooling for our engineering team",
  "version": "0.2.0",
  "author": {
    "name": "Platform Team",
    "email": "platform@example.com"
  },
  "license": "MIT",
  "skills": "skills/"
}
```

**`skills/pre-commit/SKILL.md`**
```markdown
---
name: pre-commit
description: Run a pre-commit checklist before committing code. Use this when asked to verify, check, or prepare code for committing.
---

Before the user commits code, verify the following steps in order:

1. **Run tests** — execute the project's test suite. If tests fail, stop and report failures.
2. **Check for linting errors** — run the project linter. Report any errors.
3. **Check for secrets** — scan for hardcoded API keys, passwords, or tokens. Flag anything suspicious.
4. **Review diff** — summarize what's being committed so the user can confirm the scope.

If all checks pass, confirm with a short summary: "✅ Ready to commit."
If anything fails, list each failure clearly and suggest next steps.
```

### Use It

```bash
copilot plugin install ./team-devops
```

In a Copilot session:
```
Use the /pre-commit skill before I commit
```
Or Copilot will automatically invoke it when the context matches (e.g., "check my code before I commit").

---

## Stage 3: Multi-Skill Plugin

Add a family of related skills that cover a complete workflow.

### Structure

```
team-devops/
├── plugin.json
└── skills/
    ├── pre-commit/
    │   └── SKILL.md
    ├── pr-description/
    │   └── SKILL.md
    └── incident-response/
        └── SKILL.md
```

### New Files

**`skills/pr-description/SKILL.md`**
```markdown
---
name: pr-description
description: Generate a pull request description from recent commits and diff. Use this when asked to write, draft, or generate a PR description.
---

Generate a clear pull request description using the following structure:

## Summary
A 2–3 sentence explanation of what this PR does and why.

## Changes
A bullet-point list of the key changes made.

## Testing
How the changes were tested. List specific tests added or commands run.

## Notes
Any context reviewers should know: breaking changes, dependencies, deployment steps.

To generate this:
1. Inspect recent commits (`git log --oneline -20`) to understand the scope.
2. Review the diff (`git diff main`) to identify specific changes.
3. Fill in all four sections using the information gathered.
```

**`skills/incident-response/SKILL.md`**
```markdown
---
name: incident-response
description: Guide through an incident response process. Use this when the word "incident" is used, or when asked to debug a production issue, outage, or P0/P1.
---

When responding to a production incident:

### 1. Triage
- Identify the symptoms and affected systems.
- Estimate user impact (# affected users, which regions).
- Assign severity: P0 (total outage), P1 (major degradation), P2 (minor).

### 2. Mitigation First
- If a known fix exists, apply it. Don't investigate before stabilizing.
- Consider a rollback if a recent deployment is suspected.

### 3. Investigate
- Check recent deployments and config changes.
- Review error logs and monitoring dashboards.
- Trace the failure to a root cause.

### 4. Resolution
- Apply the permanent fix and verify it resolves the issue.
- Monitor for at least 10 minutes after fix.

### 5. Post-Incident
- Write a brief post-mortem: timeline, root cause, fix, and prevention steps.

Always communicate status updates to the team throughout.
```

**`plugin.json`** (version bump only)
```json
{
  "name": "team-devops",
  "version": "0.3.0",
  ...
}
```

---

## Stage 4: Custom Agent

Add a specialist agent that Copilot can delegate work to automatically.

### Structure

```
team-devops/
├── plugin.json
├── agents/
│   └── ci-debugger.agent.md
└── skills/
    ├── pre-commit/SKILL.md
    ├── pr-description/SKILL.md
    └── incident-response/SKILL.md
```

### New Files

**`agents/ci-debugger.agent.md`**
```markdown
---
name: ci-debugger
description: Debugs failing CI/CD pipelines on GitHub Actions. Use this agent when asked to debug, fix, or investigate a failing CI run, workflow, or GitHub Actions job.
tools: ["bash", "view", "grep", "glob"]
infer: true
---

You are a CI/CD expert specializing in GitHub Actions.

When debugging a failing pipeline:

1. Use the GitHub MCP server's `list_workflow_runs` tool to find recent failing runs for the current repository.
2. Use `summarize_job_log_failures` to get an AI summary of what failed without filling context with raw logs.
3. If needed, use `get_job_logs` for the detailed failure output.
4. Identify the root cause: failing tests, misconfigured secrets, wrong Node/Python version, missing dependency, etc.
5. Propose a specific fix with the exact file changes needed.
6. After applying the fix, explain how to verify it: which command to run locally, or what the next CI run should show.

Be specific. Never say "check the logs" — you've already read them.
```

### How It Works

With `infer: true`, Copilot will **automatically** delegate to this agent when you say:
```
Why is my CI failing on the main branch?
```
Or you can explicitly invoke it:
```
Use the ci-debugger agent to look at the last failed workflow run
```

**`plugin.json`** (updated to declare agents path)
```json
{
  "name": "team-devops",
  "description": "DevOps tooling for our engineering team",
  "version": "0.4.0",
  "author": { "name": "Platform Team", "email": "platform@example.com" },
  "license": "MIT",
  "agents": "agents/",
  "skills": "skills/"
}
```

---

## Stage 5: Hooks + Scripts

Add lifecycle automation: log sessions, enforce guardrails, run validation scripts.

### Structure

```
team-devops/
├── plugin.json
├── agents/
│   └── ci-debugger.agent.md
├── skills/
│   ├── pre-commit/SKILL.md
│   ├── pr-description/SKILL.md
│   └── incident-response/SKILL.md
├── hooks.json
└── scripts/
    ├── session-log.sh
    └── block-protected-paths.sh
```

### New Files

**`hooks.json`**
```json
{
  "version": 1,
  "hooks": {
    "sessionStart": [
      {
        "type": "command",
        "bash": "./scripts/session-log.sh start",
        "timeoutSec": 5
      }
    ],
    "sessionEnd": [
      {
        "type": "command",
        "bash": "./scripts/session-log.sh end",
        "timeoutSec": 5
      }
    ],
    "preToolUse": [
      {
        "type": "command",
        "bash": "./scripts/block-protected-paths.sh",
        "timeoutSec": 10
      }
    ]
  }
}
```

**`scripts/session-log.sh`**
```bash
#!/bin/bash
# Logs Copilot session start/end to a team audit file
LOG_FILE="${HOME}/.copilot/sessions.log"
EVENT="${1:-unknown}"
echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ${EVENT} | user=$(whoami) | cwd=$(pwd)" >> "${LOG_FILE}"
```

**`scripts/block-protected-paths.sh`**
```bash
#!/bin/bash
# Reads preToolUse JSON from stdin and blocks edits to protected paths
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.toolName // empty')
ARGS=$(echo "$INPUT" | jq -r '.toolArgs // empty')

# Block edits to infra/ and .github/workflows/ without a ticket reference
if [[ "$TOOL" == "edit" ]]; then
  if echo "$ARGS" | grep -qE '"path".*/(infra|\.github/workflows)/'; then
    PROMPT=$(echo "$INPUT" | jq -r '.context.userPrompt // empty')
    if ! echo "$PROMPT" | grep -qiE '(JIRA|TICKET|[A-Z]+-[0-9]+)'; then
      echo '{"decision":"block","reason":"Edits to infra/ or .github/workflows/ require a ticket reference (e.g., ENG-1234) in your prompt."}' | jq -c .
      exit 0
    fi
  fi
fi
```

Make scripts executable:
```bash
chmod +x scripts/session-log.sh scripts/block-protected-paths.sh
```

**`plugin.json`** (updated)
```json
{
  "name": "team-devops",
  "description": "DevOps tooling for our engineering team",
  "version": "0.5.0",
  "author": { "name": "Platform Team", "email": "platform@example.com" },
  "license": "MIT",
  "agents": "agents/",
  "skills": "skills/",
  "hooks": "hooks.json"
}
```

---

## Stage 6: Complex Plugin

Add an MCP server for internal tooling, integrate everything, and set up the team marketplace.

### Structure

```
team-devops/
├── plugin.json
├── agents/
│   ├── ci-debugger.agent.md
│   └── release-manager.agent.md    # New
├── skills/
│   ├── pre-commit/SKILL.md
│   ├── pr-description/SKILL.md
│   ├── incident-response/SKILL.md
│   └── release-notes/              # New
│       └── SKILL.md
├── hooks.json
├── .mcp.json                        # New
└── scripts/
    ├── session-log.sh
    ├── block-protected-paths.sh
    └── validate-release.sh          # New
```

### New Files

**`.mcp.json`** — connects Copilot to internal tooling
```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@your-org/jira-mcp-server"],
      "env": {
        "JIRA_HOST": "${JIRA_HOST}",
        "JIRA_TOKEN": "${JIRA_TOKEN}"
      }
    },
    "pagerduty": {
      "command": "npx",
      "args": ["-y", "@your-org/pagerduty-mcp-server"],
      "env": {
        "PD_TOKEN": "${PAGERDUTY_TOKEN}"
      }
    }
  }
}
```

**`agents/release-manager.agent.md`**
```markdown
---
name: release-manager
description: Manages the release process end-to-end. Use when asked to cut a release, prepare a release, or create a release branch.
tools: ["bash", "view", "edit", "glob", "grep"]
---

You manage software releases. When asked to prepare a release:

1. Determine the next version number using semver based on commits since the last tag.
2. Validate that CI is green on the main branch.
3. Generate release notes using the /release-notes skill.
4. Create a release branch (`release/vX.Y.Z`) from main.
5. Update the version in `package.json`, `pyproject.toml`, or equivalent.
6. Commit the version bump with message: `chore: bump version to vX.Y.Z`.
7. Open a PR for the release branch with the generated release notes as the description.
8. After PR merge, create a git tag and push it.

Use the Jira MCP server to link the release to the relevant epic if a JIRA_RELEASE_EPIC env var is set.
```

**`skills/release-notes/SKILL.md`**
```markdown
---
name: release-notes
description: Generate release notes from commits and PRs since the last release tag. Use when asked to write release notes or create a changelog entry.
---

Generate release notes in this format:

## vX.Y.Z — YYYY-MM-DD

### Features
- Brief description of new feature (PR #N)

### Bug Fixes
- Brief description of bug fix (PR #N)

### Breaking Changes
- Description of any breaking change and migration steps

### Internal
- Dependency updates, refactors, and other non-user-facing changes

To generate this:
1. Find the last release tag: `git describe --tags --abbrev=0`
2. List commits since then: `git log LAST_TAG..HEAD --oneline`
3. Categorize each commit by type (feat/fix/chore/breaking) using conventional commit prefixes.
4. Group and format into the sections above.
5. Link each item to its PR where the commit references one.
```

**`scripts/validate-release.sh`**
```bash
#!/bin/bash
# Called by preToolUse hook during releases to validate the release environment
set -euo pipefail

# Ensure we're on a release branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ ! "$BRANCH" =~ ^release/ ]]; then
  echo "Warning: Not on a release branch (current: $BRANCH)" >&2
fi

# Ensure working directory is clean
if ! git diff --quiet; then
  echo '{"decision":"block","reason":"Working directory has uncommitted changes. Commit or stash them before proceeding with the release."}' | jq -c .
  exit 0
fi

echo "Release environment validated." >&2
```

**`plugin.json`** — final version
```json
{
  "name": "team-devops",
  "description": "DevOps tooling for our engineering team — CI debugging, PR workflows, incident response, and release management",
  "version": "1.0.0",
  "author": {
    "name": "Platform Team",
    "email": "platform@example.com",
    "url": "https://github.com/your-org/copilot-plugins"
  },
  "homepage": "https://github.com/your-org/copilot-plugins",
  "repository": "https://github.com/your-org/copilot-plugins",
  "license": "MIT",
  "keywords": ["devops", "ci", "release", "incident", "github-actions"],
  "category": "DevOps",
  "agents": "agents/",
  "skills": "skills/",
  "hooks": "hooks.json",
  "mcpServers": ".mcp.json"
}
```

---

## Setting Up the Team Marketplace

Host all of this in a GitHub repo so the team can install and update with one command.

### Repository Layout

```
your-org/copilot-plugins/        ← GitHub repo
├── .github/
│   └── plugin/
│       └── marketplace.json
└── plugins/
    └── team-devops/             ← Everything from above
        ├── plugin.json
        ├── agents/
        ├── skills/
        ├── hooks.json
        ├── .mcp.json
        └── scripts/
```

**`.github/plugin/marketplace.json`**
```json
{
  "name": "team-plugins",
  "owner": {
    "name": "Your Organization",
    "email": "platform@example.com"
  },
  "metadata": {
    "description": "Internal Copilot plugins for our engineering team",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "team-devops",
      "description": "CI debugging, PR workflows, incident response, and release management",
      "version": "1.0.0",
      "source": "./plugins/team-devops",
      "category": "DevOps",
      "keywords": ["devops", "ci", "release", "incident"]
    }
  ]
}
```

### Team Onboarding (One-Time)

```bash
# Register the marketplace
copilot plugin marketplace add your-org/copilot-plugins

# Install the plugin
copilot plugin install team-devops@team-plugins
```

### Staying Up to Date

```bash
copilot plugin update team-devops
# or update everything at once:
copilot plugin update --all
```

---

## What Each Stage Unlocks

| Stage | New Copilot Capabilities |
|-------|--------------------------|
| 1 – Skeleton | Plugin install/update/uninstall flow |
| 2 – Single Skill | `pre-commit` checklist on demand |
| 3 – Multi-Skill | PR drafting, incident response workflows |
| 4 – Custom Agent | Auto-delegated CI debugging with specialist context |
| 5 – Hooks | Session audit logs, protected path guardrails |
| 6 – Complex Plugin | Release automation, Jira + PagerDuty integration |

---

## Contribution Guide

1. Clone the repo and create a branch: `git checkout -b add-my-skill`
2. Add/modify plugin components
3. Test locally: `copilot plugin install ./plugins/team-devops`
4. Bump `version` in `plugin.json` and `marketplace.json`
5. Open a PR — describe what the skill/agent/hook does and include a sample prompt that triggers it
6. After merge: `copilot plugin update team-devops`
