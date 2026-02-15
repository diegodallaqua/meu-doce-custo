# Meu Doce Custo

**Meu Doce Custo** is a mobile solution designed to professionalize the financial management of confectioners and small dessert businesses, turning the complexity of ingredient costing into a practical and efficient experience. Built with a focus on improving profit margins, the app enables detailed ingredient and price registration and automatically calculates the **real cost of each recipe**.

Technically, the project uses **Flutter** to deliver a modern and intuitive interface, combined with the robustness and scalability of a **Parse Server** backend. This combination ensures smooth navigation and allows entrepreneurs to focus on what really matters: production and business growth. More than a simple utility, Meu Doce Custo is a strategic tool for those seeking strict cost control and greater financial predictability in the food and beverage sector.

---

## Project Goal

More than a utility, Meu Doce Custo is a strategic tool for professionals who want rigorous cost control and better financial predictability in the food and beverage sector, so they can focus on what matters most: producing and growing their business.

---

## Features

### Recipes
- Create and edit recipes
- Assign a **recipe category**
- Select **ingredients used** and their quantities
- Automatically calculate the **total recipe cost** based on ingredients

### Ingredients
- Create and list ingredients
- Define:
    - Ingredient name
    - Size/unit (e.g., grams, ml, unit)
    - Ingredient price
- Use ingredients in recipes with proportional cost calculation by quantity

### Recipe Categories
- Select categories via modal dialog during recipe creation/editing

### Brands
- Create and list brands to help organize ingredients

### Authentication
- Login screen
- Session verification flow (logged verify)
- User registration

---

## Tech Stack

- **Flutter (Dart)** — Mobile application
- **MobX** — State management (reactive stores)
- **GetIt** — Dependency injection
- **Parse Server / Back4App** — Backend

---

## Requirements

- **Flutter SDK** installed
- Environment configured for:
    - Android (Android Studio + SDK)
- A configured app on **Back4App/Parse Server**

---

## Getting Started

### 1) Clone the repository
```bash
git clone https://github.com/diegodallaqua/meu-doce-custo
cd meu-doce-custo
```
### 2) Install dependencies
```bash
flutter pub get
```
### 3) Generate MobX files (*.g.dart)
```bash
dart run build_runner watch --delete-conflicting-outputs
```
### 4) Run on Android
Connect a device or start an emulator and run:
```bash
flutter run
```

---

## Parse / Back4App Configuration

This is a personal project, so the Parse credentials are kept directly in the codebase.

- Locate the configuration file:
  - `lib/core/global/back4app.dart`

If you want to point the app to a different Parse Server / Back4App app, update the following values in that file:
- `applicationId`
- `clientKey`
- `serverUrl`

---

## Project Structure

This repository follows a **feature-first** structure to keep each module self-contained and easier to maintain:

- `lib/app/`  
  App bootstrap and dependency injection.

- `lib/core/`  
  Shared building blocks used across features (theme/colors, UI components, utilities, Parse setup).

- `lib/features/`  
  Business modules separated by feature. Each feature can contain its own:
  - `models/`
  - `repositories/`
  - `stores/`
    - `widgets/`
  - `screens/`
  - `dialogs/` (when feature-specific)

Example:
- `lib/features/recipe/` contains everything related to recipes (screens, stores, repositories, dialogs, etc.)
