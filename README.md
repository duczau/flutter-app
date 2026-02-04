# first_app

A new Flutter project - Personal project to study.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Flutter & Dart - The Complete Guide](udemy: /learn-flutter-dart-to-build-ios-android-apps)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

**methods order in lifecycle statefulWidget: createState -> constructor (State) -> initState -> didChangeDependencies-> build -> (didUpdateWidget) -> (build) -> dispose**

***didChangeDependencies:*** a method run when there is any change from widget parent - InheritedWidget (wrap widget like Theme.of, MediaQuery.of(context), Localization, provider...)

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
- Understand how statelesswidget and statefulwidget works, split a screen with more with get using state can improve build performance, 
avoid unnecessary builds (like useMemo in reactjs)
- How Flutter render: Widget tree -> Element tree -> Render tree
- Using key in list to determine object(ValueKey, Objectkey,...)
- Understand how object store with address , assignment vs new instance, add(), remove() method in list not change address, 
### Meals_app
Includes:
- global Theme, using theme in other case
- Split app to specific folder like screen, widget, model, data, provider...
- Gridview, Inkwell, Tab-based Navigation 
- Route screen (scaffold to show back button - software back, back button of app, or PopScope for hard back - back button of OS, device), named screen with route name in main.dart 
- Stack widget, lifting state up

- Provider, StateNofifier(Nofifier in newer version), StateNotifierProvider(NotifierProvider in newer version), state management with Riverpod, combine Providers

- In provider, when need to change state, ```don't use add(), revome(), instead use [...state, newElement]  or state.where(...filter with != element).toList()```

```
ref.listen(favouriteMealsProvider, (previous, next) {
    print('Favorites updated: ${next.length} items');
    // Có thể gọi setState hoặc update UI tại đây
});
```

- With case save state like video playing after push next screen, and go back to play continue(same Facebook video), using: ``` extends State<VideoScreen> with RouteAware ``` and override **didPushNext** and **didPopNext** to handle . **AutomaticKeepAliveClientMixin** uses for text, form, list to cache state, should not use for Image or Video

- Explicit (you control entire animation) - use AnimationController,  and Implicit(flutter controls animation) animation - ex: AnimatedSwitcher. Typically, using Implicit animation is enough for almost case.

- Widget named Hero can improve UX animation (flying like a hero :3). 
    - Suitable for : thumbnail → full image, icon → detail header, card → detail page.
        - Rule: + Same tag in source and destination screen, (tag must be unique in same route)
            + Widget inside Hero should be the same type
            + 2 screen must be in differrent route. Hence, the following types can be used (Navigator.push, PageRouteBuilder, GoRouter / AutoRoute / Beamer / v.v.)
            + Using flightShuttleBuilder property to custom animation

### Shopping_app
Includes:
- Using Form widget with GlobalKey to use methods (validate, save, reset)
- connect to ```Firebase realtime database``` as backend service,(if using REST via http, append .json to the end of the URL, ex: abc.com/shopping-list.json)
    + POST: will auto generate id with format something like -OjcxGdUm7IMBhIcKi90
    + PUT: can define id
    - handling errors, using FutureBuilder Widget (If don't cache future, each build() will create NEW future - by using: 
        - late Future<User> _userFuture ;
        - _userFuture = fetchUser(); inside init method -> FutureBuilder -> future: _userFuture (instead of future: fetchUser()))

### Favourite places app
Includes:
- Using image_picker lib - neeed add config key to */ios/Runner/Info.plist* file (following lib docs - This permission will not be requested if you always pass false for requestFullMetadata, but App Store policy requires including the plist entry.)
- Getting current location (with some related configuration to permission settings), using Google Maps API with SDK 
- Sqflite to store data in database (store in app folder) - Applies to mobile only. Using hive instead of sqflite (with web platform, hive saves data in indexed db)
- Hive stores data on RAM after load, neeed to re-init connection to get latest data

### Chat app
Includes:
- Using Firebase notifications to send message to specific user
- Using Firebase Authentication to sign in and sign out
- StreamBuilder to listen to Firebase Authentication changes,( like FutureBuilder, but it's stream)