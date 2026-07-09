# WinGettingQB64 (QB64 Winget Client)

A local-first, GUI-driven interface for `winget`, built entirely in QB64 using the InForm UI framework.

This project is not trying to replace the terminal.  
It is exploring what happens when command-line tooling is made **visible, structured, and stateful**.

---

## ✨ Overview

WinGetting is a lightweight Windows application that:

- Searches the `winget` package index
- Parses CLI output into structured UI data
- Allows package selection and queueing
- Executes installs (single or batch)
- Persists install queues for reuse

All of this is implemented in QB64 using a custom-patched UI layer.

---

## 🧠 Philosophy

This project sits at the intersection of:

- CLI tooling (`winget`)
- Structured data extraction
- Stateful UI workflows

Rather than treating commands as ephemeral text, WinGetting treats them as:

> **Selectable, queueable, repeatable operations**

---

## 🔧 Core Features

### 🔍 Search
- Executes `winget search <query>`
- Captures output to file
- Parses into structured results (Name + ID)
- Populates selectable UI list

Example parsed output:  
:contentReference[oaicite:0]{index=0}

---

### 📦 Package Selection
- Results are selectable via ListBox
- Selected package is tracked globally:
  - `SelectedPackageName`
  - `SelectedPackageId`

---

### ➕ Queue System

Packages can be added to a queue:

- Stored in arrays:
  - `QueueName()`
  - `QueueId()`
- Displayed in secondary list UI
- Persisted to file (`saved_packages.txt`)

Example saved queue:  
:contentReference[oaicite:1]{index=1}

---

### ⚙️ Install Execution

#### Single Install
```bash
winget install --id "<id>" -e --accept-package-agreements --accept-source-agreements
````

#### Queue Install

* Iterates through queue
* Executes sequential installs
* Captures output to file
* Performs success detection

Example install output:


---

### 💾 Persistence

Queues can be saved and reloaded:

* Save → writes package IDs line-by-line
* Import → restores queue state

---

### 📊 Status + Feedback System

Every action feeds into:

* Status label (UI)
* Debug log
* Notification system

Example runtime flow:


---

## 🖥️ UI Architecture

Built using:

* QB64
* InForm (GUI framework)

Core controls:

* Search TextBox (`SearchTB`)
* Search Button (`SearchBT`)
* Results List (`ListBox1`)
* Queue List (`ListBox2`)
* Action Buttons:

  * Add to Queue
  * Install Selected
  * Install Queue
  * Save Queue

Control wiring example:


---

## 🎨 UI Rendering (Custom Work)

Default InForm UI was overridden to support:

* Flat design
* Custom colors
* Removal of legacy gradients

Key patches:

* Custom button renderer (`__UI_DrawButton`)
* Custom menu bar renderer (`__UI_DrawMenuBar`)

References:



---

## ⚠️ Important Behaviors

### Blocking Execution

All installs use:

```basic
SHELL _HIDE "cmd /c ..."
```

This is synchronous and blocks the UI thread.

Implication:

* Long installs can freeze the UI temporarily

---

### Output Parsing Strategy

Instead of direct API usage:

* CLI output → file
* File → parsed line-by-line
* Parsed → structured arrays

This keeps the system:

* transparent
* debuggable
* reproducible

---

## 🧪 Current State

Working:

* Search
* Parsing
* Selection
* Queueing
* Install (single + batch)
* Save/Load queue

In progress:

* UI responsiveness under load
* Improved parsing edge cases
* Import flexibility

---

## 🚀 Direction

This project is evolving toward:

* Command abstraction layer
* Structured execution model
* Multi-frontend compatibility

Future potential:

* Command preview generation
* Action history
* Integration with external systems

---

## 📜 License

MIT

````

---

