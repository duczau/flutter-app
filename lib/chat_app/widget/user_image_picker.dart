import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          child: Text("User Image Picker"),
          backgroundColor: Colors.grey,
        ),
        TextButton.icon(
          onPressed: () {
            ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50).then((value) {
              if (value != null) {
                print(value.path);
              }

          });
          },
          label: Text("Add Image"),
          icon: Icon(Icons.add_a_photo),
        ),
      ],
    );
  }
}
