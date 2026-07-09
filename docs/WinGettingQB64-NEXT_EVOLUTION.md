# 📄 `WinGettingQB64 - NEXT_EVOLUTION.md`

### *From QB64 Winget Client → Unified Command System*

# Next Evolution — Unified Command System

This document defines the transition from isolated tools (QB64 Winget client, Systems Orchestrator UI) into a single, shared execution model.

---

## 🧠 Core Idea

Both current projects already implement the same underlying pattern:

- Select something
- Build a command
- Execute it
- Capture output
- Reflect state

This evolution formalizes that pattern into a **shared command layer**.

---

## 🧩 The Shift

### Before

| System | Behavior |
|------|--------|
| QB64 App | Hardcoded winget commands |
| Svelte Manager | UI-driven actions (not yet unified) |

---

### After

| System | Role |
|------|------|
| QB64 | Command builder + executor frontend |
| Svelte Manager | Visual orchestrator + state viewer |
| Command Layer | Shared execution model |

---

## ⚙️ The Command Object

Everything becomes a command.

### Minimal Form

```json
{
  "tool": "winget",
  "action": "install",
  "target": "Git.Git"
}
````

---

### Extended Form (Real Version)

```json
{
  "id": "winget.install.git",
  "tool": "winget",
  "action": "install",
  "target": "Git.Git",
  "args": [],
  "flags": [
    "--accept-package-agreements",
    "--accept-source-agreements"
  ],
  "execution": {
    "type": "shell",
    "command": "winget install --id \"Git.Git\" -e"
  },
  "metadata": {
    "source": "qb64",
    "timestamp": "2026-04-10T21:00:00Z"
  }
}
```

---

## 🔄 Execution Pipeline

```
Command Object
    ↓
Command Builder
    ↓
Execution (shell)
    ↓
Output File / Stream
    ↓
Parser
    ↓
Structured Result
    ↓
UI / Logs / History
```

---

## 🧱 Layer Breakdown

### 1. Command Definition Layer

Where commands live.

Formats:

* JSON (runtime)
* TOML (your preferred persistent format)

Example:

```toml
[[command]]
id = "winget.install"
tool = "winget"
action = "install"

[command.template]
cmd = "winget install --id \"{target}\" -e"
```

---

### 2. Command Builder Layer

Takes:

* user input
* UI selections

Produces:

* executable command string

---

### 3. Execution Layer

Responsible for:

* running commands
* redirecting output
* capturing logs

QB64 already does this:

```basic
SHELL _HIDE "cmd /c " + cmdLine
```

---

### 4. Output Layer

Standardize this across systems:

* `*.output.txt` (raw)
* `*.json` (parsed)
* `*.log` (timeline)

---

### 5. State Layer

This is what your Svelte system becomes:

* current system state
* recent actions
* command history
* results

---

## 🔗 Bridging Your Two Systems

### QB64 → Command Emitter

Instead of just executing:

It also writes:

```json
{
  "tool": "winget",
  "action": "install",
  "target": "Git.Git"
}
```

to:

```
/data/commands/queue.jsonl
```

---

### Svelte Manager → Command Consumer

Reads:

```
/data/commands/*.jsonl
```

Displays:

* history
* status
* results

Executes if needed.

---

## 📦 Standard File Layout (Important)

```plaintext
/data/
  commands/
    queue.jsonl
    history.jsonl

  output/
    winget_install_output.txt
    docker_output.txt

  parsed/
    winget_search.json
    docker_ps.json

  state/
    system.json
```

---

## 🔄 Example Flow (Real)

### QB64

User selects:

* NanaZip

QB64:

* builds command
* executes
* writes:

```json
{
  "tool": "winget",
  "action": "install",
  "target": "M2Team.NanaZip"
}
```

---

### Svelte Manager

* detects new command
* displays it
* shows result
* allows replay

---

## 🧠 Why This Works

Because you already:

* use files as truth
* treat CLI as data source
* think in pipelines

This formalizes that.

---

## 🚀 What This Enables

### 1. Replayable Systems

* rerun installs
* rebuild environments
* track changes

---

### 2. Multi-Frontend Control

Same system, different interfaces:

* QB64 (fast, native)
* Svelte (visual)
* CLI (raw)

---

### 3. Extensibility

Add tools without redesign:

```json
{ "tool": "docker", "action": "start", "target": "nginx" }
```

---

### 4. Full Observability

Everything becomes:

* logged
* queryable
* reproducible

---

## ⚡ Immediate Next Steps

### 1. Add Command Emission (QB64)

After install:

```basic
WriteCommandToFile SelectedPackageId
```

---

### 2. Create Command Log

Append JSON lines:

```
commands.jsonl
```

---

### 3. Add Command Preview (QB64)

Show:

```
winget install --id "Git.Git" -e
```

before execution

---

### 4. Teach Svelte to Read Commands

Start simple:

* read JSONL
* display list

---

## 🧩 Final Insight

You are no longer building:

* a winget client
* a dashboard

You are building:

> A **local command orchestration layer**

---

## 🏁 End State

Everything—Docker, Winget, Git, Scripts—becomes:

```json
{
  "tool": "...",
  "action": "...",
  "target": "..."
}
```

And every UI becomes:

> A way to create, view, and execute those objects.

```

