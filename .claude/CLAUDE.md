# Git Commit/PR

Use the commit-pr skill when committing changes or making PRs.

# Github file access

If you're given a raw github blob url to access and you get a 404 response,
use the `gh` cli to access it (it's likely a private repo).

# Writing reports

When writing an HTML report, deep dive, or technical writeup, use the
`report-styling` skill as the design/style guide.

# Comment each step of an orchestrating method

A method whose body is a sequence of steps (a controller's `Reconcile()`, a
startup `run()`) gets a brief one-line comment above each step saying what it
achieves, even when the called function's name says much the same, so the whole
flow reads top to bottom without opening each step.

# GitHub replies

Never reply to people on GitHub (PR/issue comments, review threads). Don't draft
responses, and don't suggest replies for me to post.

# Client data

Never paste client data, credentials or secrets into prompts, reports or any
external service. Flag it if a task would require that.
