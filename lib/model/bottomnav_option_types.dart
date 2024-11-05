enum BottomNavOptionTypes {
  home(0),
  history(1);

  const BottomNavOptionTypes(this.selectedIndex);

  final int selectedIndex;

  static BottomNavOptionTypes fromIndex(int index) {
    switch (index) {
      case 0:
        return BottomNavOptionTypes.home;
      case 1:
        return BottomNavOptionTypes.history;
      default:
        return BottomNavOptionTypes.home;
    }
  }
}