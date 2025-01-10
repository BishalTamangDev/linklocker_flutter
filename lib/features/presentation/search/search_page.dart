import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:linklocker/features/presentation/home/widgets/link_widget.dart';
import 'package:linklocker/features/presentation/search/widgets/no_data_widget.dart';
import 'package:linklocker/features/presentation/search/widgets/search_error_widget.dart';
import 'package:linklocker/features/presentation/search/widgets/searching_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // variable
  bool searched = false;
  bool hasText = false;
  bool searchByString = true;
  var searchController = TextEditingController();
  var localDataSource = LocalDataSource.getInstance();

  late Future<List<Map<String, dynamic>>> _links;
  late Future<List<Map<String, dynamic>>> _contacts;

  @override
  void initState() {
    super.initState();
    _links = localDataSource.searchLink(title: '');
  }

  // search link
  _searchLink(String title) {
    setState(() {
      _links = localDataSource.searchLink(title: title);
      searched = title.isEmpty ? false : true;
    });
  }

  // search contact
  _searchContact(String number) {
    setState(() {
      _contacts = localDataSource.searchContact(number);
      searched = number.isEmpty ? false : true;
    });
  }

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
            newValue = newValue.trim();
            setState(() {
              searchByString = true;
            });

            setState(() {
              hasText = newValue.isEmpty ? false : true;
            });

            try {
              int.parse(newValue);
              developer.log("Search by number");
              _searchContact(newValue);
              setState(() {
                searchByString = false;
              });
            } catch (error) {
              _searchLink(newValue);
              developer.log("Search by name or email.");
            }
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
                          _searchLink("");
                        });
                      },
                      child: Icon(Icons.add),
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
        shadowColor: colorScheme.surface,
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.more_vert),
          // ),
        ],
      ),

      backgroundColor: Theme.of(context).canvasColor,

      //   body
      body: !searched
          ? Center(
              child: Opacity(
                opacity: 0.6,
                child: Text("Search links by name or contact number."),
              ),
            )
          : FutureBuilder(
              future: searchByString ? _links : _contacts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return SearchErrorWidget();
                  } else {
                    if (snapshot.data!.isEmpty) {
                      return NoDataWidget();
                    } else {
                      //   has data
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            // link datum
                            var data = snapshot.data![index];

                            int id = data['link_id'];

                            Map<String, dynamic> linkWidgetData = {
                              'name': data['name'],
                              'email': data['email'],
                              'contacts': data['contacts'],
                            };

                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Container(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: LinkWidget(
                                        linkWidgetData: linkWidgetData,
                                        navCallBack: () => context
                                            .push('/link/view/', extra: data)
                                            .then((_) => searchByString
                                                ? _searchLink(searchController
                                                    .text
                                                    .toString())
                                                : _searchContact(searchController
                                                    .text
                                                    .toString())),
                                        callCallBack: () {},
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                              ],
                            );
                          },
                        ),
                      );
                    }
                  }
                } else {
                  return SearchingWidget();
                }
              },
            ),
    );
  }
}

//
// FutureBuilder
// (
// future: _contacts,
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.done) {
// if (snapshot.hasError) {
// return SearchErrorWidget();
// } else {
// if (snapshot.data!.isEmpty) {
// return NoDataWidget();
// } else {
// //   has data
// return Padding(
// padding: const EdgeInsets.all(16.0),
// child: ListView.builder(
// shrinkWrap: true,
// itemCount: snapshot.data!.length,
// itemBuilder: (context, index) {
// // link datum
// var data = snapshot.data![index];
//
// int id = data['link_id'];
//
// Map<String, dynamic> linkWidgetData = {
// 'name': data['name'],
// 'email': data['email'],
// 'contacts': data['contacts'],
// };
//
// return Column(
// children: [
// ClipRRect(
// borderRadius: BorderRadius.circular(12.0),
// child: Container(
// color: Theme.of(context)
//     .colorScheme
//     .surface,
// child: Padding(
// padding: const EdgeInsets.symmetric(
// vertical: 5.0),
// child: LinkWidget(
// linkWidgetData: linkWidgetData,
// navCallBack: () => context
//     .push('/link/view/',
// extra: data)
//     .then((_) => _searchLink(
// searchController.text
//     .toString())),
// callCallBack: () {},
// ),
// ),
// ),
// ),
// const SizedBox(height: 10.0),
// ],
// );
// },
// ),
// );
// }
// }
// } else {
// return SearchingWidget();
// }
// },
// )
// ,
