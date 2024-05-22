import 'package:encryption/encryptions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Programmamyz arkaly heşlemäge başla'),
            Image.asset('assets/1.jpg'),
            const Gap(12),
            CupertinoButton(
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EncryptionsScreen()));
                },
                child: const Text(
                  'Başla',
                ))
          ],
        ),
      ),
    );
  }
}
