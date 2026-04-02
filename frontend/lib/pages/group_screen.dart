import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/data/group_provider.dart';
import 'package:serpa_maps/widgets/group/group_header.dart';

class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final groupsAsync = ref.watch(groupProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Groups")),
      body: groupsAsync.when(
        data: (groups) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
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
                            print("Accept");
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
              ...groups.map(
                (group) => ListTile(
                  title: Text(group.name),
                  // subtitle: group.description != ""
                  //     ? Text(group.description!)
                  //     : null,
                  onTap: () {
                    print(group.name + " pressed");
                  },
                ),
              ),
            ],
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
