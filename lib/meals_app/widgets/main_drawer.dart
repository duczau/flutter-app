import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key, required this.selectTab});
  final void Function(int index) selectTab;

  @override
  State<StatefulWidget> createState() {
    return _MainDrawer();
  }
}

class _MainDrawer extends State<MainDrawer> {
  bool isfilter = false;

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
              widget.selectTab(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.star_half),
            title: Text('Favourite'),
            subtitle: Text('Go to Favourite screen'),
            trailing: Icon(Icons.favorite_rounded),
            onTap: () {
              Navigator.pop(context);
              widget.selectTab(1);
            },
          ),
          SwitchListTile(title: Text('filter'), activeThumbColor: Colors.amberAccent, value: isfilter, onChanged: (isCheck) {
            print(isCheck);
            setState(() {
              isfilter = isCheck;
            });
          })
        ],
      ),
    );
  }
}
