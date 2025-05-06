import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: LoadingStateShimmerList(),
    ),
  ));
}

class LoadingStateShimmerList extends StatelessWidget {
  const LoadingStateShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              height: 64,
              width: 64,
              color: Colors.white,
            ),
            title: SizedBox(
              height: 16,
              width: 100,
              child: Container(
                color: Colors.white,
              ),
            ),
            subtitle: Container(
              height: 8,
              width: 50,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
