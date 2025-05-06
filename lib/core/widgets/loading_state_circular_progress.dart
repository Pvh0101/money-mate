import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: LoadingStateCircularProgress(),
    ),
  ));
}

class LoadingStateCircularProgress extends StatelessWidget {
  const LoadingStateCircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 16,
          ),
          Text("Loading... Please wait..."),
        ],
      ),
    );
  }
}
