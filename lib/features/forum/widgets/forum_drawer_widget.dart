import 'package:flutter/material.dart';

class ForumDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Popular Tags'),
          ),
          ListTile(
            leading: const Icon(Icons.tag),
            title: const Text('#javascript (62,245)'),
            onTap: () {
              // Filter by tag
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.tag),
            title: const Text('#design (51,334)'),
            onTap: () {
              // Filter by tag
              Navigator.pop(context);
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.push_pin),
            title: Text('Pinned Group'),
          ),
        ],
      ),
    );
  }
}