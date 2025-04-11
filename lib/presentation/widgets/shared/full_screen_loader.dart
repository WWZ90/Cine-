import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Loading data',
      'Buying popcorn',
      'We are about to start...',
      'A few more seconds... ',
      'Almost ready...',
      'This is taking longer than usual...',
      'It\'s movie time',
    ];
    return Stream.periodic(Duration(seconds: 1), (step) {
      return messages[step];
    }).take(messages.length);
  }

  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Please wait', style: TextStyle(color: Colors.white)),
          SizedBox(height: 20),
          CircularProgressIndicator(strokeWidth: 1),
          SizedBox(height: 20),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('Loading...');
              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}
