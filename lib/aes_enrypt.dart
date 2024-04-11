import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class AESEncryptScreen extends StatelessWidget {
  const AESEncryptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plainTextController = TextEditingController();
    final encryptedTextController = TextEditingController();

    final encrypt.Key as = encrypt.Key.fromSecureRandom(
        32); // Generate a 256-bit (32-byte) AES key
    final encrypt.IV iv = encrypt.IV.fromSecureRandom(16);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Encryption App'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: plainTextController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      // Change defaut border color
                    ),
                    labelText: 'Enter text to encrypt',
                    labelStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final encrypter = encrypt.Encrypter(encrypt.AES(as));
                    final encrypted =
                        encrypter.encrypt(plainTextController.text, iv: iv);
                    encryptedTextController.text = encrypted.base64;
                  },
                  child: const Text(
                    'Encrypt',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: encryptedTextController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Encrypted Text',
                    labelStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final encrypter = encrypt.Encrypter(encrypt.AES(as));
                    final decrypted = encrypter.decrypt(
                      encrypt.Encrypted.fromBase64(
                          encryptedTextController.text),
                      iv: iv,
                    );
                    plainTextController.text = decrypted;
                  },
                  child: const Text(
                    'Decrypt',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
