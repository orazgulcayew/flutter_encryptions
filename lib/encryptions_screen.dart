import 'package:encryption/aes_enrypt.dart';
import 'package:encryption/aes_file.dart';
import 'package:encryption/fibonacci.dart';
import 'package:flutter/material.dart';

class EncryptionsScreen extends StatelessWidget {
  const EncryptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Heş görnüşleri"),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            trailing: const Icon(Icons.chevron_right),
            title: const Text('AES Heşleýji'),
            subtitle: const Text('AES algoritmi arkaly tekstleri heşlemek'),
            onTap: () {
              // Navigate to AES Encryption Screen
              // You can implement navigation here
              openPage(context, const AESEncryptScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_copy),
            trailing: const Icon(Icons.chevron_right),
            title: const Text('AES Heşleýji'),
            subtitle: const Text('AES algoritmi arkaly faýllary heşlemek'),
            onTap: () {
              // Navigate to AES Encryption Screen
              // You can implement navigation here
              openPage(
                  context,
                  const FileEncrPage(
                    title: "AES Faýl heşleýji",
                    ext: "aes",
                  ));
            },
          ),
          // ListTile(
          //   trailing: const Icon(Icons.chevron_right),
          //   leading: const Icon(Icons.image),
          //   title: const Text('Photo & Image Encryption'),
          //   subtitle:
          //       const Text('Secure your photos and images with encryption'),
          //   onTap: () {
          //     // Navigate to Photo/ Image Encryption Screen
          //     // You can implement navigation here
          //     openPage(context, const ImageHashingPage());

          //     print('Navigate to Photo/ Image Encryption Screen');
          //   },
          // ),
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
          // ListTile(
          //   trailing: const Icon(Icons.chevron_right),
          //   leading: const Icon(Icons.vpn_key),
          //   title: const Text('Diffie-Hellman Encryption'),
          //   subtitle: const Text(
          //       'Implement secure key exchange using Diffie-Hellman'),
          //   onTap: () {
          //     // Navigate to Diffie-Hellman Encryption Screen
          //     // You can implement navigation here
          //     openPage(context, const DiffieHellmanPage());
          //     print('Navigate to Diffie-Hellman Encryption Screen');
          //   },
          // ),
          ListTile(
            trailing: const Icon(Icons.chevron_right),
            leading: const Icon(Icons.file_copy),
            title: const Text('Fibonaçi yzygiderligi arkaly heşleýji'),
            subtitle: const Text(
                'Fibonaçi yzygiderligini ulanmak arkaly faýllary heşläň ýa-da heşlenen faýly açyň'),
            onTap: () {
              // Navigate to File Encryption Screen
              // You can implement navigation here
              openPage(
                  context,
                  const FileEncrPage(
                    title: "Fibonaçi faýl heşleýji",
                    ext: "fib",
                  ));
              print('Navigate to File Encryption Screen');
            },
          ),
          ListTile(
            trailing: const Icon(Icons.chevron_right),
            leading: const Icon(Icons.text_snippet_rounded),
            title: const Text('PDF goraýjy'),
            subtitle: const Text('PDF faýllary öz şahsy goragyňyzy goşuň'),
            onTap: () {
              // Navigate to File Encryption Screen
              // You can implement navigation here
              openPage(context, const PDFFibonacciScreen());
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
