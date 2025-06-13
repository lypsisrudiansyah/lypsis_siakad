//#TEMPLATE reuseable_camera_picker
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QCameraPicker extends StatefulWidget {
  const QCameraPicker({
    required this.label,
    required this.onChanged,
    super.key,
    this.value,
    this.validator,
    this.hint,
    this.helper,
    this.obscure = false,
    this.provider = 'cloudinary',
  });
  final String label;
  final String? value;
  final String? hint;
  final String? helper;
  final String? Function(String?)? validator;
  final bool obscure;
  final Function(String) onChanged;
  final String? provider;

  @override
  State<QCameraPicker> createState() => _QCameraPickerState();
}

class _QCameraPickerState extends State<QCameraPicker> {
  String? imageUrl;
  bool loading = false;
  late TextEditingController controller;
  @override
  void initState() {
    imageUrl = widget.value;
    controller = TextEditingController(
      text: widget.value ?? '-',
    );
    super.initState();
  }

  Future<String?> getFileAndroidIosAndWeb() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 40,
    );
    final filePath = image?.path;
    if (filePath == null) return null;

    final file = File(filePath);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<String?> uploadFile(String filePath) async {
    return await uploadToCloudinary(filePath);
  }

  Future<String> uploadToCloudinary(String filePath) async {
    const cloudName = 'dotz74j1p';
    const apiKey = '983354314759691';

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        File(filePath).readAsBytesSync(),
        filename: 'upload.jpg',
      ),
      'upload_preset': 'yogjjkoh',
      'api_key': apiKey,
    });

    final res = await Dio().post(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      data: formData,
    );

    final String url = res.data['secure_url'];
    return url;
  }

  Future<void> browsePhoto() async {
    if (loading) return;

    String? base64Image;
    loading = true;
    setState(() {});

    base64Image = await getFileAndroidIosAndWeb();
    if (base64Image == null) return;

    imageUrl = base64Image;
    loading = false;

    if (imageUrl != null) {
      widget.onChanged(imageUrl!);
      controller.text = imageUrl!;
    }
    setState(() {});
  }

  String? get currentValue {
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: browsePhoto,
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 140,
              ),
              child: Stack(
                children: [
                  if (imageUrl != null)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageUrl!.startsWith('http')
                              ? NetworkImage(imageUrl!)
                              : MemoryImage(base64Decode(imageUrl!))
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 32.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            'Click to take photo',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Supported formats: jpg, jpeg, png',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (loading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.8),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LinearProgressIndicator(
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Uploading photo...',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[600],
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
          ),
        ),
      ),
    );
  }
}

//#END
