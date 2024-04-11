import 'package:encryption/aes_enrypt.dart';
import 'package:encryption/diffie_hellman_encryption.dart';
import 'package:encryption/fibonacci.dart';
import 'package:encryption/image_encryption.dart';
import 'package:flutter/material.dart';

class EncryptionsScreen extends StatelessWidget {
  const EncryptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Encryption types"),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            trailing: const Icon(Icons.chevron_right),
            title: const Text('AES Encryption'),
            subtitle:
                const Text('Encrypt and decrypt data using AES algorithm'),
            onTap: () {
              // Navigate to AES Encryption Screen
              // You can implement navigation here
              openPage(context, const AESEncryptScreen());
            },
          ),
          ListTile(
            trailing: const Icon(Icons.chevron_right),
            leading: const Icon(Icons.image),
            title: const Text('Photo & Image Encryption'),
            subtitle:
                const Text('Secure your photos and images with encryption'),
            onTap: () {
              // Navigate to Photo/ Image Encryption Screen
              // You can implement navigation here
              openPage(context, const ImageHashingPage());

              print('Navigate to Photo/ Image Encryption Screen');
            },
          ),
          // ListTile(
          //   trailing: const Icon(Icons.chevron_right),
          //   leading: const Icon(Icons.videocam),
          //   title: const Text('Video & Audio Encryption'),
          //   subtitle: const Text('Encrypt your videos and audio recordings'),
          //   onTap: () {
          //     // Navigate to Video/ Audio Encryption Screen
          //     // You can implement navigation here
          //     print('Navigate to Video/ Audio Encryption Screen');
          //   },
          // ),
          ListTile(
            trailing: const Icon(Icons.chevron_right),
            leading: const Icon(Icons.vpn_key),
            title: const Text('Diffie-Hellman Encryption'),
            subtitle: const Text(
                'Implement secure key exchange using Diffie-Hellman'),
            onTap: () {
              // Navigate to Diffie-Hellman Encryption Screen
              // You can implement navigation here
              openPage(context, const DiffieHellmanPage());
              print('Navigate to Diffie-Hellman Encryption Screen');
            },
          ),
          ListTile(
            trailing: const Icon(Icons.chevron_right),
            leading: const Icon(Icons.file_copy),
            title: const Text('File Encryption with Fibonacci Series'),
            subtitle: const Text(
                'Encrypt files using Fibonacci series based encryption'),
            onTap: () {
              // Navigate to File Encryption Screen
              // You can implement navigation here
              openPage(context, const FibonacciScreen());
              print('Navigate to File Encryption Screen');
            },
          ),
        ],
      )),
    );
  }

  void openPage(context, screen) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
        ));
  }
}
