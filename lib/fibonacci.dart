import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'diffie_hellman_encryption.dart';

String exampleFib = '''
class FibonacciEncryptionService {
  List<int> _fibonacciSeries(int length) {
    final fib = [0, 1];
    for (var i = 2; i < length; i++) {
      fib.add(fib[i - 1] + fib[i - 2]);
    }
    return fib;
  }

  String encryptFile(String filePath) {
    final file = File(filePath);
    final data = file.readAsBytesSync();
    final key = _fibonacciSeries(data.length).sublist(0, min(10, data.length));
    final encrypted = _encrypt(data, key);
    return base64Encode(encrypted);
  }

  List<int> decryptFile(String encryptedData) {
    final encrypted = base64Decode(encryptedData);
    final key = _fibonacciSeries(encrypted.length)
        .sublist(0, min(10, encrypted.length));
    return _decrypt(encrypted, key);
  }

  List<int> _encrypt(List<int> data, List<int> key) {
    final encrypted = List<int>.filled(data.length, 0);
    for (var i = 0; i < data.length; i++) {
      encrypted[i] = data[i] ^ key[i % key.length];
    }
    return encrypted;
  }

  List<int> _decrypt(List<int> data, List<int> key) {
    final decrypted = List<int>.filled(data.length, 0);
    for (var i = 0; i < data.length; i++) {
      decrypted[i] = data[i] ^ key[i % key.length];
    }
    return decrypted;
  }
}
''';

class FibonacciEncryptionService {
  List<int> _fibonacciSeries(int length) {
    final fib = [0, 1];
    for (var i = 2; i < length; i++) {
      fib.add(fib[i - 1] + fib[i - 2]);
    }
    return fib;
  }

  String encryptFile(String filePath) {
    final file = File(filePath);
    final data = file.readAsBytesSync();
    final key = _fibonacciSeries(data.length).sublist(0, min(10, data.length));
    final encrypted = _encrypt(data, key);
    return base64Encode(encrypted);
  }

  List<int> decryptFile(String encryptedData) {
    final encrypted = base64Decode(encryptedData);
    final key = _fibonacciSeries(encrypted.length)
        .sublist(0, min(10, encrypted.length));
    return _decrypt(encrypted, key);
  }

  List<int> _encrypt(List<int> data, List<int> key) {
    final encrypted = List<int>.filled(data.length, 0);
    for (var i = 0; i < data.length; i++) {
      encrypted[i] = data[i] ^ key[i % key.length];
    }
    return encrypted;
  }

  List<int> _decrypt(List<int> data, List<int> key) {
    final decrypted = List<int>.filled(data.length, 0);
    for (var i = 0; i < data.length; i++) {
      decrypted[i] = data[i] ^ key[i % key.length];
    }
    return decrypted;
  }
}

class FibonacciScreen extends StatefulWidget {
  const FibonacciScreen({super.key});

  @override
  State<FibonacciScreen> createState() => _FibonacciScreenState();
}

class _FibonacciScreenState extends State<FibonacciScreen> {
  String? _file;
  String? encrypted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fibonacci Encrypting'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Example code:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Gap(12),
              CodeBlock(code: exampleFib),
              const Gap(12),
              _file != null
                  ? Column(
                      children: [
                        const Icon(Icons.file_copy),
                        const Gap(12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(_file!),
                        )
                      ],
                    )
                  : const Text('No file selected'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  setState(() {
                    _file = result?.files[0].path;
                  });
                },
                child: const Text('Pick File'),
              ),
              const SizedBox(height: 20),
              if (_file != null)
                FilledButton(
                  onPressed: () {
                    setState(() {
                      encrypted =
                          FibonacciEncryptionService().encryptFile(_file!);
                    });
                  },
                  child: const Text('Encrypt'),
                ),
              const Gap(30),
              if (encrypted != null) Text(encrypted!),
            ],
          ),
        ),
      ),
    );
  }
}
