import 'dart:io';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';

class FileEncrPage extends StatefulWidget {
  final String title;
  final String ext;
  const FileEncrPage({super.key, required this.title, required this.ext});

  @override
  State<FileEncrPage> createState() => _FileEncrPageState();
}

class _FileEncrPageState extends State<FileEncrPage> {
  bool _isGranted = true;
  String filename = "";
  String? _file;
  // final String _videoURL =
  //     "https://assets.mixkit.co/videos/preview/mixkit-clouds-and-blue-sky-2408-large.mp4";
  // final String _imageURL =
  //     "https://images.unsplash.com/photo-1607753724987-7277196eac5d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&dl=jeremy-bishop-FlR9yw3QEgw-unsplash.jpg&w=1920";
  // final String _pdfURL =
  //     "https://www.irjet.net/archives/V5/i3/IRJET-V5I3124.pdf";
  // final String _zipURL =
  //     "https://www.1001freefonts.com/d/4063/admiration-pains.zip";

  Future<Directory> get getAppDir async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir;
  }

  Future<Directory> get getExternalVisibleDir async {
    if (await Directory('/storage/emulated/0/MyEncFolder').exists()) {
      final externalDir = Directory('/storage/emulated/0/MyEncFolder');
      return externalDir;
    } else {
      await Directory('/storage/emulated/0/MyEncFolder')
          .create(recursive: true);
      final externalDir = Directory('/storage/emulated/0/MyEncFolder');
      return externalDir;
    }
  }

  requestStoragePermission() async {
    if (!await Permission.photos.isGranted) {
      PermissionStatus result = await Permission.photos.request();
      await Permission.videos.request();
      await Permission.audio.request();

      if (result.isGranted) {
        setState(() {
          _isGranted = true;
        });
      } else {
        setState(() {
          _isGranted = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                : const Text('Faýl saýlanmadyk'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await requestStoragePermission();
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                setState(() {
                  _file = result?.files[0].path;
                });
              },
              child: const Text('Faýl saýla'),
            ),
            const SizedBox(height: 32),
            FilledButton(
              child: const Text("HEŞLE"),
              onPressed: () async {
                if (_isGranted) {
                  // Directory d = await getExternalVisibleDir;
                  /*
                  Uncomment below line and comment above line to use Application Hidden Directory
                  to store files (Recomanded).

                  You will not able to view Encrypted files and decrepted files if you use Application Directory
                  */

                  _downloadAndCreate(
                      _file,
                      Directory('/storage/emulated/0/Download'),
                      filename,
                      context,
                      widget.ext);
                } else {
                  print("No permission granted.");
                  requestStoragePermission();
                }
              },
            ),
            ElevatedButton(
              child: const Text("Faýl Heşden aç"),
              onPressed: () async {
                if (_isGranted) {
                  // Directory d = await getExternalVisibleDir;
                  /*
                  Uncomment below line and comment above line to use Application Hidden Directory
                  to store files (Recomanded).

                  You will not able to view Encrypted files and decrepted files if you use Application Directory
                  */

                  Directory hiddenDir =
                      Directory('/storage/emulated/0/Download');
                  _getNormalFile(hiddenDir, _file, context);
                } else {
                  print("No permission granted.");
                  requestStoragePermission();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

_downloadAndCreate(String? url, Directory d, filename, BuildContext context,
    String ext) async {
  if (url != null) {
    var resp = File(url);
    var bytedata = resp.readAsBytesSync();
    var encResult = _encryptData(bytedata);

    String p =
        await _writeData(encResult, '${d.path}/${basename(resp.path)}.$ext');
    // String p = await _writeData(encResult, '/storage/emulated/0/MyEncFolder/demo.mp4.aes');
    print("file encrypted successfully: $p");

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Üstünlikli heşlendi: $p')));
  } else {
    print("Can't launch URL.");
  }
}

_getNormalFile(Directory d, String? filename, BuildContext context) async {
  // Uint8List encData = await _readData('${d.path}/$filename.aes');
  // Uint8List encData = await _readData('/storage/emulated/0/MyEncFolder/demo.mp4.aes');
  // FilePickerResult? result =
  //     await FilePicker.platform.pickFiles(type: FileType.any);

  if (filename != null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Faýl heşden açylýar...')));

    print("File decryption in progress...");
    var file = File(filename);
    enc.Encrypted en = enc.Encrypted(file.readAsBytesSync());
    var plainData = MyEncrypt.myEncrypter.decryptBytes(en, iv: MyEncrypt.myIv);
    var fileName = basename(file.path);
    String p = await _writeData(plainData,
        '${d.path}/encrypted ${fileName.substring(0, fileName.length - 4)}');

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Üstünlikli heşden açyldy: $p')));
    print("file decrypted successfully: $p");
  }

  // String p = await _writeData(plainData, '/storage/emulated/0/MyEncFolder/demo.mp4');
}

_encryptData(plainString) {
  print("Encrypting File...");
  final encrypted =
      MyEncrypt.myEncrypter.encryptBytes(plainString, iv: MyEncrypt.myIv);
  return encrypted.bytes;
}

// Future<Uint8List> _readData(fileNameWithPath) async {
//   print("Reading data...");
//   File f = File(fileNameWithPath);
//   return await f.readAsBytes();
// }

Future<String> _writeData(dataToWrite, fileNameWithPath) async {
  print("Writting Data...");
  File f = File(fileNameWithPath);
  await f.writeAsBytes(dataToWrite);
  return f.absolute.toString();
}

class MyEncrypt {
  static final myKey = enc.Key.fromUtf8('TechWithVPTechWithVPTechWithVP12');
  static final myIv = enc.IV.fromUtf8("VivekPanchal1122");
  static final myEncrypter = enc.Encrypter(enc.AES(myKey));
}
