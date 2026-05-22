# 🪙 Saku — Personal Finance Tracker

> Record. Monitor. Save. All in your pocket.

Saku is a minimalist personal finance tracker designed for Indonesian users, featuring a clean and elegant **black & white iOS-style** interface.

---

## ✨ Features

- 📊 **Dashboard** — Summary of balance, income, and expenses this month
- ➕ **Add Transaction** — Quick input with category, date, and notes
- 📋 **Transaction History** — Filter by date or category
- 📈 **Monthly Report** — Chart and breakdown of expenses per category
- 💰 **Rupiah Format** — Auto-formatted IDR (Rp 1.250.000)

---

## 🎨 Design

- **Style:** Minimalist Black & White, iOS Human Interface Guidelines
- **Typography:** SF Pro (iOS system font)
- **Colors:** `#000000` · `#FFFFFF` · shades of gray
- **Components:** Native iOS — large title nav bar, bottom tab bar, modal sheet, grouped list
- **Screen Size:** 390 × 844px (iPhone 14)
- **Theme:** Light & Dark mode

---

## 🖼️ App Icon

| Attribute | Detail |
|---|---|
| **Name** | Saku |
| **Concept** | Shirt pocket with a small coin peeking out |
| **Style** | Minimalist geometric, iOS rounded square |
| **Color** | Black & White only |
| **Size** | 1024 × 1024px (App Store ready) |

---

## 🛠️ Tech Stack (Planned)

```
Frontend   : Flutter
Database   : SQLite / Core Data (local)
State      : Riverpod
Currency   : IDR (Rupiah) — dot as thousand separator
```

---

## 📱 Screens

```
├── 🏠 Home (Dashboard)
│   ├── Total Balance
│   ├── Income vs Expenses
│   └── Recent Transactions
│
├── ➕ Add Transaction (Modal Sheet)
│   ├── Amount (Rupiah)
│   ├── Category
│   ├── Date
│   └── Notes
│
├── 📋 History
│   ├── Filter by Date
│   ├── Filter by Category
│   └── Transaction List
│
└── 📊 Report
    ├── Monthly Chart
    └── Category Breakdown
```

---

## 🗂️ Transaction Categories

| Icon | Category |
|---|---|
| 🍽️ | Food & Drinks |
| 🚗 | Transportation |
| 🛍️ | Shopping |
| 🏥 | Health |
| 🎮 | Entertainment |
| 📚 | Education |
| 🏠 | Household |
| 💼 | Salary / Income |
| 📦 | Others |

---

## 📐 Design Prompt (Google Stitch)

```
Design a personal finance tracker mobile app UI with a strict minimalist 
black and white design. No colors — only pure black (#000000), 
white (#FFFFFF), and shades of gray.

App name: Saku
App icon: minimalist black & white illustration of a shirt pocket 
with a small coin peeking out. Clean, geometric, iOS-style icon 
with rounded square frame (Apple icon grid). No color, only black 
and white. Bold and simple enough to be recognizable at 60x60px size.

Screens: Dashboard, Add Transaction, Transaction History, Monthly Report.

Strictly follow Apple iOS Human Interface Guidelines (HIG).
Use SF Pro as the primary typeface.
iOS-style large title navigation bar, bottom tab bar (4 tabs),
modal sheets, grouped list style, segmented controls.
Mobile screen size: 390x844px (iPhone 14).
Indonesian Rupiah format: Rp 1.250.000 (dot as thousand separator).
Income in black, expenses in dark gray.
No gradients, no color accents — pure monochrome only.

Also include a dark mode variant following iOS dark mode specs:
background #000000, cards #1C1C1E, text #FFFFFF,
secondary text #8E8E93 — all in monochrome.

Design style inspired by: Apple Wallet, Apple Notes, and Notion — 
clean, editorial, premium iOS feel.

Show all screens in one artboard side by side, with connecting arrows 
indicating user flow navigation.
```

> *"Healthy finances start with organized records."* 🪙
