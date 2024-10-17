import 'package:flutter/material.dart';
import 'package:card_loading/card_loading.dart';

class CardLoadingApp extends StatelessWidget {
  const CardLoadingApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Space"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardLoading(
                          height: 30,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          width: 100,
                          margin: EdgeInsets.only(bottom: 10),
                        ),
                        CardLoading(
                          height: 100,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          margin: EdgeInsets.only(bottom: 10),
                        ),
                        CardLoading(
                          height: 30,
                          width: 200,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          margin: EdgeInsets.only(bottom: 10),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
