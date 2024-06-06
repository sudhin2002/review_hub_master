import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:review_hub_admin/constants/color.dart';
import 'package:review_hub_admin/customWidgets/customText.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _movieNameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  String? _imageUrl;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        var imageFile =
            await pickedFile.readAsBytes(); // Adjusted for web compatibility
        String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask =
            storageRef.putData(imageFile); // Adjusted for web compatibility
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _imageUrl = imageUrl; // Use this URL in Image.network
          print('Image uploaded successfully: $_imageUrl');
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('failed to pick image: $e'),
      ));
      print('Failed to pick or upload image: $e');
    }
  }

// Remove the image uploading part from sendData as it is redundant now.
// Future<void> sendData() async {
//   if (_formKey.currentState?.validate() ?? false) {
//     await FirebaseFirestore.instance.collection('reviews').add({
//       'name': _movieNameController.text,
//       'about': _aboutController.text,
//       'category': _selectedCategory,
//       'image_url': _imageUrl,  // Directly use the URL from image picking
//       'status': '0'
//     });

//     // Reset the form fields
//     _movieNameController.clear();
//     _aboutController.clear();
//     _selectedCategory = null;
//     _imageUrl = null;  // Clear the image URL
//     setState(() {});
//   }
// }

  String? _selectedCategory;
  final List<String> _categories = [
    'Movie',
    'Channel',
    'Service',
    'Product',
    'Hotel'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: AppText(
          size: 20,
          text: 'Review Hub',
          textcolor: Colors.white,
          weight: FontWeight.w500,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
                text: 'Add Review Product',
                weight: FontWeight.bold,
                size: 40,
                textcolor: maincolor),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 350,
                      height: 350,
                      child: _imageUrl == null
                          ? const Center(
                              child: Text('No Image Selected',
                                  style: TextStyle(color: Colors.grey)))
                          : Image.network(_imageUrl!, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        height: 40,
                        width: 120,
                        color: maincolor,
                        child: const Center(
                            child: Text('Add Image',
                                style: TextStyle(color: Colors.white))),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 25),
                Container(
                  width: 350,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          fillColor: maincolor,
                          filled: true,
                          hintText: 'Select category',
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        dropdownColor: maincolor,
                        items: _categories.map((String category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category,
                                style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      buildTextFormField(_movieNameController, ' Name'),
                      const SizedBox(height: 20),
                      buildTextFormField(_aboutController, 'About',
                          maxLines: 5),
                      const SizedBox(height: 40),
                      InkWell(
                        onTap: sendData,
                        child: Container(
                          height: 40,
                          width: 300,
                          color: maincolor,
                          child: Center(
                              child: AppText(
                                  text: 'Submit',
                                  weight: FontWeight.w500,
                                  size: 15,
                                  textcolor: Colors.white)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String hintText,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter $hintText';
        }
        return null;
      },
      decoration: InputDecoration(
        fillColor: maincolor,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> sendData() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Debugging: check if the imageUrl is available
      print('Sending data with image URL: $_imageUrl');

      if (_imageUrl == null) {
        // Show an error message or disable the submit button until image is uploaded
        print('Image URL is not set. Please upload an image first.');
        return;
      }

      try {
        await FirebaseFirestore.instance.collection('items').add({
          'name': _movieNameController.text,
          'about': _aboutController.text,
          'category': _selectedCategory,
          'image_url': _imageUrl,
          'status': '0'
        });

        // Clear the form fields after successful submission

        // Optionally, show a success message
        print('Data successfully sent to the database.');
        DateTime now = DateTime.now();
        DateFormat formatter = DateFormat('dd-MM-yyyy');
        String formattedDate = formatter.format(now);

        await FirebaseFirestore.instance.collection('admin_notification').add({
          'name': _movieNameController.text,
          'about': _aboutController.text,
          'category': _selectedCategory,
          'date': formattedDate,
          'status': '0'
        });

        _movieNameController.clear();
        _aboutController.clear();
        _selectedCategory = null;
        _imageUrl = null;
        setState(() {});
      } catch (e) {
        // Handle errors in sending data to the database
        print('Error sending data to the database: $e');
      }
    } else {
      print('Form is not valid. Please review the fields.');
    }
  }
}
