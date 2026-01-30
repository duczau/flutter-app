import 'dart:io';

import 'package:first_app/favourite_places_app/provider/place_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class InputImage extends ConsumerStatefulWidget {
  const InputImage({super.key, required this.onAddImage});

  final void Function(Object path) onAddImage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _InputImage();
  }
}

class _InputImage extends ConsumerState<InputImage> {
  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  bool _isLoading = false;

  void _takePicture() async {
    final _image = ImagePicker();

    setState(() {
      _isLoading = true;
    });

    final _pickedImage = await _image.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      imageQuality: 50,
    );

    if (_pickedImage == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (kIsWeb) {
      _selectedImageBytes = await _pickedImage.readAsBytes();
      widget.onAddImage(_selectedImageBytes!);
    } else {
      _selectedImage = File(_pickedImage.path);
      widget.onAddImage(_selectedImage!);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _imageWidget = SizedBox(width: double.infinity);
    Widget _imageRemove = SizedBox(width: 0);

    if (!_isLoading) {
      // "Image.file is not supported on Flutter Web. Consider using either Image.asset or Image.network instead."
      if (kIsWeb && _selectedImageBytes != null) {
        _imageWidget = Image.memory(
          _selectedImageBytes!,
          width: double.infinity,
        );
        _imageRemove = TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedImageBytes = null;
            });
          },
          label: Text('Remove Image'),
          icon: Icon(Icons.remove_circle_outline),
        );
      } else {
        if (_selectedImage != null) {
          _imageWidget = Image.file(_selectedImage!, width: double.infinity);
          _imageRemove = TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedImage = null;
              });
            },
            label: Text('Remove Image'),
            icon: Icon(Icons.remove_circle_outline),
          );
        }
      }
    } else {
      _imageWidget = Column(
        children: [
          SizedBox(height: 16),
          CircularProgressIndicator.adaptive(),
          SizedBox(height: 16),
        ],
      );
    }

    return Container(
      decoration: ShapeDecoration(
        color: Colors.blue.shade100,
        shape: BeveledRectangleBorder(
          side: BorderSide(
            color: const Color.fromARGB(255, 156, 108, 158),
            width: 1.0,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          _imageWidget,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text('Take image'),
                onPressed: _takePicture,
              ),
              _imageRemove,
            ],
          ),
        ],
      ),
    );
  }
}
