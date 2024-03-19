import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:genievision/screens/image_output_screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final _nameController = TextEditingController();
  late DataPart _image;
  late String _fileName = "";

  Future<void> uploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 0);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final imageBytes = await imageFile.readAsBytes();
      setState(() {
        _fileName = pickedFile.path;
      });

      if (imageBytes.length > 4 * 1024 * 1024) {
        const snackBar = SnackBar(
          content: Text("Image size should be less than 4MB"),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return null;
      }
      final imagePart = DataPart("image/jpeg", imageBytes);
      // return imagePart;
      _image = imagePart;
    } else {
      const snackBar = SnackBar(
        content: Text("No image selected. Please try again."),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> generateText(BuildContext context) async {
    final imagePart = _image;

    TextPart prompt = TextPart("");
    if (_nameController.text.isNotEmpty && _nameController.text.trim().isNotEmpty) {
      prompt = TextPart(_nameController.text);
    } else {
      prompt = TextPart("Please explain the contents of this image.");
    }
    const String apiKey = 'AIzaSyBqbJzQPpcZTkJJARtW02EiSWW8GFJpDe0';
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
    final response = await model.generateContent([
      Content.multi([prompt, imagePart])
    ]);

    String? outputText = response.text;

    if (outputText != null) {
      outputText = outputText.trim();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImageOutputScreen(
            outputText: outputText!,
          ),
        ),
      );
    } else {
      // show dialog
      AlertDialog(
        title: const Text('Error'),
        content: const Text('Failed to generate text.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _fileName,
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 17, 20, 27),
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 54, 54, 54),
                    ),
                  ),
                ),
                onPressed: () => uploadImage(context),
                child: Container(
                  // height: 100,
                  // full width
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(10.0),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 100,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Upload an image',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Max size: 4MB',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // add a input field
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: _nameController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 17, 20, 27),
                    labelText: 'Ask a question about the image',
                    hintText: 'like "What is this?" or "Explain this image"',
                    prefixStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    floatingLabelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 54, 54, 54), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 54, 54, 54), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(15.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(
                        color: Color.fromARGB(255, 54, 54, 54),
                      ),
                    ),
                  ),
                  // redirect to another screen
                  onPressed: () => generateText(context),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
