class AppMetrics {
  AppMetrics._();
  static final AppMetrics instance = AppMetrics._();

  double appBarHeight = 0.0; // default kToolbarHeight
  double statusBarHeight = 0.0;

  void setHeights({required double appBar, required double statusBar}) {
    appBarHeight = appBar;
    statusBarHeight = statusBar;
  }

  double get totalTopHeight => appBarHeight + statusBarHeight;
}