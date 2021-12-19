class CoreSettings {
  static final String appName = 'Steel Mandi';
  static final double iconSize = 24.0;

  /// SideBar Width
  double sideBarWidth = 50.0;

  /// Footer Bottom Navigation Height
  double bottomNavHeight = 25.0;

  /// Product Appbar Size
  double fromTop = 55.0;

  double selectedMarketSize = 150.0;
  double buySellRequestDialogWidth = 300.0;
  double keyPadDialogSize = 250.0;
  double sidebarDrawerWidth = 300.0;
  double bottomNavDialogSize = 250.0;

  int maxAppbarLength = 4;

  CoreSettings(
      {this.maxAppbarLength = 4,
      this.bottomNavHeight = 25.0,
      this.sidebarDrawerWidth = 300.0,
      this.fromTop = 55.0,
      this.selectedMarketSize = 150.0,
      this.sideBarWidth = 50.0,
      this.buySellRequestDialogWidth = 300.0,
      this.bottomNavDialogSize = 250.0,
      this.keyPadDialogSize = 250.0});
}
