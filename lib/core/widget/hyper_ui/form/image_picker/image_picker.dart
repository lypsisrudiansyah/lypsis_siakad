//#TEMPLATE reuseable_image_picker
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reusekit/core/theme/theme_config.dart';

// Cloudinary configuration
const String _CLOUDINARY_CLOUD_NAME = 'dotz74j1p';
const String _CLOUDINARY_API_KEY = '983354314759691';
const String _CLOUDINARY_UPLOAD_PRESET = 'yogjjkoh';

class QImagePicker extends StatefulWidget {
  const QImagePicker({
    required this.label,
    required this.onChanged,
    super.key,
    this.value,
    this.validator,
    this.hint,
    this.helper,
    this.extensions = const ['jpg', 'png'],
    this.enabled = true,
  });
  final String label;
  final String? value;
  final String? hint;
  final String? helper;
  final String? Function(String?)? validator;
  final Function(String) onChanged;
  final List<String> extensions;
  final bool enabled;

  @override
  State<QImagePicker> createState() => _QImagePickerState();
}

class _QImagePickerState extends State<QImagePicker>
    with SingleTickerProviderStateMixin {
  String? imageUrl;
  bool loading = false;
  double uploadProgress = 0.0;
  late TextEditingController controller;
  String? selectedImagePath;

  // Animation controller for the upload progress indicator
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.value;
    controller = TextEditingController(
      text: widget.value ?? '',
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<String?> getFileFromGallery() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 90,
    );
    if (image != null) {
      setState(() {
        selectedImagePath = image.path;
      });
    }
    return image?.path;
  }

  Future<String?> getFileFromCamera() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 90,
    );
    if (image != null) {
      setState(() {
        selectedImagePath = image.path;
      });
    }
    return image?.path;
  }

  Future<String> uploadToCloudinary(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          File(filePath).readAsBytesSync(),
          filename: 'upload.jpg',
        ),
        'upload_preset': _CLOUDINARY_UPLOAD_PRESET,
        'api_key': _CLOUDINARY_API_KEY,
      });

      final res = await Dio().post(
        'https://api.cloudinary.com/v1_1/$_CLOUDINARY_CLOUD_NAME/image/upload',
        data: formData,
        onSendProgress: (int sent, int total) {
          setState(() {
            uploadProgress = sent / total;
          });
        },
      );

      final String url = res.data['secure_url'];
      return url;
    } catch (e) {
      print('Cloudinary upload error: $e');
      rethrow;
    }
  }

  Future<void> _showImageSourceDialog() async {
    if (!widget.enabled || loading) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Select Image Source",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const Divider(height: 1),
            _buildSourceOption(
              icon: Icons.photo_library_rounded,
              title: "Photo Gallery",
              subtitle: "Select from your gallery",
              onTap: () async {
                Navigator.pop(context);
                final filePath = await getFileFromGallery();
                if (filePath != null) {
                  _uploadImage(filePath);
                }
              },
            ),
            Divider(height: 1, indent: 70),
            _buildSourceOption(
              icon: Icons.camera_alt_rounded,
              title: "Camera",
              subtitle: "Take a new photo",
              onTap: () async {
                Navigator.pop(context);
                final filePath = await getFileFromCamera();
                if (filePath != null) {
                  _uploadImage(filePath);
                }
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadImage(String filePath) async {
    setState(() {
      loading = true;
      uploadProgress = 0.0;
    });

    try {
      imageUrl = await uploadToCloudinary(filePath);

      if (imageUrl != null) {
        widget.onChanged(imageUrl!);
        controller.text = imageUrl!;
      }
    } catch (e) {
      // Show error with subtle message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: dangerColor,
          content: Text("Failed to upload image. Please try again."),
          duration: Duration(seconds: 3),
        ),
      );
      print("Upload error: $e");
    }
    setState(() {
      loading = false;
      selectedImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with optional badge to show when image is selected
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (imageUrl != null && !loading)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: successColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: successColor,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Uploaded",
                      style: TextStyle(
                        fontSize: 12,
                        color: successColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 8),

        // Image preview and upload container
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(radiusMd),
              border: Border.all(
                color: loading
                    ? primaryColor.withValues(alpha: 0.5)
                    : Colors.grey[300]!,
                width: loading ? 2 : 1,
              ),
              boxShadow: [
                if (!loading)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radiusMd),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Image or placeholder
                  if (selectedImagePath != null && loading)
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.7,
                        child: Image.file(
                          File(selectedImagePath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else if (imageUrl != null && imageUrl!.isNotEmpty)
                    Positioned.fill(
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder(isError: true);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildPlaceholder(),
                              CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(primaryColor),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  else
                    _buildPlaceholder(),

                  // Loading overlay - now with progress and animation
                  if (loading)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(radiusMd),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated progress indicator
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Outer circle
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white
                                            .withValues(alpha: 0.15),
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.5),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    // Progress indicator
                                    SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: CircularProgressIndicator(
                                        value: uploadProgress > 0
                                            ? uploadProgress
                                            : null,
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            Colors.white.withValues(alpha: 0.2),
                                      ),
                                    ),
                                    // Cloudinary icon
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.cloud_upload_outlined,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 20),
                            // Status text with progress percentage
                            Text(
                              uploadProgress > 0
                                  ? 'Uploading to cloud... ${(uploadProgress * 100).toStringAsFixed(0)}%'
                                  : 'Preparing upload...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Small hint text
                            Text(
                              'Please wait while we process your image',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Upload button overlay
                  if (!loading)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.8),
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.7, 1.0],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    imageUrl != null
                                        ? Icons.edit_outlined
                                        : Icons.add_photo_alternate_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    imageUrl != null
                                        ? 'Change Image'
                                        : 'Upload Image',
                                    style: TextStyle(
                                      color: Colors.white,
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
                ],
              ),
            ),
          ),
        ),

        // Helper text
        if (widget.helper != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.helper!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Form field for validation
        FormField<String>(
          initialValue: imageUrl,
          validator: widget.validator,
          builder: (FormFieldState<String> field) {
            if (field.hasError) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 14,
                      color: dangerColor,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        field.errorText!,
                        style: TextStyle(
                          color: dangerColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildPlaceholder({bool isError = false}) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isError
                  ? dangerColor.withValues(alpha: 0.1)
                  : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isError ? Icons.broken_image : Icons.image_outlined,
              size: 40,
              color: isError ? dangerColor : Colors.grey[400],
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: isError
                  ? dangerColor.withValues(alpha: 0.05)
                  : Colors.grey[200]!.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              isError
                  ? 'Failed to load image'
                  : (widget.hint ?? 'Tap to select an image'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isError ? dangerColor : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

//#END
