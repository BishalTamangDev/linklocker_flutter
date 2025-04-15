import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewLinkNotFoundWidget extends StatelessWidget {
  const ViewLinkNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Link Details"),
        leading: IconButton(
          onPressed: () => context.pop(),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: const Center(
        child: Text("Link Not Found!"),
      ),
    );
  }
}
