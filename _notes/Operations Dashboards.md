---
permalink:
description: Explore the development and comparison of two operations dashboards built using Claude and Codex. Discover which implementation offers a more user-friendly experience for novices and delve into the detailed feedback and judgments provided by each AI model.
title: "Comparing AI-Driven Operations Dashboards: Claude vs. Codex"
image:
published: "true"
sitemap: "true"
excerpt_separator: <!--more-->
category:
tags:
layout: note
date: 2026-05-12 11:35:30
last_modified_at: 2026-05-12 11:35:38
---


{% if page.image %} <img src="{{ page.image }}" alt=""> {% endif %}

I used Claude and Codex to build two different implementations of an ops dashboard. I gave them the same prompt and same source files and Claude created the winner. What's so fascinating is that from a different approach, Claude got more. 

Claude asked more questions than Codex. Claude also took the approach of creating a way for someone to create this on their own with help, whereas Codex took the approach of making a build guide that you would just hand off to the LLM of choice. 

I had them each check the other's work in a new session with out the context, and they gave feedback about how easy it would be for a novice to add to their own system. 

Then, they each judged the other's work (in a fresh context session), and these are their judgments: 

## Codex Response
```
Verdict: /ops-dashboard is more user friendly for a novice to set up themselves.

  It is an actual runnable project: it has package.json, source files, migrations,
  wrangler.toml.example, package scripts, and a concrete quick start in ops-
  dashboard/README.md:37. Its full setup guide is numbered from “what you’ll need”
  through deploy, custom domain, seeding examples, and smoke testing in ops-
  dashboard/docs/cloudflare-setup.md:1. I also ran npm run typecheck there and it
  passes.

  /dashops is better described as a specification/build guide, not a novice-ready
  app. Its README says it is for a developer or LLM coding agent to “build the
  dashboard from scratch” in dashops/README.md:3, and the setup section assumes
  many external prerequisites before an agent can proceed in dashops/
  README.md:446. It also has no root package.json, so a novice cannot just install
  and run it.

  The caveat: ops-dashboard still is not beginner-simple. Cloudflare Access, D1,
  KV, Queues, R2, secrets, domains, and migrations are a lot for a true novice.
  But it gives them a working codebase plus a 30-45 minute walkthrough. dashops
  asks them to create the working codebase first, which is a much higher bar.
```

## Claude's Response
```
Verdict: ops-dashboard is significantly more user-friendly for a novice.

  The two repos are doing fundamentally different things, and that's the core of
  the answer:

  ops-dashboard/ — a working app you clone and deploy

  - README quick start is 6 commands. Clone → install → copy config → migrate →
  set 2 secrets → deploy.
  - A docs/cloudflare-setup.md "30–45 minutes, zero to deployed" walkthrough that
  holds your hand through Wrangler login, replacing placeholders in wrangler.toml,
   creating each Cloudflare resource in order, etc.
  - Real code already exists: src/, migrations/, three example scripts in
  scripts/, a wrangler.toml.example, an .claude/skills/ops-add-script/ skill that
  walks an LLM through adding new automations.
  - Topic-focused docs: architecture.md, api-keys.md (where to get keys for
  HubSpot, Resend, GitHub, Stripe…), services-without-apis.md, gotchas.md.
  - A novice can have a deployed dashboard without ever reading the architecture
  doc.

  dashops/ — a build guide for an LLM to construct the app from scratch

  - The README is 1,247 lines of specification: "Build a Cloudflare Workers
  application with…", "Recommended module structure…", "Why D1…", "Pitfalls…"
  - No src/. No migrations. Just examples/ (a sample schema, a sample
  wrangler.toml, a sample CI yaml) and a scripts/scan-secrets.sh.
  - The "Quick start" assumes you'll hand the whole thing to an LLM coding agent
  and have it generate the application. A novice has to (a) get an LLM coding
  agent working, (b) trust its output, (c) debug whatever it produces, (d) then
  face all the same Cloudflare setup tasks.
  - Excellent reference material — terrible first-touch experience.

  One sentence each

  - ops-dashboard: "Here's the app. Run these commands."
  - dashops: "Here's a 1,200-line specification. Have an AI build the app, then
  run those commands."

  For a novice, ops-dashboard wins on every dimension that matters:
  time-to-first-success, error surface, ability to revert if something breaks, and
   the existence of a "Start here" doc that doesn't require an LLM in the loop.
```

Both these dashboards are available as open source on my github. 
- [DashOps: Sanitized Cloudflare ops dashboard build guide](https://github.com/jethrojones/dashops)
- [Ops-Dashboard: Self-hosted ops console on Cloudflare Workers. Schedule and run automations, manage encrypted API keys, get failure emails, and let an LLM patch broken scripts via paste-back PRs.](https://github.com/jethrojones/ops-dashboard)
