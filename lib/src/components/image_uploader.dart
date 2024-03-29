import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class ImageUploadWidget extends StatefulWidget {
  final Function(String) getImagePath;
  const ImageUploadWidget({
    super.key,
    required this.getImagePath,
   });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  late File _image = File('lib/assets/ID_card_placeholder.png');
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.getImagePath(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Image.file(
                  _image,
                  height: 200,
                ),
        ),
        ElevatedButton(
          onPressed: getImage,
          child: const Text('Select Image'),
        ),
      ],
    );
  }
}

class CheckButton extends StatefulWidget {
  final String filename;

  const CheckButton({
    super.key,
    required this.filename
  });

  @override
  State<CheckButton> createState() => _CheckButton();
}

class _CheckButton extends State<CheckButton> {
  bool _isLoading = false;
  bool _isValidated = false;

  String buttonText = "Validate";
  Color curCorlor = Colors.blue;
  Color curText = Colors.white;

  void changeContend(String message) {
    setState(() {
      _isLoading = true;
      if (message == 'no image seleted') {
        buttonText = "please select an image";
      } else {
        _isValidated = true;
        buttonText = "validation complete";
        curCorlor = Colors.greenAccent;
        curText = Colors.white;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if (widget.filename != 'no image seleted' && !_isValidated) {
      // print(widget.filename);
      buttonText = "Validate";
      curText = Colors.white;
      curCorlor = Colors.blue;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: curCorlor
      ),
      onPressed: _isLoading ? null: () => {
        changeContend(widget.filename)
      },
      child: _isLoading ? const CircularProgressIndicator() : Text(
        buttonText,
        style: TextStyle(
                color: curText, // Change text color to white // Add bold font weight
                fontSize: 16.0, // Set font size to 16
              )
        )
    );
  }
}

class AuthDemo extends StatefulWidget {
  const AuthDemo({super.key});

  @override
  State<AuthDemo> createState() => _AuthDemo();
}

class _AuthDemo extends State<AuthDemo> {

  String imagePath = 'no image seleted';

  void getImagePath(String filename) {
    setState(() {
      imagePath = filename;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 132, 169, 195),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          constraints: const BoxConstraints(minHeight: 300, minWidth:  500, maxWidth:  500),
          child: Center(
              child: ImageUploadWidget(getImagePath: getImagePath,),
          )
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child:
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 210),
              child: CheckButton(filename: imagePath),
            )
        )
      ],
    );
  }
}