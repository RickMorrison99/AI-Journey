# Automated Metrics — CI/CD Pipeline & GitHub Telemetry

> *"The best measurement system is one that is mostly invisible — it collects the data while team members do their actual work, and only surfaces when something needs attention."*
> — O&A AI Adoption Journey Framework

---

## Why Automated Collection Matters

Self-reporting is essential for SPACE-S (Satisfaction) and SPACE-E (Efficiency/Flow), but it has a structural limitation: **recall bias.** Team Members completing a sprint form on Friday afternoon are reconstructing their experience from memory. Deployment frequency, lead time, and change failure rate measured by self-report drift significantly from ground truth — Forsgren's DORA research found median self-reported deployment frequency was roughly 2× the actual measured rate.

Automated telemetry solves this for the metrics that can be observed from system behaviour:

| Measurement Layer | Automated? | Source |
|---|---|---|
| DORA — Deployment Frequency | ✅ Yes | GitHub Actions / deployment events |
| DORA — Lead Time for Changes | ✅ Yes | GitHub API (commit → PR merge timestamps) |
| DORA — Change Failure Rate | ✅ Yes | GitHub labels + PR analysis |
| DORA — MTTR | ✅ Yes | GitHub Issues label timestamps |
| SPACE-A — AI Activity | ✅ Yes | GitHub Copilot Business/Enterprise API |
| SPACE-P — Code quality signals | ✅ Yes | SAST, coverage, CI pass rate |
| SPACE-S — Satisfaction | ❌ No | Self-report only |
| SPACE-E — Flow & efficiency | ❌ No | Self-report only |
| SPACE-C — Collaboration | ⚠️ Partial | PR review patterns (proxy only) |

**The governing principle:** Automate everything that can be automated. Keep self-reporting focused on the human experience that automated systems cannot observe. Do not try to infer satisfaction or flow from activity metrics — that is the most common and most damaging mistake in developer productivity measurement.

---

## GitHub Metrics Collection

All scripts in this section require:
- `pip install PyGithub python-dateutil` 
- A GitHub Personal Access Token or GitHub App token with `repo` and `read:org` scopes
- Environment variable `GITHUB_TOKEN` set

```bash
export GITHUB_TOKEN="ghp_your_token_here"
export GITHUB_ORG="your-org"
export GITHUB_REPO="your-noa-repo"
```

---

### Deployment Frequency

**What counts as a "deployment" for O&A?**

The DORA definition requires a deployment to a production or staging environment — not just a merge to main. For the O&A team, a deployment event is triggered by any of the following:

| Deployment Type | Trigger Event | Counting Unit |
|---|---|---|
| NSO service package deploy | GitHub Actions workflow `deploy-nso-package` completes successfully | 1 deployment |
| Ansible playbook tagged release | Git tag matching `ansible/v*` pushed and CI passes | 1 deployment |
| YANG module package publish | Workflow `publish-yang-package` succeeds; artifact published to internal registry | 1 deployment |
| NETCONF/RESTCONF API version bump | PR merged to main where `openapi.yaml` or `yang/` directory changed | 1 deployment |
| IaC change (Terraform/Nornir) | Workflow `terraform-apply` or `nornir-deploy` succeeds against staging/prod | 1 deployment |

**What does not count:** A branch merge to main where no deployment workflow ran. A draft PR. A merge that triggered CI failure.

#### GitHub Actions: Emitting a Deployment Event

Add this step to the end of each deployment workflow to register a GitHub Deployment object. The GitHub Deployments API is the authoritative source for the deployment frequency calculation.

```yaml
# .github/workflows/deploy-nso-package.yml
# Add this job at the end of your existing deployment workflow.

name: Deploy NSO Service Package

on:
  push:
    branches: [main]
    paths:
      - 'packages/**'
      - 'yang/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # --- your existing build and deploy steps here ---

      - name: Record GitHub Deployment (success)
        if: success()
        uses: chrnorm/deployment-action@v2
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          environment: production
          description: "NSO package deploy — ${{ github.sha }}"
          auto-merge: false
          required-contexts: ""

      - name: Record GitHub Deployment (failure)
        if: failure()
        uses: chrnorm/deployment-action@v2
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          environment: production
          description: "NSO package deploy FAILED — ${{ github.sha }}"
          state: failure
          auto-merge: false
          required-contexts: ""
```

For teams not using the GitHub Deployments API, a minimal alternative is to append a row to a `metrics/deployments.csv` file committed to a dedicated metrics repository:

```yaml
      - name: Append deployment record to metrics CSV
        if: success()
        run: |
          TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
          REPO="${{ github.repository }}"
          SHA="${{ github.sha }}"
          WORKFLOW="${{ github.workflow }}"
          echo "${TIMESTAMP},${REPO},${SHA},${WORKFLOW},success" \
            >> metrics/deployments.csv
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add metrics/deployments.csv
          git commit -m "chore: record deployment ${SHA:0:7}"
          git push
```

#### Querying Deployment Frequency

```python
# scripts/dora_deployment_frequency.py
"""
Calculates DORA Deployment Frequency from GitHub Deployments API.
Returns deployments per week (team total) and per team member per week.
"""

import os
import sys
from datetime import datetime, timezone, timedelta
from github import Github

GITHUB_TOKEN = os.environ["GITHUB_TOKEN"]
REPO_NAME = os.environ.get("GITHUB_REPO", "your-org/noa-automation")
TEAM_SIZE = int(os.environ.get("O&A_TEAM_SIZE", "15"))
LOOKBACK_DAYS = int(os.environ.get("LOOKBACK_DAYS", "90"))


def get_deployment_frequency(repo_name: str, lookback_days: int, team_size: int) -> dict:
    g = Github(GITHUB_TOKEN)
    repo = g.get_repo(repo_name)

    cutoff = datetime.now(timezone.utc) - timedelta(days=lookback_days)
    deployments = [
        d for d in repo.get_deployments()
        if d.created_at.replace(tzinfo=timezone.utc) >= cutoff
        and any(
            s.state == "success"
            for s in d.get_statuses()
        )
    ]

    total = len(deployments)
    weeks = lookback_days / 7
    per_week = total / weeks if weeks > 0 else 0
    per_engineer_per_week = per_week / team_size if team_size > 0 else 0

    # DORA band classification
    if per_week >= 7:
        band = "Elite (multiple per day)"
    elif per_week >= 1:
        band = "High (between once per day and once per week)"
    elif per_week >= (1 / 4):
        band = "Medium (between once per week and once per month)"
    else:
        band = "Low (less than once per month)"

    return {
        "period_days": lookback_days,
        "total_successful_deployments": total,
        "deployments_per_week": round(per_week, 2),
        "deployments_per_engineer_per_week": round(per_engineer_per_week, 3),
        "dora_band": band,
    }


if __name__ == "__main__":
    result = get_deployment_frequency(REPO_NAME, LOOKBACK_DAYS, TEAM_SIZE)
    print("\n=== DORA: Deployment Frequency ===")
    for k, v in result.items():
        print(f"  {k}: {v}")
```

---

### Lead Time for Changes

**Definition for O&A:** The elapsed time from the first commit on a feature/fix branch to the moment that branch's PR is merged to `main` or `master`. This measures the full development and review cycle — it is not limited to CI/CD run time.

**What to exclude:** Draft PRs; PRs merged to non-main branches (e.g., release branches); automated dependency update PRs (e.g., Dependabot/Renovate).

```python
# scripts/dora_lead_time.py
"""
Calculates DORA Lead Time for Changes from GitHub PR and commit data.
Lead time = time from first commit on branch to PR merge timestamp.
"""

import os
import csv
import sys
from datetime import datetime, timezone, timedelta
from github import Github

GITHUB_TOKEN = os.environ["GITHUB_TOKEN"]
REPO_NAME = os.environ.get("GITHUB_REPO", "your-org/noa-automation")
LOOKBACK_DAYS = int(os.environ.get("LOOKBACK_DAYS", "90"))
OUTPUT_CSV = os.environ.get("OUTPUT_CSV", "metrics/lead_time.csv")

# PR authors to exclude (bots, automated processes)
EXCLUDED_AUTHORS = {"dependabot[bot]", "renovate[bot]", "github-actions[bot]"}


def get_first_commit_time(pr) -> datetime | None:
    """Return the earliest commit timestamp on this PR's branch."""
    commits = list(pr.get_commits())
    if not commits:
        return None
    timestamps = [
        c.commit.author.date.replace(tzinfo=timezone.utc)
        for c in commits
        if c.commit.author and c.commit.author.date
    ]
    return min(timestamps) if timestamps else None


def calculate_lead_times(repo_name: str, lookback_days: int) -> list[dict]:
    g = Github(GITHUB_TOKEN)
    repo = g.get_repo(repo_name)

    cutoff = datetime.now(timezone.utc) - timedelta(days=lookback_days)
    results = []

    for pr in repo.get_pulls(state="closed", base="main", sort="updated", direction="desc"):
        if pr.merged_at is None:
            continue
        merged_at = pr.merged_at.replace(tzinfo=timezone.utc)
        if merged_at < cutoff:
            break  # PRs are sorted by updated desc; once past cutoff, stop
        if pr.draft:
            continue
        if pr.user.login in EXCLUDED_AUTHORS:
            continue

        first_commit = get_first_commit_time(pr)
        if first_commit is None:
            continue

        lead_time_hours = (merged_at - first_commit).total_seconds() / 3600

        results.append({
            "pr_number": pr.number,
            "pr_title": pr.title,
            "author": pr.user.login,
            "first_commit_at": first_commit.isoformat(),
            "merged_at": merged_at.isoformat(),
            "lead_time_hours": round(lead_time_hours, 2),
            "lead_time_days": round(lead_time_hours / 24, 2),
        })

    return results


def dora_band(median_hours: float) -> str:
    if median_hours < 1:
        return "Elite (< 1 hour)"
    elif median_hours < 24:
        return "High (1 hour – 1 day)"
    elif median_hours < 24 * 7:
        return "Medium (1 day – 1 week)"
    else:
        return "Low (> 1 week)"


if __name__ == "__main__":
    records = calculate_lead_times(REPO_NAME, LOOKBACK_DAYS)

    if not records:
        print("No merged PRs found in the specified period.")
        sys.exit(0)

    hours = sorted(r["lead_time_hours"] for r in records)
    median_hours = hours[len(hours) // 2]
    mean_hours = sum(hours) / len(hours)

    print(f"\n=== DORA: Lead Time for Changes ({LOOKBACK_DAYS} days) ===")
    print(f"  PRs analysed:        {len(records)}")
    print(f"  Median lead time:    {median_hours:.1f} hours ({median_hours/24:.1f} days)")
    print(f"  Mean lead time:      {mean_hours:.1f} hours ({mean_hours/24:.1f} days)")
    print(f"  DORA band:           {dora_band(median_hours)}")

    os.makedirs(os.path.dirname(OUTPUT_CSV), exist_ok=True)
    with open(OUTPUT_CSV, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=records[0].keys())
        writer.writeheader()
        writer.writerows(records)
    print(f"  Detail written to:   {OUTPUT_CSV}")
```

---

### Change Failure Rate

**Definition for O&A:** The percentage of PRs merged to `main` in a given period that are subsequently identified as a contributing cause of an incident, service degradation, or failed deployment. Operationalised via GitHub PR labels.

**Required GitHub label convention** — add these labels to your O&A repositories:

| Label | Hex colour | Meaning |
|---|---|---|
| `incident-cause` | `#d93f0b` | This merged PR was identified as a root cause or contributing cause of a production incident |
| `hotfix` | `#e4e669` | This PR is an emergency fix for a recently deployed change |
| `rollback` | `#c5def5` | This PR reverts a previously merged change due to production issues |

A PR is a "failure" if it carries any of these labels **or** if it is merged within 24 hours of an `incident-cause` PR touching the same file paths (hotfixes are often not labelled promptly).

```python
# scripts/dora_change_failure_rate.py
"""
Calculates DORA Change Failure Rate from GitHub PR labels.
CFR = (failure PRs / total merged PRs) * 100
"""

import os
import csv
from datetime import datetime, timezone, timedelta
from github import Github

GITHUB_TOKEN = os.environ["GITHUB_TOKEN"]
REPO_NAME = os.environ.get("GITHUB_REPO", "your-org/noa-automation")
LOOKBACK_DAYS = int(os.environ.get("LOOKBACK_DAYS", "90"))
OUTPUT_CSV = os.environ.get("OUTPUT_CSV", "metrics/change_failure_rate.csv")

FAILURE_LABELS = {"incident-cause", "hotfix", "rollback"}
EXCLUDED_AUTHORS = {"dependabot[bot]", "renovate[bot]", "github-actions[bot]"}


def calculate_cfr(repo_name: str, lookback_days: int) -> dict:
    g = Github(GITHUB_TOKEN)
    repo = g.get_repo(repo_name)

    cutoff = datetime.now(timezone.utc) - timedelta(days=lookback_days)
    total_prs = 0
    failure_prs = []

    for pr in repo.get_pulls(state="closed", base="main", sort="updated", direction="desc"):
        if pr.merged_at is None:
            continue
        merged_at = pr.merged_at.replace(tzinfo=timezone.utc)
        if merged_at < cutoff:
            break
        if pr.draft or pr.user.login in EXCLUDED_AUTHORS:
            continue

        total_prs += 1
        pr_labels = {label.name for label in pr.labels}
        if pr_labels & FAILURE_LABELS:
            failure_prs.append({
                "pr_number": pr.number,
                "pr_title": pr.title,
                "merged_at": merged_at.isoformat(),
                "failure_labels": ", ".join(pr_labels & FAILURE_LABELS),
            })

    cfr = (len(failure_prs) / total_prs * 100) if total_prs > 0 else 0.0

    # DORA band (2023 report thresholds)
    if cfr <= 5:
        band = "Elite (0–5%)"
    elif cfr <= 10:
        band = "High (5–10%)"
    elif cfr <= 15:
        band = "Medium (10–15%)"
    else:
        band = "Low (> 15%)"

    return {
        "period_days": lookback_days,
        "total_merged_prs": total_prs,
        "failure_prs": len(failure_prs),
        "change_failure_rate_pct": round(cfr, 2),
        "dora_band": band,
        "failure_pr_detail": failure_prs,
    }


if __name__ == "__main__":
    result = calculate_cfr(REPO_NAME, LOOKBACK_DAYS)

    print(f"\n=== DORA: Change Failure Rate ({result['period_days']} days) ===")
    print(f"  Total merged PRs:    {result['total_merged_prs']}")
    print(f"  Failure PRs:         {result['failure_prs']}")
    print(f"  Change failure rate: {result['change_failure_rate_pct']}%")
    print(f"  DORA band:           {result['dora_band']}")

    if result["failure_pr_detail"]:
        os.makedirs(os.path.dirname(OUTPUT_CSV), exist_ok=True)
        with open(OUTPUT_CSV, "w", newline="") as f:
            writer = csv.DictWriter(f, fieldnames=result["failure_pr_detail"][0].keys())
            writer.writeheader()
            writer.writerows(result["failure_pr_detail"])
        print(f"  Failure PRs written to: {OUTPUT_CSV}")
```

---

### MTTR (Mean Time to Restore)

**Definition for O&A:** The mean elapsed time from when an incident is identified (label `incident-open` applied to a GitHub Issue) to when it is resolved (label `incident-resolved` applied to the same Issue).

**Required GitHub label convention:**

| Label | Hex colour | Applied when |
|---|---|---|
| `incident-open` | `#d93f0b` | Incident is confirmed and being investigated |
| `incident-resolved` | `#0e8a16` | Service restored to normal operation |

If the team uses PagerDuty or OpsGenie, see the note at the end of this section.

```python
# scripts/dora_mttr.py
"""
Calculates DORA MTTR from GitHub Issues using incident label timestamps.
MTTR = mean time from 'incident-open' label to 'incident-resolved' label.
"""

import os
import csv
from datetime import datetime, timezone, timedelta
from github import Github

GITHUB_TOKEN = os.environ["GITHUB_TOKEN"]
REPO_NAME = os.environ.get("GITHUB_REPO", "your-org/noa-automation")
LOOKBACK_DAYS = int(os.environ.get("LOOKBACK_DAYS", "90"))
OUTPUT_CSV = os.environ.get("OUTPUT_CSV", "metrics/mttr.csv")

OPEN_LABEL = "incident-open"
RESOLVED_LABEL = "incident-resolved"


def get_label_event_time(issue, label_name: str) -> datetime | None:
    """Return the most recent timestamp at which a label was added to this issue."""
    for event in issue.get_events():
        if event.event == "labeled" and event.label.name == label_name:
            return event.created_at.replace(tzinfo=timezone.utc)
    return None


def calculate_mttr(repo_name: str, lookback_days: int) -> dict:
    g = Github(GITHUB_TOKEN)
    repo = g.get_repo(repo_name)

    cutoff = datetime.now(timezone.utc) - timedelta(days=lookback_days)
    restore_times_hours = []
    incident_records = []

    for issue in repo.get_issues(state="closed", labels=[RESOLVED_LABEL], sort="updated", direction="desc"):
        if issue.closed_at and issue.closed_at.replace(tzinfo=timezone.utc) < cutoff:
            break

        opened_time = get_label_event_time(issue, OPEN_LABEL)
        resolved_time = get_label_event_time(issue, RESOLVED_LABEL)

        if opened_time is None or resolved_time is None:
            continue
        if resolved_time <= opened_time:
            continue

        ttrestore_hours = (resolved_time - opened_time).total_seconds() / 3600
        restore_times_hours.append(ttrestore_hours)
        incident_records.append({
            "issue_number": issue.number,
            "issue_title": issue.title,
            "incident_opened": opened_time.isoformat(),
            "incident_resolved": resolved_time.isoformat(),
            "ttrestore_hours": round(ttrestore_hours, 2),
        })

    if not restore_times_hours:
        return {"period_days": lookback_days, "incidents_analysed": 0, "mttr_hours": None, "dora_band": "Insufficient data"}

    mttr = sum(restore_times_hours) / len(restore_times_hours)

    # DORA band
    if mttr < 1:
        band = "Elite (< 1 hour)"
    elif mttr < 24:
        band = "High (1 hour – 1 day)"
    elif mttr < 24 * 7:
        band = "Medium (1 day – 1 week)"
    else:
        band = "Low (> 1 week)"

    return {
        "period_days": lookback_days,
        "incidents_analysed": len(incident_records),
        "mttr_hours": round(mttr, 2),
        "mttr_days": round(mttr / 24, 2),
        "dora_band": band,
        "incident_detail": incident_records,
    }


if __name__ == "__main__":
    result = calculate_mttr(REPO_NAME, LOOKBACK_DAYS)

    print(f"\n=== DORA: MTTR ({result['period_days']} days) ===")
    print(f"  Incidents analysed:  {result['incidents_analysed']}")
    if result["mttr_hours"] is not None:
        print(f"  Mean MTTR:           {result['mttr_hours']} hours ({result['mttr_days']} days)")
        print(f"  DORA band:           {result['dora_band']}")

        detail = result.get("incident_detail", [])
        if detail:
            os.makedirs(os.path.dirname(OUTPUT_CSV), exist_ok=True)
            with open(OUTPUT_CSV, "w", newline="") as f:
                writer = csv.DictWriter(f, fieldnames=detail[0].keys())
                writer.writeheader()
                writer.writerows(detail)
            print(f"  Detail written to:   {OUTPUT_CSV}")
```

> **PagerDuty / OpsGenie alternative:** If the O&A team uses an incident management platform, prefer its native MTTR calculation over the GitHub Issues approach. GitHub Issues timestamps are only as accurate as the labelling discipline of the team member who applies them. PagerDuty's acknowledged → resolved timestamps are system-generated and more reliable. Export the PagerDuty incidents API (`GET /incidents?statuses[]=resolved`) and compute MTTR from `acknowledged_at` → `resolved_at` per incident.

---

## GitHub Copilot Telemetry

GitHub Copilot Business and Enterprise accounts expose usage telemetry via the REST API. This covers the **SPACE-A (Activity)** dimension — specifically, how actively team members are using the tool and how much of its output is being accepted.

!!! danger "CRITICAL: Context before numbers."
    The Copilot API returns suggestion counts, acceptance rates, and lines of code accepted. These are **activity metrics only** — they measure presence and volume, not value or quality.

    **Never display Copilot activity metrics in isolation.** Every dashboard, report, or slide that shows Copilot acceptance rate must also show:

    1. A SPACE-P quality signal (SAST finding rate in AI PRs, team member-reported AI bug count)
    2. A SPACE-S satisfaction signal (mean satisfaction score from self-report)

    An team member with a 90% acceptance rate who is accepting incorrect YANG models without review is not a high performer — they are an incident waiting to happen. An team member with a 20% acceptance rate who is rigorously evaluating every suggestion and catching hallucinations is doing exactly the right thing.

    **Do not use this data in individual performance reviews.** Do not name team members alongside their acceptance rates. Aggregate to team level only.

#### Available Copilot API Metrics

| Metric | API Field | SPACE Dimension | Notes |
|---|---|---|---|
| Active users (7-day) | `total_active_users` | SPACE-A | Users who received ≥ 1 suggestion in period |
| Suggestions shown | `total_suggestions_count` | SPACE-A | Total inline completions shown |
| Suggestions accepted | `total_acceptances_count` | SPACE-A | Accepted without modification |
| Lines of code accepted | `total_lines_accepted` | SPACE-A | Proxy for volume of AI-assisted code |
| Chat turns | `total_chat_turns` (Enterprise) | SPACE-A | Copilot Chat usage |

```python
# scripts/copilot_telemetry.py
"""
Pulls GitHub Copilot usage metrics from the REST API and writes to CSV.
Requires Copilot Business or Enterprise.
Requires token with: manage_billing:copilot or read:org scope.

API reference: https://docs.github.com/en/rest/copilot/copilot-usage
"""

import os
import csv
import json
import urllib.request
import urllib.error
from datetime import datetime, timezone, timedelta

GITHUB_TOKEN = os.environ["GITHUB_TOKEN"]
GITHUB_ORG = os.environ.get("GITHUB_ORG", "your-org")
LOOKBACK_DAYS = int(os.environ.get("LOOKBACK_DAYS", "28"))
OUTPUT_CSV = os.environ.get("OUTPUT_CSV", "metrics/copilot_usage.csv")


def fetch_copilot_usage(org: str, since_days: int) -> list[dict]:
    """Fetch Copilot usage summary from GitHub API."""
    since = (datetime.now(timezone.utc) - timedelta(days=since_days)).strftime("%Y-%m-%d")
    url = f"https://api.github.com/orgs/{org}/copilot/usage?since={since}&per_page=100"

    req = urllib.request.Request(
        url,
        headers={
            "Authorization": f"Bearer {GITHUB_TOKEN}",
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28",
        },
    )

    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode())
    except urllib.error.HTTPError as e:
        print(f"HTTP {e.code}: {e.reason}")
        print("Ensure token has manage_billing:copilot or read:org scope.")
        raise


def summarise_usage(records: list[dict]) -> dict:
    """Aggregate daily records into a period summary."""
    if not records:
        return {}

    total_suggestions = sum(r.get("total_suggestions_count", 0) for r in records)
    total_accepted = sum(r.get("total_acceptances_count", 0) for r in records)
    total_lines = sum(r.get("total_lines_accepted", 0) for r in records)
    active_users = max(r.get("total_active_users", 0) for r in records)

    acceptance_rate = (total_accepted / total_suggestions * 100) if total_suggestions > 0 else 0

    return {
        "period_days": len(records),
        "total_suggestions": total_suggestions,
        "total_accepted": total_accepted,
        "total_lines_accepted": total_lines,
        "acceptance_rate_pct": round(acceptance_rate, 1),
        "peak_active_users": active_users,
    }


if __name__ == "__main__":
    records = fetch_copilot_usage(GITHUB_ORG, LOOKBACK_DAYS)

    summary = summarise_usage(records)
    print(f"\n=== GitHub Copilot Usage ({LOOKBACK_DAYS} days) ===")
    for k, v in summary.items():
        print(f"  {k}: {v}")

    print("\n  ⚠  These are SPACE-A activity metrics. Always report alongside")
    print("     SPACE-P quality signals and SPACE-S satisfaction scores.")

    if records:
        os.makedirs(os.path.dirname(OUTPUT_CSV), exist_ok=True)
        fieldnames = ["day", "total_suggestions_count", "total_acceptances_count",
                      "total_lines_accepted", "total_active_users"]
        with open(OUTPUT_CSV, "w", newline="") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
            writer.writeheader()
            writer.writerows(records)
        print(f"\n  Daily detail written to: {OUTPUT_CSV}")
```

#### Combining Copilot and DORA Metrics in a Quarterly Report

The Copilot telemetry script produces a per-day CSV. Use the following to join it with the DORA lead time output for a combined quarterly view:

```python
# scripts/quarterly_combined_report.py
"""
Joins DORA lead time data with Copilot usage data for a quarterly summary CSV.
Both input CSVs must exist (run dora_lead_time.py and copilot_telemetry.py first).
"""

import csv
import os
from datetime import datetime

LEAD_TIME_CSV = os.environ.get("LEAD_TIME_CSV", "metrics/lead_time.csv")
COPILOT_CSV = os.environ.get("COPILOT_CSV", "metrics/copilot_usage.csv")
OUTPUT_CSV = os.environ.get("OUTPUT_CSV", "metrics/quarterly_summary.csv")


def load_csv(path: str) -> list[dict]:
    with open(path, newline="") as f:
        return list(csv.DictReader(f))


def weekly_bucket(iso_timestamp: str) -> str:
    """Return the ISO week string (YYYY-Www) for a given timestamp."""
    dt = datetime.fromisoformat(iso_timestamp.rstrip("Z"))
    return dt.strftime("%G-W%V")


if __name__ == "__main__":
    prs = load_csv(LEAD_TIME_CSV)
    copilot = load_csv(COPILOT_CSV)

    # Build weekly Copilot activity totals
    weekly_copilot: dict[str, dict] = {}
    for row in copilot:
        week = weekly_bucket(row["day"])
        if week not in weekly_copilot:
            weekly_copilot[week] = {"suggestions": 0, "accepted": 0, "lines": 0}
        weekly_copilot[week]["suggestions"] += int(row.get("total_suggestions_count", 0))
        weekly_copilot[week]["accepted"] += int(row.get("total_acceptances_count", 0))
        weekly_copilot[week]["lines"] += int(row.get("total_lines_accepted", 0))

    # Annotate each PR with the Copilot activity for its merge week
    output_rows = []
    for pr in prs:
        week = weekly_bucket(pr["merged_at"])
        cw = weekly_copilot.get(week, {"suggestions": 0, "accepted": 0, "lines": 0})
        output_rows.append({
            **pr,
            "week": week,
            "copilot_suggestions_that_week": cw["suggestions"],
            "copilot_accepted_that_week": cw["accepted"],
            "copilot_lines_accepted_that_week": cw["lines"],
        })

    os.makedirs(os.path.dirname(OUTPUT_CSV), exist_ok=True)
    with open(OUTPUT_CSV, "w", newline="") as f:
        if output_rows:
            writer = csv.DictWriter(f, fieldnames=output_rows[0].keys())
            writer.writeheader()
            writer.writerows(output_rows)
    print(f"Combined quarterly report written to: {OUTPUT_CSV}")
    print(f"Rows: {len(output_rows)}")
```

---

## CI/CD Pipeline Metrics

The following metrics are collected from the O&A team's CI/CD pipeline, not from GitHub's metadata APIs. Configure your pipeline tool (GitHub Actions, Jenkins, GitLab CI) to emit these to a shared metrics store.

### pyang Validation Pass Rate

For YANG-heavy teams, the first-attempt pass rate of `pyang --strict` is a direct signal of YANG authoring quality. When AI tooling generates YANG — whether Copilot suggesting leaf definitions or an agentic workflow producing module scaffolds — this rate should trend toward 100%.

```yaml
# .github/workflows/yang-validation.yml
# Reports pyang pass/fail to the metrics CSV on every PR.

name: YANG Validation

on:
  pull_request:
    paths:
      - '**.yang'

jobs:
  validate-yang:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install pyang
        run: pip install pyang

      - name: Run pyang --strict and record result
        id: pyang
        run: |
          RESULT="pass"
          ERRORS=0
          for f in $(find . -name "*.yang" -not -path "*/vendor/*"); do
            if ! pyang --strict "$f" 2>/dev/null; then
              RESULT="fail"
              ERRORS=$((ERRORS + 1))
            fi
          done
          echo "result=${RESULT}" >> "$GITHUB_OUTPUT"
          echo "errors=${ERRORS}" >> "$GITHUB_OUTPUT"

      - name: Record validation result to metrics
        run: |
          TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
          HAS_COPILOT_LABEL="false"
          # Check if the PR has the 'ai-assisted' label (set by your Copilot usage detection)
          LABELS=$(gh pr view ${{ github.event.pull_request.number }} --json labels -q '.labels[].name' 2>/dev/null || echo "")
          echo "$LABELS" | grep -q "ai-assisted" && HAS_COPILOT_LABEL="true"
          echo "${TIMESTAMP},${{ github.event.pull_request.number }},${{ steps.pyang.outputs.result }},${{ steps.pyang.outputs.errors }},${HAS_COPILOT_LABEL}" \
            >> metrics/yang_validation.csv
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### SAST Finding Rate in AI-Assisted PRs

Track whether PRs labelled `ai-assisted` have a higher or lower SAST finding rate than the baseline. This requires:
1. A consistent PR label for AI-assisted work (`ai-assisted` — applied automatically by a Copilot usage detector or manually by the team member)
2. A SAST tool configured in your pipeline (Semgrep, Bandit, Checkov, or similar)

```yaml
# .github/workflows/sast.yml
# Runs SAST on every PR and records findings count alongside the ai-assisted label.

name: SAST Scan

on:
  pull_request:
    branches: [main]

jobs:
  sast:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install Semgrep
        run: pip install semgrep

      - name: Run Semgrep and capture finding count
        id: semgrep
        run: |
          semgrep --config=auto --json --quiet . > semgrep_results.json 2>/dev/null || true
          FINDINGS=$(python3 -c "import json,sys; d=json.load(open('semgrep_results.json')); print(len(d.get('results',[])))")
          echo "findings=${FINDINGS}" >> "$GITHUB_OUTPUT"

      - name: Record SAST result to metrics
        run: |
          TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
          LABELS=$(gh pr view ${{ github.event.pull_request.number }} --json labels -q '.labels[].name' 2>/dev/null || echo "")
          AI_PR="false"
          echo "$LABELS" | grep -q "ai-assisted" && AI_PR="true"
          echo "${TIMESTAMP},${{ github.event.pull_request.number }},${AI_PR},${{ steps.semgrep.outputs.findings }}" \
            >> metrics/sast_findings.csv
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

```python
# scripts/analyse_sast_trends.py
"""
Analyses metrics/sast_findings.csv to compare SAST finding rates
in AI-assisted vs non-AI PRs over time.
"""

import csv
from collections import defaultdict

SAST_CSV = "metrics/sast_findings.csv"
FIELDNAMES = ["timestamp", "pr_number", "ai_pr", "findings"]


def analyse_sast(path: str) -> None:
    ai_findings = []
    human_findings = []

    with open(path, newline="") as f:
        reader = csv.DictReader(f, fieldnames=FIELDNAMES)
        for row in reader:
            count = int(row["findings"])
            if row["ai_pr"].lower() == "true":
                ai_findings.append(count)
            else:
                human_findings.append(count)

    def mean(lst):
        return round(sum(lst) / len(lst), 2) if lst else 0.0

    print("\n=== SAST Finding Rate: AI vs Non-AI PRs ===")
    print(f"  AI-assisted PRs:     n={len(ai_findings):>4}  mean findings/PR = {mean(ai_findings)}")
    print(f"  Non-AI PRs:          n={len(human_findings):>4}  mean findings/PR = {mean(human_findings)}")

    if ai_findings and human_findings:
        delta = mean(ai_findings) - mean(human_findings)
        direction = "higher" if delta > 0 else "lower" if delta < 0 else "equal"
        print(f"\n  AI-assisted finding rate is {abs(delta):.2f} findings/PR {direction} than baseline.")
        if delta > 0.5:
            print("  ⚠  Consider reviewing prompt hygiene and Copilot code review practices.")
        elif delta < -0.5:
            print("  ✓  AI assistance may be improving code quality in this dimension.")


if __name__ == "__main__":
    analyse_sast(SAST_CSV)
```

### Test Coverage Delta

Collect test coverage per sprint from `pytest-cov` (Python) or `go test -cover` (Go). Track the delta — is AI-assisted code being tested at the same rate as manually written code?

```yaml
# Append to your existing test workflow
      - name: Run tests with coverage
        run: |
          pytest --cov=. --cov-report=json --cov-report=term-missing

      - name: Record coverage to metrics
        run: |
          TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
          TOTAL=$(python3 -c "import json; d=json.load(open('coverage.json')); print(d['totals']['percent_covered_display'])")
          echo "${TIMESTAMP},${{ github.event.pull_request.number }},${TOTAL}" >> metrics/test_coverage.csv
```

### Pipeline Success Rate

The percentage of CI pipeline runs that pass without manual intervention or re-run. A declining success rate while AI activity is increasing is a signal that AI-generated code is introducing more fragile or non-deterministic changes.

```python
# scripts/pipeline_success_rate.py
"""
Calculates pipeline success rate from GitHub Actions workflow run history.
"""

import os
from datetime import datetime, timezone, timedelta
from github import Github

GITHUB_TOKEN = os.environ["GITHUB_TOKEN"]
REPO_NAME = os.environ.get("GITHUB_REPO", "your-org/noa-automation")
WORKFLOW_NAME = os.environ.get("WORKFLOW_NAME", "CI")
LOOKBACK_DAYS = int(os.environ.get("LOOKBACK_DAYS", "30"))


def pipeline_success_rate(repo_name: str, workflow_name: str, lookback_days: int) -> dict:
    g = Github(GITHUB_TOKEN)
    repo = g.get_repo(repo_name)

    cutoff = datetime.now(timezone.utc) - timedelta(days=lookback_days)
    total = 0
    success = 0

    for workflow in repo.get_workflows():
        if workflow.name != workflow_name:
            continue
        for run in workflow.get_runs():
            if run.created_at.replace(tzinfo=timezone.utc) < cutoff:
                break
            if run.status != "completed":
                continue
            total += 1
            if run.conclusion == "success":
                success += 1

    rate = (success / total * 100) if total > 0 else 0
    return {
        "workflow": workflow_name,
        "period_days": lookback_days,
        "total_runs": total,
        "successful_runs": success,
        "success_rate_pct": round(rate, 1),
    }


if __name__ == "__main__":
    result = pipeline_success_rate(REPO_NAME, WORKFLOW_NAME, LOOKBACK_DAYS)
    print(f"\n=== Pipeline Success Rate: {result['workflow']} ===")
    for k, v in result.items():
        print(f"  {k}: {v}")
```

---

## SCI — Software Carbon Intensity Estimation

The [Green Software Foundation's SCI formula](https://sci-guide.greensoftware.foundation/) provides a carbon accounting framework for software systems:

```
SCI = (E × I) + M    per functional unit
```

Where:
- **E** = Energy consumed by the software (kWh)
- **I** = Grid carbon intensity (gCO₂e/kWh) — varies by region and time
- **M** = Embodied carbon of hardware used
- **Functional unit** = per team member per sprint (for AI tool usage tracking)

The O&A team does not need fine-grained telemetry to track SCI meaningfully. The Copilot usage API provides a volume proxy (suggestion count), and standard published estimates provide the per-operation energy cost.

### AI Tool Emission Estimates

These are order-of-magnitude estimates suitable for trend tracking. They are **not** precise accounting values.

| AI Tool | Estimated energy / 1000 suggestions or tokens | CO₂e at EU average grid (295 gCO₂/kWh) | Notes |
|---|---|---|---|
| GitHub Copilot (GPT-4-class) | ~0.002–0.005 kWh / 1000 suggestions | ~0.6–1.5 g CO₂e / 1000 suggestions | Inference only; excludes training amortisation |
| GPT-4o via API | ~0.001–0.003 kWh / 1000 tokens | ~0.3–0.9 g CO₂e / 1000 tokens | Use OpenAI's published energy figures when available |
| Claude 3.5 via API | ~0.001–0.002 kWh / 1000 tokens | ~0.3–0.6 g CO₂e / 1000 tokens | Anthropic does not publish per-token energy; estimate |
| Local Ollama (CPU, laptop) | ~0.0001–0.001 kWh / 1000 tokens | ~0.03–0.3 g CO₂e / 1000 tokens | Highly hardware-dependent; CPU >> GPU efficiency |
| Local Ollama (GPU, workstation) | ~0.001–0.005 kWh / 1000 tokens | ~0.3–1.5 g CO₂e / 1000 tokens | Depends on GPU TDP and batch size |

**Grid intensity by region (2024 estimates):** Norway ~25 gCO₂/kWh · France ~60 · UK ~180 · Germany ~380 · USA East ~300 · USA West ~200. Use [Electricity Maps](https://electricitymaps.com/) for current values.

### SCI Tracking Spreadsheet

Maintain a simple CSV with the following columns, updated each sprint:

| Column | Description | Example |
|---|---|---|
| `sprint` | Sprint identifier | `2025-S24` |
| `engineers_active` | Team Members who used AI tools this sprint | `12` |
| `copilot_suggestions` | Total suggestions from Copilot API | `8400` |
| `copilot_energy_kwh` | `copilot_suggestions / 1000 * 0.003` (mid estimate) | `0.025` |
| `api_tokens_used` | Total tokens via team LLM gateway (if logged) | `250000` |
| `api_energy_kwh` | `api_tokens_used / 1000 * 0.002` | `0.500` |
| `local_model_tokens` | Tokens processed by local Ollama instances | `50000` |
| `local_energy_kwh` | `local_model_tokens / 1000 * 0.0005` | `0.025` |
| `total_energy_kwh` | Sum of all energy columns | `0.550` |
| `grid_intensity_gco2_kwh` | Grid intensity for primary team location | `295` |
| `sci_gco2e_per_engineer` | `(total_energy_kwh * grid_intensity) / engineers_active` | `13.5` |
| `notes` | Any notable changes (new tool, model upgrade) | `Added Claude gateway` |

```python
# scripts/sci_calculator.py
"""
Estimates SCI (Software Carbon Intensity) for AI tool usage per sprint.
Reads Copilot telemetry CSV and combines with manual API/local usage inputs.
"""

import csv
import os

COPILOT_CSV = os.environ.get("COPILOT_CSV", "metrics/copilot_usage.csv")
GRID_INTENSITY = float(os.environ.get("GRID_INTENSITY_GCO2_KWH", "295"))  # gCO2/kWh
ENGINEERS_ACTIVE = int(os.environ.get("ENGINEERS_ACTIVE", "12"))
API_TOKENS_USED = int(os.environ.get("API_TOKENS_USED", "0"))
LOCAL_TOKENS_USED = int(os.environ.get("LOCAL_TOKENS_USED", "0"))

# Energy estimates (kWh per 1000 tokens/suggestions)
COPILOT_KWH_PER_1K = 0.003
API_KWH_PER_1K = 0.002
LOCAL_KWH_PER_1K = 0.0005


def load_copilot_suggestions(path: str) -> int:
    total = 0
    if not os.path.exists(path):
        return 0
    with open(path, newline="") as f:
        for row in csv.DictReader(f):
            total += int(row.get("total_suggestions_count", 0))
    return total


if __name__ == "__main__":
    copilot_suggestions = load_copilot_suggestions(COPILOT_CSV)

    copilot_kwh = copilot_suggestions / 1000 * COPILOT_KWH_PER_1K
    api_kwh = API_TOKENS_USED / 1000 * API_KWH_PER_1K
    local_kwh = LOCAL_TOKENS_USED / 1000 * LOCAL_KWH_PER_1K
    total_kwh = copilot_kwh + api_kwh + local_kwh

    sci = (total_kwh * GRID_INTENSITY) / ENGINEERS_ACTIVE if ENGINEERS_ACTIVE > 0 else 0

    print("\n=== SCI Estimate — AI Tool Usage ===")
    print(f"  Copilot suggestions:       {copilot_suggestions:>8,}")
    print(f"  Copilot energy:            {copilot_kwh:.4f} kWh")
    print(f"  API tokens:                {API_TOKENS_USED:>8,}")
    print(f"  API energy:                {api_kwh:.4f} kWh")
    print(f"  Local model tokens:        {LOCAL_TOKENS_USED:>8,}")
    print(f"  Local model energy:        {local_kwh:.4f} kWh")
    print(f"  Total energy:              {total_kwh:.4f} kWh")
    print(f"  Grid intensity:            {GRID_INTENSITY} gCO₂/kWh")
    print(f"  Team Members active:          {ENGINEERS_ACTIVE}")
    print(f"  SCI:                       {sci:.2f} gCO₂e / team member / sprint")

    trend_note = ""
    if LOCAL_TOKENS_USED > API_TOKENS_USED:
        trend_note = "  ✓  Local model usage exceeds API usage — favourable for SCI."
    print(trend_note)
```

**Quarterly SCI trend interpretation:**
- **Flat or improving SCI despite rising usage** → The team is adopting more efficient models (e.g., local Ollama for boilerplate tasks) or the grid is decarbonising. This is the target trajectory.
- **Rising SCI** → Usage is growing faster than efficiency gains, or the team is migrating from smaller to larger frontier models. Evaluate whether model selection is appropriate for each task.
- **Dramatic SCI spike** → Usually indicates a new agentic workflow consuming many more tokens than the manual equivalent. Evaluate cost/benefit explicitly.

---

## Metrics Dashboard Recommendation

### Option A — Simple (< 1 day to set up)

A Python script runs on a schedule (GitHub Actions cron), generates a static HTML dashboard, and publishes to GitHub Pages.

```yaml
# .github/workflows/metrics-dashboard.yml
name: Metrics Dashboard

on:
  schedule:
    - cron: '0 9 * * MON'   # Every Monday at 09:00 UTC
  workflow_dispatch:          # Also allow manual trigger

jobs:
  build-dashboard:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install dependencies
        run: pip install PyGithub python-dateutil jinja2 matplotlib

      - name: Run metrics collection
        env:
          GITHUB_TOKEN: ${{ secrets.METRICS_TOKEN }}
          GITHUB_ORG: ${{ vars.GITHUB_ORG }}
          GITHUB_REPO: ${{ vars.GITHUB_REPO }}
        run: |
          python scripts/dora_deployment_frequency.py
          python scripts/dora_lead_time.py
          python scripts/dora_change_failure_rate.py
          python scripts/dora_mttr.py
          python scripts/copilot_telemetry.py
          python scripts/sci_calculator.py

      - name: Generate static dashboard
        run: python scripts/generate_dashboard.py

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./dashboard
```

### Option B — Medium (1–2 days to set up)

Prometheus metrics are emitted by the collection scripts, scraped by a Prometheus instance, and visualised in Grafana. Use GitHub webhooks to push PR and deployment events to a lightweight FastAPI receiver that writes to Prometheus push gateway.

This approach is appropriate when the team already operates Grafana for O&A infrastructure monitoring and wants unified observability across infrastructure and development pipeline.

### Dashboard Panels — Required Views

Regardless of the approach chosen, the dashboard must display the following panels. The layout follows the measurement stack hierarchy: DORA at the top (delivery outcomes), then SPACE signals, then AI activity (context, not headline).

| Panel | Data Source | Cadence | Notes |
|---|---|---|---|
| **DORA 4-up** (Deployment Freq, Lead Time, CFR, MTTR) | GitHub API scripts | Weekly | Show current band + 12-week trend sparkline |
| **SPACE Radar** (5 dimensions) | Self-report aggregation | Per sprint | Radar / spider chart; prior quarter ghost overlay |
| **AI Active User %** | Copilot API | Weekly | Line chart; 80% target line shown |
| **SAST Finding Rate** (AI vs baseline) | CI pipeline CSV | Per sprint | Two lines: AI-labelled PRs vs all PRs |
| **SCI Trend** | SCI calculator | Per sprint | gCO₂e / team member / sprint; target = flat or declining |
| **Prompt Library Size** | Self-report + Git | Per sprint | Bar chart showing team knowledge accumulation |
| **Responsible AI Incidents** | Self-report | Per sprint | Count; any severity-2+ shown in red |

> **Dashboard anti-pattern:** Do not add an "AI acceptance rate" panel to the main dashboard without a SPACE-P panel immediately adjacent. Displaying acceptance rate alone — even with a caveat — creates an implicit performance signal that will influence behaviour. If Copilot acceptance rate is shown, it must share a panel row with the SAST finding rate and the self-reported AI bug count.

---

## Running the Full Collection Suite

```bash
# Run all DORA + Copilot + SCI scripts in sequence
# Set required environment variables first

export GITHUB_TOKEN="ghp_your_token"
export GITHUB_ORG="your-org"
export GITHUB_REPO="your-org/noa-automation"
export LOOKBACK_DAYS="90"
export O&A_TEAM_SIZE="15"
export GRID_INTENSITY_GCO2_KWH="295"

mkdir -p metrics

python scripts/dora_deployment_frequency.py
python scripts/dora_lead_time.py
python scripts/dora_change_failure_rate.py
python scripts/dora_mttr.py
python scripts/copilot_telemetry.py
python scripts/sci_calculator.py
python scripts/analyse_sast_trends.py
python scripts/quarterly_combined_report.py

echo ""
echo "All metrics collected. Review metrics/ directory."
echo "Run generate_dashboard.py to publish."
```

---

## Revision History

| Version | Date | Author | Summary of Changes |
|---|---|---|---|
| 1.0 | 2025-07 | O&A AI Champion | Initial release |
