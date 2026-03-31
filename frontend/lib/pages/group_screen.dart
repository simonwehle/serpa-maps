import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/group/group_header.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text("Groups")),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: Column(
          children: [
            GroupHeader(
              title: "Invites",
              icon: Icons.refresh,
              onPressed: () {
                print("Invites");
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Monaco Vacation"),
                  Row(
                    children: [
                      IconButton(
                        color: colorScheme.tertiary,
                        onPressed: () {
                          print("Test");
                        },
                        icon: Icon(Icons.check),
                      ),
                      IconButton(
                        color: colorScheme.error,
                        onPressed: () {
                          print("Reject");
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text("No group invites available")),
            ),
            Divider(),
            GroupHeader(
              title: "Groups",
              icon: Icons.add,
              onPressed: () {
                print("Add group");
              },
            ),
          ],
        ),
      ),
    );
  }
}
