# Coding Standards & Guidelines

# Agent Rules

- For every change, always follow the coding structure and architecture already in place for this project.
- The lines of code in a file should not exceed 200 lines.
- Helper classes and widgets should always be placed in an individual file dedicated to that class only, and that file should live in `features/[feature]/presentation/widgets/` when it is a feature-level reusable widget.
- Test files should keep separation of concerns as well, instead of placing all tests in a single file.
- Changes should always be implemented in a way that minimizes resource consumption and prioritizes performance optimization.
- Always use `fvm flutter` instead of `flutter` when running Flutter commands.
- Every UI change involving colors or typography must be defined in and sourced from the app's general theme; never hardcode color or font overrides in widgets. All normal text must use the same theme-defined font family and normal text weight used by the transaction bottom sheet labels (such as "Revenus" and "Dépense"). This keeps widgets consistent, supports future design changes, and preserves light/dark mode behavior.
