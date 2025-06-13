//#TEMPLATE reuseable_multi_image_picker
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reusekit/core/theme/theme_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

const String _CLOUDINARY_CLOUD_NAME = 'dotz74j1p';
const String _CLOUDINARY_API_KEY = '983354314759691';
const String _CLOUDINARY_UPLOAD_PRESET = 'yogjjkoh';

enum AttachmentType {
  image,
  file,
}

class QFilesPicker extends StatefulWidget {
  const QFilesPicker({
    required this.label,
    required this.onChanged,
    super.key,
    this.value = const [],
    this.validator,
    this.hint,
    this.helper,
    this.extensions = const ['jpg', 'png'],
    this.enabled = true,
    this.attachmentType = AttachmentType.image,
  });
  final AttachmentType attachmentType;
  final String label;
  final List<String>? value;
  final String? hint;
  final String? helper;
  final String? Function(String?)? validator;
  final Function(List<String>) onChanged;
  final List<String> extensions;
  final bool enabled;

  @override
  State<QFilesPicker> createState() => _QFilesPickerState();
}

class _QFilesPickerState extends State<QFilesPicker> {
  String? imageUrl;
  bool loading = false;
  @override
  void initState() {
    selectedFiles = widget.value ?? [];

    super.initState();
  }

  List<String> selectedFiles = [];

  Future<void> getFileMultiplePlatform() async {
    if (widget.attachmentType == AttachmentType.image) {
      var images = await ImagePicker().pickMultiImage();
      if (images.isEmpty) return;

      loading = true;
      setState(() {});

      for (var xfile in images) {
        var url = await uploadToCloudinary(xfile.path);
        selectedFiles.add(url);
      } 
    } else {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: widget.extensions,
      );
      
      if (result == null) return;

      loading = true;
      setState(() {});

      for (var file in result.files) {
        if (file.path != null) {
          var url = await uploadToCloudinary(file.path!);
          selectedFiles.add(url);
        }
      }
    }

    setState(() {});
    widget.onChanged(selectedFiles);
  }

  Future<String> uploadToCloudinary(String filePath) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        File(filePath).readAsBytesSync(),
        filename: 'upload${filePath.contains(".") ? ".${filePath.split(".").last}" : ""}',
      ),
      'upload_preset': _CLOUDINARY_UPLOAD_PRESET,
      'api_key': _CLOUDINARY_API_KEY,
    });

    final endpoint = widget.attachmentType == AttachmentType.image 
        ? 'image/upload'
        : 'raw/upload';

    final res = await Dio().post(
      'https://api.cloudinary.com/v1_1/$_CLOUDINARY_CLOUD_NAME/$endpoint',
      data: formData,
    );

    return res.data['secure_url'];
  }

  Future<void> browseFile() async {
    if (loading) return;

    await getFileMultiplePlatform();

    loading = false;
    setState(() {});
  }

  String? get currentValue {
    return imageUrl;
  }
 
  @override
  Widget build(BuildContext context) {
    Widget getFileWidgets() {
      return LayoutBuilder(builder: (context, constraints) {
        int axisCount = (constraints.biggest.width / 140.0).floor();
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.0,
            crossAxisCount: axisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: selectedFiles.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            var file = selectedFiles[index];
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_isImageFile(file))
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        image: DecorationImage(
                          image: NetworkImage(file),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            Theme.of(context).primaryColor.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getFileIcon(file),
                            size: 32.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            _getFileName(file),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!loading)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            selectedFiles.remove(file);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      });
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: browseFile,
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 140,
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      getFileWidgets(),
                      if (selectedFiles.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  widget.attachmentType == AttachmentType.image
                                      ? Icons.add_photo_alternate_rounded
                                      : Icons.upload_file_rounded,
                                  size: 32.0,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                widget.attachmentType == AttachmentType.image
                                    ? 'Click to upload images'
                                    : 'Click to upload files',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Supported formats: ${widget.extensions.join(", ")}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  if (loading)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            backgroundColor: primaryColor.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Uploading files...',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getFileIcon(String filepath) {
    String ext = filepath.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  bool _isImageFile(String filepath) {
    String ext = filepath.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
  }

  String _getFileName(String filepath) {
    return filepath.split('/').last;
  }
}
//#END
