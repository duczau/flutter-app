# first_app

A new Flutter project - Personal project to study.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


### Basic_app
    Includes:
        - Animation like spring, gravity
        - Change state, random location, show mediaquery(width, height screen)
### Quiz
    Includes:
        - Change screen by replacing,
        - Add AI promt to random question
        - Handle back route from left Drawer
### Expense_app
    Includes:
        - Card, icon, detect OS name, showModalBottomSheet , handle overlay like soft keyboard
        - Toast message, swipe card to delete(with undo button), chart from cost value
        - Dark mode, expanded, flexible, responsive, 
        - Using LayoutBuilder to get size of child component(differrent from MediaQuery)
### Todo_app
    Includes:
        - Understand how statelesswidget and statefulwidget works, split a screen with more with get using state can improve build performance, avoid unnecessary builds (like useMemo in reactjs)
        - How Flutter render: Widget tree -> Element tree -> Render tree
        - Using key in list to determine object(ValueKey, Objectkey,...)
        - Understand how object store with address , assignment vs new instance, add(), remove() method in list not change address, 
### Expense_app
    Includes:
        - global Theme, using theme in other case
        - Split app to specific folder like screen, widget, model, data, provider...
        - Gridview, Inkwell, Tab-based Navigation 
        - Route screen (scaffold to show back button - software back, back button of app, or PopScope for hard back - back button of OS, device), named screen with route name in main.dart 
        - Stack widget, lifting state up
        - Provider, StateNofifier(Nofifier in newer version), StateNotifierProvider(NotifierProvider in newer version), state management with Riverpod, combine Providers
        - In provider, when need to change state, don't use add(), revome(), instead use [...state, newElement]  or state.where(...filter with != element).toList()
        - Explicit (you control entire animation) and Implicit(flutter controls animation) animation