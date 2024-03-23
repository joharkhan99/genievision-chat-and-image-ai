import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late DataPart _imagePart;
  late File _imageFile;
  late Image _webImageFile;
  late bool _isWebImageUploaded;
  late String _fileName = "";
  bool _isLoading = false;

  @override
  @override
  void initState() {
    super.initState();
    _imageFile = File("");
    _webImageFile = Image.asset("");
    _isWebImageUploaded = false;
    _imagePart = DataPart("", Uint8List(0));
  }

  Future<void> uploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 0);
    if (pickedFile != null) {
      if (kIsWeb) {
        final imageBytes = await pickedFile.readAsBytes();
        final image = Image.memory(imageBytes);
        setState(() {
          _webImageFile = image;
          _isWebImageUploaded = true;
        });

        if (imageBytes.length > 4 * 1024 * 1024) {
          const snackBar = SnackBar(
            content: Text("Image size should be less than 4MB"),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        final imagePart = DataPart("image/jpeg", imageBytes);
        _imagePart = imagePart;
      } else {
        final File imageFile = File(pickedFile.path);
        final imageBytes = await imageFile.readAsBytes();
        setState(() {
          _imageFile = imageFile;
          _fileName = pickedFile.path;
        });

        if (imageBytes.length > 4 * 1024 * 1024) {
          const snackBar = SnackBar(
            content: Text("Image size should be less than 4MB"),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        final imagePart = DataPart("image/jpeg", imageBytes);
        _imagePart = imagePart;
      }
    } else {
      const snackBar = SnackBar(
        content: Text("No image selected. Please try again."),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> generateText(BuildContext context) async {
    final imagePart = _imagePart;
    if (_imageFile.path == "" && !_isWebImageUploaded) {
      const snackBar = SnackBar(
        content: Text("Please upload an image."),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    setState(() {
      _isLoading = true;
    });

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

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 17, 20, 27),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 17, 20, 27),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                kIsWeb && _isWebImageUploaded
                    ? SizedBox(
                        width: 200,
                        height: 200,
                        child: _webImageFile,
                      )
                    : _imageFile.path != ""
                        ? Image.file(
                            _imageFile,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(),
                const SizedBox(height: 20),
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
                            size: 50,
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
                    // disable button if no image is uploaded
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
                    onPressed: () => _isLoading ? null : generateText(context),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
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
      ),
    );
  }
}
