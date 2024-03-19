import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> test(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 0);
    if (pickedFile != null) {
      final String apiKey = 'AIzaSyBqbJzQPpcZTkJJARtW02EiSWW8GFJpDe0';

      final File imageFile = File(pickedFile.path);
      final imageBytes = await imageFile.readAsBytes();

      if (imageBytes.length > 4 * 1024 * 1024) {
        throw Exception('Image size exceeds the maximum allowed size.');
      }

      final prompt = TextPart("Please explain the contents of this image.");
      final imagePart = DataPart('image/jpeg', imageBytes);

      final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);
      print(response.text);
    } else {
      // User canceled image selection
      print('No image selected.');
    }
  }

  // Future<List<int>> compressImage(File imageFile) async {
  //   final int maxSize = 4 * 1024 * 1024; // 4MB (maximum allowed size by API)
  //   final int quality = 85; // Image quality (0 - 100)
  //   final compressedImage = await FlutterImageCompress.compressWithFile(
  //     imageFile.path,
  //     quality: quality,
  //   );

  //   print(compressedImage);

  //   // Ensure that the compressed image size is within the maximum allowed size
  //   if (compressedImage!.length > maxSize) {
  //     throw Exception('Compressed image size exceeds the maximum allowed size.');
  //   }

  //   return compressedImage;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Generative AI'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => test(context),
                child: const Text('Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
