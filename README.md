# OM Analyzer

A static, JSON-driven web app for browsing university exam question papers, filtering questions, and viewing syllabus topic frequency — all without any backend or framework.

---

## Table of Contents

1. [Opening the App](#1-opening-the-app)
2. [File Structure](#2-file-structure)
3. [Setting Up a New Analyzer](#3-setting-up-a-new-analyzer)
4. [JSON Formats](#4-json-formats)
   - [App.json](#41-appjson--app-settings)
   - [old_question_papers.json](#42-old_question_papersjson--question-bank)
   - [syllabus.json](#43-syllabusjson--syllabus-with-frequency)
5. [Overview Stats Configuration](#5-overview-stats-configuration)
6. [Tips & Notes](#6-tips--notes)

---

## 1. Opening the App

The app uses `fetch()` to load JSON files, so it **cannot be opened by double-clicking** `index.html` directly (browsers block local file access). You need a local server.

### Option A — Python (recommended, no install needed)

```bash
# Navigate to your project folder
cd path/to/om-analyzer

# Start a local server
python -m http.server 8000

# Open in browser
http://localhost:8000
```

### Option B — Node.js / npx

```bash
npx serve .
```

### Option C — VS Code Live Server

1. Install the **Live Server** extension in VS Code
2. Right-click `index.html` → **Open with Live Server**

> **Note:** The port number does not matter. Just make sure `index.html` and all `.json` files are in the same folder.

---

## 2. File Structure

A complete project folder looks like this:

```
om-analyzer/
│
├── index.html                  ← The app (do not rename)
├── App.json                    ← App settings, overview config
│
├── old_question_papers.json    ← Question bank data
├── syllabus.json               ← Syllabus with frequency data
│
└── pu-logo.png                 ← Optional logo (referenced in App.json)
```

> The filenames of the JSON data files are **not fixed** — they are configured inside `App.json` under the `content` array. You can name them anything you want.

---

## 3. Setting Up a New Analyzer

To create an analyzer for a different course or university, follow these steps:

### Step 1 — Copy the template files

```
new-course/
├── index.html          ← copy as-is, no changes needed
├── App.json            ← edit this for your course
├── questions.json      ← your question bank (name it anything)
└── syllabus.json       ← your syllabus (name it anything)
```

### Step 2 — Edit `App.json`

Update the metadata fields for your course:

```json
{
    "app_name": "Thermodynamics Analyzer",
    "university": "Tribhuvan University",
    "program": "BE — Mechanical Engineering",
    "course": "Engineering Thermodynamics",
    "course_code": "ME 501",
    "accent_color": "#B5451B",
    "content": [
        { "file": "questions.json", "type": "questions" },
        { "file": "syllabus.json",  "type": "syllabus"  }
    ]
}
```

### Step 3 — Add your question papers

Collect old exam papers (PDFs, scans, or text). For each paper, create an entry in `questions.json` following the format in [Section 4.2](#42-old_question_papersjson--question-bank).

### Step 4 — Add your syllabus

Fill in `syllabus.json` with units and topics from the official course syllabus, plus frequency counts from the question bank. See [Section 4.3](#43-syllabusjson--syllabus-with-frequency).

### Step 5 — Run and verify

```bash
cd new-course
python -m http.server 8000
```

Open `http://localhost:8000` — the app should show your course name, questions, and syllabus.

---

## 4. JSON Formats

### 4.1 `App.json` — App Settings

This is the single source of truth. The entire app UI adapts to what you put here.

```json
{
    "app_name":      "OM Analyzer",
    "app_ic":        "pu-logo.png",
    "university":    "Pokhara University",
    "program":       "BE — Computer Engineering",
    "course":        "Organization & Management",
    "course_code":   "2-0-0",
    "theme":         "light",
    "accent_color":  "#2B5EA7",

    "tab_labels": {
        "questions": "Questions",
        "papers":    "Papers",
        "syllabus":  "Syllabus"
    },

    "overview": [
        { "label": "Papers",          "value": "auto:papers"    },
        { "label": "Questions",       "value": "auto:questions" },
        { "label": "Chapters",        "value": "auto:chapters"  },
        { "label": "Syllabus Topics", "value": "auto:topics"    },
        { "label": "Peak Repeats",    "value": "auto:peak"      },
        { "label": "Year Span",       "value": "auto:yearspan"  }
    ],

    "content": [
        {
            "file": "old_question_papers.json",
            "name": "Old Question Papers",
            "type": "questions"
        },
        {
            "file": "syllabus.json",
            "name": "Syllabus with Frequency",
            "type": "syllabus"
        }
    ]
}
```

#### Field Reference

| Field | Type | Description |
|---|---|---|
| `app_name` | string | Shown in header and browser tab |
| `app_ic` | string | Path to logo image (optional) |
| `university` | string | Shown in header subtitle |
| `program` | string | Shown in header subtitle |
| `course` | string | Shown in header badge |
| `course_code` | string | Shown in header badge |
| `accent_color` | hex string | Changes highlight color across the app |
| `tab_labels` | object | Rename any of the three tabs |
| `overview` | array | Stats bar configuration (see Section 5) |
| `content` | array | List of JSON data files to load |

#### `content` item fields

| Field | Value | Description |
|---|---|---|
| `file` | filename | Path to the JSON file |
| `type` | `"questions"` or `"syllabus"` | Tells the app how to parse this file |
| `name` | string | Optional display name (not currently shown in UI) |

---

### 4.2 `old_question_papers.json` — Question Bank

Contains all exam papers. Each paper has a list of questions.

#### Full format

```json
{
    "papers": [
        {
            "id":       "2024_fall",
            "year":     "2024",
            "semester": "Fall",
            "questions": [

                {
                    "number": "1",
                    "sub_no": "a",
                    "marks":  "7",
                    "question": "What do you mean by management? Explain the functions of management."
                },

                {
                    "number": "1",
                    "sub_no": "b",
                    "marks":  "8",
                    "question": "What is Line and Staff organization? What are the advantages and disadvantages?"
                },

                {
                    "number": "7",
                    "instruction": "Write short notes on: (Any two)",
                    "marks":       "10",
                    "options": [
                        { "sub_no": "a", "marks": "5", "question": "Employee health and safety" },
                        { "sub_no": "b", "marks": "5", "question": "Job description" },
                        { "sub_no": "c", "marks": "5", "question": "Incentives" }
                    ]
                }

            ]
        }
    ]
}
```

#### Question types

There are two types of question entries:

**Type 1 — Regular question** (Q1a, Q1b, Q2a, etc.)

```json
{
    "number":   "3",
    "sub_no":   "b",
    "marks":    "8",
    "question": "Define human resource management and describe its key functions."
}
```

| Field | Type | Description |
|---|---|---|
| `number` | string | Question number (`"1"` through `"6"`) |
| `sub_no` | string | Sub-part: `"a"`, `"b"`, or `"or"` for alternate questions |
| `marks` | string | Full marks for this sub-question |
| `question` | string | Full question text |

**Type 2 — Short notes / choice question** (usually Q7)

```json
{
    "number":      "7",
    "instruction": "Write short notes on: (Any two)",
    "marks":       "10",
    "options": [
        { "sub_no": "a", "marks": "5", "question": "Arbitration in conflict management" },
        { "sub_no": "b", "marks": "5", "question": "Job description and specification" },
        { "sub_no": "c", "marks": "5", "question": "Leader vs. Manager" }
    ]
}
```

| Field | Type | Description |
|---|---|---|
| `number` | string | Question number (usually `"7"`) |
| `instruction` | string | Instruction shown as section header |
| `marks` | string | Total marks for this question block |
| `options` | array | List of option items |
| `options[].sub_no` | string | Option label: `"a"`, `"b"`, `"c"` |
| `options[].marks` | string | Marks for this option |
| `options[].question` | string | Topic or question text |

#### OR questions (alternate)

When a question has an alternate, use `sub_no: "or"`:

```json
{
    "number":   "1",
    "sub_no":   "a",
    "marks":    "7",
    "question": "What do you mean by management? Explain the functions of management."
},
{
    "number":   "1",
    "sub_no":   "or",
    "marks":    "7",
    "question": "What is organization? Explain the principles of organization."
}
```

#### Paper `id` naming convention

Use `year_semester` in lowercase:

```
2024_fall
2024_spring
2023_fall
2023_spring
```

---

### 4.3 `syllabus.json` — Syllabus with Frequency

Contains the course structure, units, topics, and how many times each topic appeared in past papers.

#### Full format

```json
{
    "course_title": "Organization and Management",
    "course_code":  "2-0-0",
    "total_hours":  31,

    "course_contents": [
        {
            "unit":   1,
            "title":  "Introduction",
            "hours":  2,
            "topics": [
                {
                    "topic":     "1.1 Meaning and concept of management",
                    "frequency": 20
                },
                {
                    "topic":     "1.2 Functions of management",
                    "frequency": 15
                },
                {
                    "topic":     "1.3 Scope and application of management",
                    "frequency": 2
                }
            ]
        },
        {
            "unit":   2,
            "title":  "Organization",
            "hours":  4,
            "topics": [
                {
                    "topic":     "2.1 Meaning and concept of organization",
                    "frequency": 7
                },
                {
                    "topic":     "2.4 Formal and informal organizations",
                    "frequency": 13
                }
            ]
        }
    ],

    "references": [
        "Harold Koontz and Heinz Weihrich, Essentials of Management",
        "Govinda Ram Agrawal, Organization and Management in Nepal"
    ]
}
```

#### Field Reference

| Field | Type | Description |
|---|---|---|
| `course_title` | string | Full course name |
| `course_code` | string | Credit hours code (e.g. `"2-0-0"`) |
| `total_hours` | number | Total lecture hours |
| `course_contents` | array | List of units |
| `unit` | number | Unit number |
| `title` | string | Unit title |
| `hours` | number | Hours allocated to this unit |
| `topics` | array | List of topics in this unit |
| `topic` | string | Topic name (include numbering like `1.1`, `2.3`) |
| `frequency` | number | Times this topic appeared in past papers |
| `references` | array | Recommended books (optional) |

#### How frequency is visualized

The app automatically classifies each topic based on percentage relative to the highest frequency:

| Percentage | Color | Label |
|---|---|---|
| ≥ 60% of max | Green | High |
| ≥ 30% of max | Amber | Mid |
| < 30% of max | Red | Low |

> Example: if the highest frequency topic appeared in 20 papers, a topic with frequency 12 is 60% → **High**.

---

## 5. Overview Stats Configuration

The stats bar at the top of the Questions tab is configured in `App.json` under `"overview"`.

Each item is: `{ "label": "...", "value": "..." }`

### Auto-computed values

Use `"auto:key"` to pull a value calculated from your loaded data:

| Value token | What it shows |
|---|---|
| `"auto:papers"` | Total number of exam papers |
| `"auto:questions"` | Total number of questions (all papers combined) |
| `"auto:chapters"` | Number of units in the syllabus |
| `"auto:topics"` | Total topic count across all units |
| `"auto:peak"` | Most repeated question (e.g. `15×`) |
| `"auto:yearspan"` | Year range (e.g. `2014–2025`) |
| `"auto:semesters"` | Available semesters (e.g. `Fall / Spring`) |

### Static values

Just write any string as the value — it will be shown as-is:

```json
{ "label": "University", "value": "Pokhara University" },
{ "label": "Credits",    "value": "3" },
{ "label": "Pass Marks", "value": "45" }
```

### Customizing the grid

Add or remove items from `overview[]` — the grid adjusts its column count automatically. Remove the `"overview"` key entirely to hide the stats bar.

```json
"overview": [
    { "label": "Papers",    "value": "auto:papers"    },
    { "label": "Questions", "value": "auto:questions" },
    { "label": "Year Span", "value": "auto:yearspan"  }
]
```

---

## 6. Tips & Notes

### Adding a new year's paper

1. Open `old_question_papers.json`
2. Add a new object at the top of the `"papers"` array:

```json
{
    "id":       "2025_fall",
    "year":     "2025",
    "semester": "Fall",
    "questions": [ ... ]
}
```

3. Save — the app picks it up on next page load.

### Updating syllabus frequency

When you add a new paper, re-count each topic's appearances:

- `frequency` = number of **papers** (not questions) in which the topic was directly asked
- Count once per paper even if asked multiple times in the same paper

### Changing the accent color

Edit `accent_color` in `App.json`. Use any valid hex code:

```json
"accent_color": "#B5451B"
```

The color propagates to tabs, dropdowns, question badges, and focus states.

### Renaming tabs

```json
"tab_labels": {
    "questions": "Q Bank",
    "papers":    "Past Papers",
    "syllabus":  "Chapters"
}
```

### Using without syllabus

If you only have a question bank and no syllabus, simply remove the syllabus entry from `content[]`. The Syllabus tab will not appear:

```json
"content": [
    { "file": "questions.json", "type": "questions" }
]
```

### Browser compatibility

Works in all modern browsers (Chrome, Firefox, Edge, Safari). No build step, no npm, no dependencies — just HTML, CSS, and vanilla JS.

---

*Built for Pokhara University — BE Computer Engineering · Organization & Management*