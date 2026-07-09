# WinGettingQB64 — Architecture & Execution Model

This document describes how the QB64 Winget client actually works under the hood.

---

## 🧩 Core Pattern

The entire system is built around a simple loop:

````

User Input → CLI Execution → File Output → Parse → UI State

```

---

## 🔄 Execution Flow

### 1. Search

```

DoSearch()
→ winget search "<query>"
→ output → winget_search_output.txt
→ parse lines
→ populate ResultName() / ResultId()
→ update UI

```

---

### 2. Selection

```

ListBox1 selection
→ SyncSelectedPackageFromList()
→ sets:
SelectedPackageName
SelectedPackageId

```

---

### 3. Queueing

```

AddToQueue()
→ append to QueueName() / QueueId()
→ update ListBox2

```

---

### 4. Install (Single)

```

InstallSelectedPackage()
→ build command string
→ SHELL execution
→ output → file
→ success detection

```

---

### 5. Install (Queue)

```

InstallQueue()
→ loop through QueueId()
→ execute sequential installs
→ reset queue

````

---

## 🧠 Data Model

### Search Results

```basic
ResultName(1 TO 2000)
ResultId(1 TO 2000)
ResultCount
````

---

### Queue

```basic
QueueName(1 TO 2000)
QueueId(1 TO 2000)
QueueCount
```

---

### Selected State

```basic
SelectedPackageName
SelectedPackageId
```

---

## 📁 File-Based IPC

Instead of pipes or APIs:

* Output redirected to files
* Files parsed after execution

### Advantages

* Transparent
* Debuggable
* Persistent
* Replayable

### Tradeoffs

* Slower than direct piping
* Requires parsing logic

---

## 🧪 Parsing Strategy

Search output is normalized by:

* collapsing multi-space columns
* converting to tab-delimited format
* extracting first two fields

Function:

```
TryParseWingetSearchLine()
```

---

## ⚙️ Command Construction

All installs follow a consistent pattern:

```
winget install --id "<id>" -e --accept-package-agreements --accept-source-agreements
```

Output redirected:

```
> winget_install_output.txt 2>&1
```

---

## 🔍 Success Detection

Install success is inferred by scanning output file:

```
InstallLooksSuccessful()
```

Pattern match:

* looks for "SUCCESSFULLY" in output

---

## 🖥️ UI Event Model

Driven by InForm events:

* `__UI_Click`
* `__UI_KeyPress`
* `__UI_ValueChanged`

Example:

```basic
CASE SearchBT
    DoSearch
```

---

## 🎨 Rendering Layer

Default UI rendering was replaced:

### Button Renderer

* Removed sprite sheet dependency
* Replaced with flat drawing primitives

### Menu Renderer

* Fixed hardcoded background issues
* Enabled theme consistency

---

## ⚠️ Constraints

### 1. Single-threaded runtime

* QB64 runs UI + logic on same thread
* Long operations block rendering

---

### 2. CLI dependency

* Requires `winget` installed
* Depends on CLI output format stability

---

### 3. Memory constraints

* Fixed-size arrays (2000 entries)
* Manual management required

---

## 🔮 Future Architecture Direction

This system is already approaching a more general model:

### Command Object (Future)

```json
{
  "tool": "winget",
  "action": "install",
  "id": "Git.Git",
  "flags": ["--silent"]
}
```

---

### Multi-Frontend Potential

This QB64 client could become:

* one interface
* feeding into a larger system (e.g., orchestrator)

---

## 🧩 Key Insight

This is not just a GUI wrapper.

It is:

> A structured execution layer built on top of CLI tools.

---

## 🏁 Summary

The system works because it:

* treats CLI output as data
* stores state explicitly
* separates execution from presentation

That makes it:

* understandable
* extensible
* composable

```
