import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onAddImage});

  final void Function(Uint8List path) onAddImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

Future<File> saveUint8ListToFile(Uint8List data, String fileName) async {
  try {
    // Get the temporary directory of the device
    final Directory tempDir = await getTemporaryDirectory();

    // Create a complete path for the file, including the file name and extension
    // Ensure you add the correct file extension, e.g., '.png', '.jpg', '.pdf'
    final String filePath = '${tempDir.path}/$fileName';

    // Create the file object
    final File file = File(filePath);

    // Write the Uint8List as bytes to the file
    await file.writeAsBytes(
      data,
    ); // Use writeAsBytesSync() for synchronous operation

    print('File saved at: ${file.path}');
    return file;
  } catch (e) {
    print('Error saving file: $e');
    throw e;
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  Uint8List? _selectedImage;
  bool _isLoading = false;

  void _takePicture() async {
    final _image = ImagePicker();

    setState(() {
      _isLoading = true;
    });

    final _pickedImage = await _image.pickImage(
      source: ImageSource.camera,
      maxWidth: 150,
      imageQuality: 30,
    );

    if (_pickedImage == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    Uint8List _imageWeb = await _pickedImage.readAsBytes();
    setState(() {
      _selectedImage = _imageWeb;
      widget.onAddImage(_selectedImage!);
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? _forcegroundImage;
    Widget _imageWidget = SizedBox(width: double.infinity);

    if (_selectedImage != null) {
      // if (kIsWeb) {
      _forcegroundImage = MemoryImage(_selectedImage!);
      // } else {
      //   _forcegroundImage = FileImage(_selectedImage as File);
      // }
    }

    if (_isLoading) {
      _imageWidget = const Center(child: CircularProgressIndicator());
    } else {
      _imageWidget = CircleAvatar(
        // child: Text("User Image Picker"),
        backgroundColor: Colors.grey,
        foregroundImage: _forcegroundImage,
      );
    }

    return Column(
      children: [
        _imageWidget,
        TextButton.icon(
          onPressed: _takePicture,
          label: Text("Add Image"),
          icon: Icon(Icons.add_a_photo),
        ),
      ],
    );
  }
}
