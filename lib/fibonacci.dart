import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

String exampleFib =
    '''
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

class PDFFibonacciScreen extends StatefulWidget {
  const PDFFibonacciScreen({super.key});

  @override
  State<PDFFibonacciScreen> createState() => _PDFFibonacciScreenState();
}

class _PDFFibonacciScreenState extends State<PDFFibonacciScreen> {
  String? _file;
  String? encrypted;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pdf encrypting'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // const Text(
              //   'Example code:',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              // ),
              // const Gap(12),
              // CodeBlock(code: exampleFib),
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
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom, allowedExtensions: ['pdf']);
                  setState(() {
                    _file = result?.files[0].path;
                  });
                },
                child: const Text('Pick File'),
              ),
              const SizedBox(height: 32),
              if (_file != null)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            hintText: 'Enter password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                    const Gap(24),
                    FilledButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          securePdf(_file!);
                        }
                      },
                      child: const Text('Encrypt'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          decryptPDF();
                        }
                      },
                      child: const Text('Decrypt'),
                    ),
                  ],
                ),
              const Gap(30),
              if (encrypted != null) Text(encrypted!),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> securePdf(String path) async {
    //Load the existing PDF document.
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData(path));
    //Set the document security.
    document.security.userPassword = controller.text;
    //Save and dispose the document.
    List<int> bytes = await document.save();
    document.dispose();
    //Open the PDF file.
    _launchPdf(bytes, 'secured.pdf');
  }

  Future<void> _launchPdf(List<int> bytes, String fileName) async {
    //Get the external storage directory
    Directory? directory = await getExternalStorageDirectory();
    //Get the directory path
    String path = directory!.path;
    //Create an empty file to write the PDF data
    File file = File('$path/$fileName');
    //Write the PDF data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/$fileName');
  }

  Future<List<int>> _readDocumentData(String path) async {
    final data = File(path);
    final bytesList = await data.readAsBytes();
    return bytesList;
  }

  // Future<void> restrictPermissions() async {
  //   //Load the existing PDF document.
  //   PdfDocument document = PdfDocument(
  //       inputBytes: await _readDocumentData('credit_card_statement.pdf'));
  //   //Create document security.
  //   PdfSecurity security = document.security;
  //   //Set the owner password for the document.
  //   security.ownerPassword = 'owner@123';
  //   //Set various permission.
  //   security.permissions.addAll(<PdfPermissionsFlags>[
  //     PdfPermissionsFlags.fullQualityPrint,
  //     PdfPermissionsFlags.print,
  //     PdfPermissionsFlags.fillFields,
  //     PdfPermissionsFlags.copyContent
  //   ]);
  //   //Save and dispose the document.
  //   List<int> bytes = await document.save();
  //   document.dispose();
  //   //Open the PDF file.
  //   _launchPdf(bytes, 'permissions.pdf');
  // }

  Future<void> decryptPDF() async {
    //Load the PDF document with permission password.
    PdfDocument document = PdfDocument(
        inputBytes: await _readDocumentData(_file!), password: controller.text);
    //Get the document security.
    PdfSecurity security = document.security;
    //Set owner and user passwords are empty string.
    security.userPassword = '';
    security.ownerPassword = '';
    //Clear the security permissions.
    security.permissions.clear();
    //Save and dispose the document.
    List<int> bytes = await document.save();
    document.dispose();
    //Open the PDF file.
    _launchPdf(bytes, 'unsecured.pdf');
  }
}

// Uint8List generateRandomBytes(int length) {
//   final random = Random.secure();
//   return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
// }

// Future<void> encryptFile(File inputFile) async {
//   final fileData = await inputFile.readAsBytes();

//   final keyBytes = generateRandomBytes(16); // Generate your encryption key here
//   final iv =
//       generateRandomBytes(16); // Generate your initialization vector here

//   final cbcBlockCipher = CBCBlockCipher(AESFastEngine())
//     ..init(true, p.ParametersWithIV(p.KeyParameter(keyBytes), iv));

//   final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cbcBlockCipher);

//   final encryptedBytes = paddedCipher.process(Uint8List.fromList(fileData));

//   final outputFile = File('${inputFile.path}.encrypted');
//   await outputFile.writeAsBytes(encryptedBytes);
// }

// Future<void> decryptFile(File encryptedFile) async {
//   final encryptedFileData = await encryptedFile.readAsBytes();

//   final keyBytes =
//       generateRandomBytes(256); // Generate your encryption key here
//   final iv =
//       generateRandomBytes(256); // Generate your initialization vector here

//   final cbcBlockCipher = CBCBlockCipher(AESFastEngine())
//     ..init(false, p.ParametersWithIV(p.KeyParameter(keyBytes), iv));

//   final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cbcBlockCipher);

//   final decryptedBytes =
//       paddedCipher.process(Uint8List.fromList(encryptedFileData));

//   final decryptedFile = File('${encryptedFile.path}.decrypted');
//   await decryptedFile.writeAsBytes(decryptedBytes);
// }

class FibonacciScreen extends StatefulWidget {
  const FibonacciScreen({super.key});

  @override
  State<FibonacciScreen> createState() => _FibonacciScreenState();
}

class _FibonacciScreenState extends State<FibonacciScreen> {
  String? _file;
  String? encrypted;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fibonacci encrypting'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // const Text(
              //   'Example code:',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              // ),
              // const Gap(12),
              // CodeBlock(code: exampleFib),
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
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom, allowedExtensions: ['pdf']);
                  setState(() {
                    _file = result?.files[0].path;
                  });
                },
                child: const Text('Pick File'),
              ),
              const SizedBox(height: 32),
              if (_file != null)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            hintText: 'Enter password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                    const Gap(24),
                    FilledButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          securePdf(_file!);
                        }
                      },
                      child: const Text('Encrypt'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          decryptPDF();
                        }
                      },
                      child: const Text('Decrypt'),
                    ),
                  ],
                ),
              const Gap(30),
              if (encrypted != null) Text(encrypted!),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> securePdf(String path) async {
    //Load the existing PDF document.
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData(path));
    //Set the document security.
    document.security.userPassword = controller.text;
    //Save and dispose the document.
    List<int> bytes = await document.save();
    document.dispose();
    //Open the PDF file.
    _launchPdf(bytes, 'secured.pdf');
  }

  Future<void> _launchPdf(List<int> bytes, String fileName) async {
    //Get the external storage directory
    Directory? directory = await getExternalStorageDirectory();
    //Get the directory path
    String path = directory!.path;
    //Create an empty file to write the PDF data
    File file = File('$path/$fileName');
    //Write the PDF data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/$fileName');
  }

  Future<List<int>> _readDocumentData(String path) async {
    final data = File(path);
    final bytesList = await data.readAsBytes();
    return bytesList;
  }

  // Future<void> restrictPermissions() async {
  //   //Load the existing PDF document.
  //   PdfDocument document = PdfDocument(
  //       inputBytes: await _readDocumentData('credit_card_statement.pdf'));
  //   //Create document security.
  //   PdfSecurity security = document.security;
  //   //Set the owner password for the document.
  //   security.ownerPassword = 'owner@123';
  //   //Set various permission.
  //   security.permissions.addAll(<PdfPermissionsFlags>[
  //     PdfPermissionsFlags.fullQualityPrint,
  //     PdfPermissionsFlags.print,
  //     PdfPermissionsFlags.fillFields,
  //     PdfPermissionsFlags.copyContent
  //   ]);
  //   //Save and dispose the document.
  //   List<int> bytes = await document.save();
  //   document.dispose();
  //   //Open the PDF file.
  //   _launchPdf(bytes, 'permissions.pdf');
  // }

  Future<void> decryptPDF() async {
    //Load the PDF document with permission password.
    PdfDocument document = PdfDocument(
        inputBytes: await _readDocumentData(_file!), password: controller.text);
    //Get the document security.
    PdfSecurity security = document.security;
    //Set owner and user passwords are empty string.
    security.userPassword = '';
    security.ownerPassword = '';
    //Clear the security permissions.
    security.permissions.clear();
    //Save and dispose the document.
    List<int> bytes = await document.save();
    document.dispose();
    //Open the PDF file.
    _launchPdf(bytes, 'unsecured.pdf');
  }
}

// Uint8List generateRandomBytes(int length) {
//   final random = Random.secure();
//   return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
// }

// Future<void> encryptFile(File inputFile) async {
//   final fileData = await inputFile.readAsBytes();

//   final keyBytes = generateRandomBytes(16); // Generate your encryption key here
//   final iv =
//       generateRandomBytes(16); // Generate your initialization vector here

//   final cbcBlockCipher = CBCBlockCipher(AESFastEngine())
//     ..init(true, p.ParametersWithIV(p.KeyParameter(keyBytes), iv));

//   final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cbcBlockCipher);

//   final encryptedBytes = paddedCipher.process(Uint8List.fromList(fileData));

//   final outputFile = File('${inputFile.path}.encrypted');
//   await outputFile.writeAsBytes(encryptedBytes);
// }

// Future<void> decryptFile(File encryptedFile) async {
//   final encryptedFileData = await encryptedFile.readAsBytes();

//   final keyBytes =
//       generateRandomBytes(256); // Generate your encryption key here
//   final iv =
//       generateRandomBytes(256); // Generate your initialization vector here

//   final cbcBlockCipher = CBCBlockCipher(AESFastEngine())
//     ..init(false, p.ParametersWithIV(p.KeyParameter(keyBytes), iv));

//   final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cbcBlockCipher);

//   final decryptedBytes =
//       paddedCipher.process(Uint8List.fromList(encryptedFileData));

//   final decryptedFile = File('${encryptedFile.path}.decrypted');
//   await decryptedFile.writeAsBytes(decryptedBytes);
// }
