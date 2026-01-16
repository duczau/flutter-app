import 'package:first_app/meals_app/widgets/filter_switcher.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.selectTab,
    required this.mapFilter,
    required this.onFilterChanged,
  });

  final void Function(int index) selectTab;
  final Map<String, bool> mapFilter;
  final void Function(Map<String, bool>) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.tealAccent, Colors.limeAccent],
                begin: Alignment.bottomCenter,
                end: Alignment.topLeft,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.fastfood_outlined),
                SizedBox(width: 20),
                Text(
                  'Cook Now !!!!!!!!',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.category_outlined),
            title: Text('Categories'),
            subtitle: Text('Go to Categories screen'),
            trailing: Icon(Icons.cookie_rounded),
            onTap: () {
              Navigator.pop(context);
              selectTab(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.star_half),
            title: Text('Favourite'),
            subtitle: Text('Go to Favourite screen'),
            trailing: Icon(Icons.favorite_rounded),
            onTap: () {
              Navigator.pop(context);
              selectTab(1);
            },
          ),
          ListTile(
            leading: Icon(Icons.abc_sharp),
            title: Text('Filter'),
            subtitle: Text('Go to Filter screen'),
            trailing: Icon(Icons.favorite_rounded),
            onTap: () async {
              Navigator.pop(context);
              final a = await Navigator.push<Map<String, bool>>(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterSwitches(
                    mapFilter: mapFilter,
                    onFilterChanged: onFilterChanged,
                  ),
                ),
              );
              // .then((onValue) {
              //   onFilterChanged(onValue!); // cach 1
              // });

              if (a != null) {
                onFilterChanged(a); // cach 2
              }
            },
          ),
        ],
      ),
    );
  }
}
