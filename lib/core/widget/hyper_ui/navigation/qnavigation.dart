import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

class NavigationMenu {
  NavigationMenu({
    required this.label,
    required this.icon,
    this.count = 0,
    this.subItems = const [],
    this.badgeCount = 0,
    this.badgeLabel = '',
    this.badgeColor,
    this.view,
    this.type,
  });
  final String label;
  final IconData icon;
  final int count;
  final List<NavigationMenu> subItems;
  final int badgeCount;
  final String badgeLabel;
  final Color? badgeColor;
  final Widget? view;
  final String? type;
}

enum QNavigationMode {
  nav0,
  nav1,
  nav2,
  nav3,
  docked,
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Widget view;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.view,
  });
}

class QNavigation extends StatefulWidget {
  const QNavigation({
    required this.menus,
    super.key,
    this.initialIndex = 0,
    this.mode = QNavigationMode.nav0,
    this.headers = const [],
  });
  final List<NavigationMenu> menus;
  final QNavigationMode mode;
  final int initialIndex;
  final List<Widget> headers;

  @override
  State<QNavigation> createState() => QNavigationState();
}

class QNavigationState extends State<QNavigation> {
  static late QNavigationState instance;
  int selectedIndex = 0;
  Map<int, bool> expandedItems = {};
  int? selectedSubIndex;

  void updateIndex(int newIndex) {
    selectedIndex = newIndex;
    selectedSubIndex = null;
    setState(() {});
  }

  void updateSubIndex(int parentIndex, int subIndex) {
    selectedIndex = parentIndex;
    selectedSubIndex = subIndex;
    setState(() {});
  }

  void toggleExpand(int index) {
    setState(() {
      expandedItems[index] = !(expandedItems[index] ?? false);
    });
  }

  @override
  void initState() {
    super.initState();
    instance = this;
    selectedIndex = widget.initialIndex;
    //by default add all to expandedItems
    for (int i = 0; i < widget.menus.length; i++) {
      expandedItems[i] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    instance = this;

    bool isTabletOrDesktop = MediaQuery.of(context).size.width >= 600;

    if (isTabletOrDesktop) {
      return Scaffold(
        body: Row(
          children: [
            Container(
              width: 240, // Adjust the width to fit the label and icon
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: spMd,
              ),
              child: ListView(
                children: [
                  ...widget.headers,
                  ...widget.menus.expand((item) {
                    int index = widget.menus.indexOf(item);
                    bool isExpanded = expandedItems[index] ?? false;
                    bool isSelected =
                        selectedIndex == index && selectedSubIndex == null;
                    return [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: spXxs,
                          horizontal: spSm,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: item.subItems.isNotEmpty
                              ? () => toggleExpand(index)
                              : () => updateIndex(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  item.icon,
                                  size: 16, // Reduce the icon size
                                  color: isSelected ? Colors.white : null,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : null,
                                    ),
                                  ),
                                ),
                                if (item.badgeCount > 0)
                                  Container(
                                    padding: EdgeInsets.all(spXxs),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? Colors.white
                                          : item.badgeColor ?? infoColor,
                                    ),
                                    child: Text(
                                      item.badgeCount.toString(),
                                      style: TextStyle(
                                        color: isSelected
                                            ? item.badgeColor
                                            : Colors.white,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                if (item.badgeLabel.isNotEmpty)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: spXs,
                                      vertical: spXxs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          : (item.badgeColor ?? infoColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item.badgeLabel,
                                      style: TextStyle(
                                        color: isSelected
                                            ? item.badgeColor
                                            : Colors.white,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                if (item.subItems.isNotEmpty)
                                  Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: isSelected ? Colors.white : null,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isExpanded)
                        ...item.subItems.map((subItem) {
                          int subIndex = item.subItems.indexOf(subItem);
                          bool isSubSelected = selectedIndex == index &&
                              selectedSubIndex == subIndex;
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: spSm,
                              horizontal: spSm,
                            ),
                            decoration: BoxDecoration(
                              color: isSubSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () => updateSubIndex(index, subIndex),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.circle_outlined,
                                    size: 12, // Reduce the icon size
                                    color: isSubSelected ? Colors.white : null,
                                  ),
                                  SizedBox(
                                    width: spSm,
                                  ),
                                  Expanded(
                                    child: Text(
                                      subItem.label,
                                      style: TextStyle(
                                        color:
                                            isSubSelected ? Colors.white : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                    ];
                  }).toList(),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: selectedSubIndex == null
                    ? selectedIndex
                    : selectedSubIndex!,
                children: selectedSubIndex == null
                    ? widget.menus
                        .map((menu) => menu.view ?? Container())
                        .toList()
                    : widget.menus[selectedIndex].subItems
                        .map((subItem) => subItem.view ?? Container())
                        .toList(),
              ),
            ),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: widget.menus.length,
      initialIndex: selectedIndex,
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: widget.menus.map(
            (menu) {
              if (menu.subItems.isNotEmpty) {
                return Scaffold(
                  appBar: AppBar(
                    leading: Container(),
                    leadingWidth: 0.0,
                    title: Text(menu.label),
                  ),
                  body: GridView.builder(
                    padding: EdgeInsets.all(spMd),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.0 / 0.4,
                      crossAxisCount: 2,
                      mainAxisSpacing: spSm,
                      crossAxisSpacing: spSm,
                    ),
                    itemCount: menu.subItems.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var item = menu.subItems[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => item.view ?? Container(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: spSm,
                          ),
                          color: Theme.of(context).cardColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: FittedBox(
                                  child: Icon(
                                    item.icon,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: spXxs,
                              ),
                              Text(
                                "${item.label}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: disabledBoldColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return menu.view ?? Container();
            },
          ).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            updateIndex(index);
          },
          type: BottomNavigationBarType.fixed,
          items: List.generate(widget.menus.length, (index) {
            final item = widget.menus[index];
            return BottomNavigationBarItem(
              icon: Icon(
                item.icon,
              ),
              label: item.label,
            );
          }),
        ),
      ),
    );
  }
}
