part of 'navigation_page.dart';

extension _NavigationPageLayout on _NavigatorPageState {
  Widget _buildContent(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final hintColor = Theme.of(context).hintColor;
    final showFab = _isFabTab(currentIndex);
    final isFabVisible = showFab && _isFabVisibleForTab(currentIndex);

    return Scaffold(
      extendBody: false,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) =>
            _onScrollNotification(notification, currentIndex),
        child: widget.navigationShell,
      ),
      floatingActionButton: AnimatedScale(
        scale: isFabVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: SizedBox(
          width: 48,
          height: 48,
          child: FloatingActionButton(
            onPressed: isFabVisible ? () => _onFabPressed(currentIndex) : null,
            backgroundColor: Theme.of(context).primaryColor,
            shape: const CircleBorder(),
            child: Icon(
              Icons.add,
              color: AppIconForeground.resolve(
                context,
                Colors.black,
                background: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.15)
                  : const Color.fromARGB(54, 48, 50, 55),
            ),
          ),
        ),
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: 9.6,
          bottom: MediaQuery.of(context).padding.bottom + 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_NavigatorPageState._tabs.length, (i) {
            final tab = _NavigatorPageState._tabs[i];
            final isActive = currentIndex == i;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => widget.navigationShell.goBranch(i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: FaIcon(
                        isActive ? tab.selectedIcon : tab.unselectedIcon,
                        key: ValueKey('${tab.label}-$isActive'),
                        size: 17.2,
                        color: AppIconForeground.resolve(
                          context,
                          (isActive ? textColor : hintColor) ??
                              Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      tab.label,
                      style: AppTextStyle(AppTextRole.body,
                          color: isActive ? textColor : hintColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
