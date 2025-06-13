//#TEMPLATE reuseable_file_picker
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String _CLOUDINARY_CLOUD_NAME = 'dotz74j1p';
const String _CLOUDINARY_API_KEY = '983354314759691';
const String _CLOUDINARY_UPLOAD_PRESET = 'yogjjkoh';

class QFilePicker extends StatefulWidget {
  const QFilePicker({
    required this.label,
    required this.onChanged,
    super.key,
    this.value,
    this.validator,
    this.hint,
    this.helper,
    this.obscure = false,
    this.extensions = const ['csv', 'pdf', 'txt'],
    this.enabled = true,
  });
  final String label;
  final String? value;
  final String? hint;
  final String? helper;
  final String? Function(String?)? validator;
  final bool obscure;
  final Function(String) onChanged;
  final List<String> extensions;
  final bool enabled;

  @override
  State<QFilePicker> createState() => _QFilePickerState();
}

class _QFilePickerState extends State<QFilePicker> {
  String? fileUrl;
  bool loading = false;
  late TextEditingController controller;
  @override
  void initState() {
    fileUrl = widget.value;
    controller = TextEditingController(
      text: widget.value ?? '-',
    );
    super.initState();
  }

  Future<String?> getFileMultiplePlatform() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.extensions,
    );
    if (result == null) return null;
    return result.files.first.path;
  }

  Future<String> uploadToCloudinary(String filePath) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        File(filePath).readAsBytesSync(),
        filename: "upload.${filePath.split(".").last}",
      ),
      'upload_preset': _CLOUDINARY_UPLOAD_PRESET,
      'api_key': _CLOUDINARY_API_KEY,
    });

    final res = await Dio().post(
      'https://api.cloudinary.com/v1_1/$_CLOUDINARY_CLOUD_NAME/raw/upload',
      data: formData,
    );

    final String url = res.data['secure_url'];
    return url;
  }

  Future<void> browseFile() async {
    if (loading) return;
    String? filePath;

    filePath = await getFileMultiplePlatform();
    if (filePath == null) return;

    loading = true;
    setState(() {});

    fileUrl = await uploadToCloudinary(filePath);

    loading = false;
    setState(() {});

    if (fileUrl != null) {
      widget.onChanged(fileUrl!);
      controller.text = fileUrl!;
    }
    setState(() {});
  }

  void viewFile() async {
    final url = fileUrl!; // Replace with your URL
    print(url);
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  String? get currentValue {
    return fileUrl;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: browseFile,
      child: AbsorbPointer(
        child: Stack(
          children: [
            FormField(
              initialValue: false,
              validator: (value) => widget.validator!(fileUrl),
              builder: (FormFieldState<bool> field) {
                return TextFormField(
                  controller: controller,
                  obscureText: widget.obscure,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: widget.label,
                    suffixIcon: Icon(_getFileTypeIcon()),
                    helperText: widget.helper,
                    hintText: widget.hint,
                    errorText: field.errorText,
                  ),
                );
              },
            ),
            if (loading)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Uploading...',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getFileTypeIcon() {
    if (fileUrl == null) return Icons.upload_file_outlined;
    String ext = fileUrl!.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.attach_file;
    }
  }
}

//#END
