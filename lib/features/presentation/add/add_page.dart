import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var themeContext = Theme.of(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: themeContext.canvasColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),

              //   profile picture
              Center(
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundColor: colorScheme.surface,
                ),
              ),

              Center(
                child: const Text("Profile Picture"),
              ),

              //   name
              TextField(
                autofocus: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_2_outlined),
                  hintText: "Name",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
              ),

              //   phone
              TextField(
                autofocus: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_outlined),
                  hintText: "Phone Number",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
              ),

              //   email address
              TextField(
                autofocus: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: "Email Address",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
              ),

              //   group
              DropdownButton(
                items: [],
                onChanged: (newValue) {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        // width: mediaQuery.size.width,
        color: themeContext.canvasColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            spacing: 8.0,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              // button :: cancel
              SizedBox(
                height: 50.0,
                width: mediaQuery.size.width / 2 - 26,
                child: TextButton(
                  style: TextButton.styleFrom(
                    // backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {
                    //   clear values
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ),

              // button :: save
              SizedBox(
                height: 50.0,
                width: mediaQuery.size.width / 2 - 26,
                child: TextButton(
                  style: TextButton.styleFrom(
                    // backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
