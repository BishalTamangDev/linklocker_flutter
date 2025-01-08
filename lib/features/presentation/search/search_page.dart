import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // variable
  bool hasText = false;

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // app bar
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: searchController,
          onChanged: (newValue) {
            setState(() {
              hasText = newValue.isEmpty ? false : true;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search contact",
            suffixIcon: !hasText
                ? null
                : Transform.rotate(
                    angle: pi / 4,
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          //   clear search text
                          searchController.clear();
                          hasText = false;
                        });
                      },
                      child: Icon(
                        Icons.add,
                        color: colorScheme.onSecondary,
                      ),
                    ),
                  ),
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),

      backgroundColor: Theme.of(context).canvasColor,

      //   body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                color: colorScheme.surface,
                child: ListTile(
                  onTap: () => context.push('/link/view/1'),
                  leading: CircleAvatar(
                    radius: 24.0,
                    backgroundColor: colorScheme.secondary,
                    foregroundImage: AssetImage('assets/images/blank_user.png'),
                  ),
                  title: Text("Alexander Bose - 1"),
                  subtitle: const Text("someone@gmail.com"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
