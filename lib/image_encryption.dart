import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pointycastle/api.dart';

Uint8List generateRandomKey() {
  final random = Random.secure();
  final key = List<int>.generate(32, (_) => random.nextInt(256));
  return Uint8List.fromList(key);
}

void encryptFile(Uint8List key, File inputFile, File outputFile) {
  final cipher = BlockCipher('AES')..init(true, KeyParameter(key));
  final inputBytes = inputFile.readAsBytesSync();
  final encryptedBytes = cipher.process(Uint8List.fromList(inputBytes));
  outputFile.writeAsBytesSync(encryptedBytes);
}

void decryptFile(Uint8List key, File encryptedFile, File decryptedFile) {
  final cipher = BlockCipher('AES')..init(false, KeyParameter(key));
  final encryptedBytes = encryptedFile.readAsBytesSync();
  final decryptedBytes = cipher.process(Uint8List.fromList(encryptedBytes));
  decryptedFile.writeAsBytesSync(decryptedBytes);
}

class ImageHashingPage extends StatefulWidget {
  const ImageHashingPage({super.key});

  @override
  _ImageHashingPageState createState() => _ImageHashingPageState();
}

class _ImageHashingPageState extends State<ImageHashingPage> {
  File? _imageFile;
  String? _imageHash;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      setState(() {
        _imageFile = imageFile;
        _imageHash = null;
      });
      _generateImageHash(imageFile);
    }
  }

  Future<void> _generateImageHash(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final digest = sha256.convert(bytes);
    setState(() {
      _imageHash = digest.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Encrypting with SHA256'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 350,
                  )
                : const Text('No image selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Take Photo'),
            ),
            const SizedBox(height: 20),
            if (_imageFile != null)
              FilledButton(
                onPressed: () =>
                    encryptFile(generateRandomKey(), _imageFile!, _imageFile!),
                child: const Text('Encrypt'),
              ),
          ],
        ),
      ),
    );
  }
}
