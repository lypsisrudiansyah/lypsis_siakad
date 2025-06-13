import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

Future<void> downloadFile(Uint8List bytes, String fileName) async {
  try {
    // Get temporary directory
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');

    // Write file
    await file.writeAsBytes(bytes);

    // Share file
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Downloaded $fileName',
    );
  } catch (e) {
    throw 'Failed to download file';
  }
}