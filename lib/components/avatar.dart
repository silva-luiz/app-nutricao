import 'dart:typed_data';
import 'dart:io'; // Adicione esta importação para utilizar File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Ajuste o caminho conforme necessário

class AvatarImage extends StatefulWidget {
  final String? imagePath;
  final Function(String)? onImagePathChanged; // Torna o callback opcional

  const AvatarImage({Key? key, this.imagePath, this.onImagePathChanged})
      : super(key: key);

  @override
  State<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends State<AvatarImage> {
  Uint8List? _image;
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.imagePath ?? '';
    if (_imagePath.isNotEmpty) {
      _loadImageFromPath(_imagePath);
    }
  }

  Future<void> _loadImageFromPath(String path) async {
    final imgBytes = await File(path).readAsBytes();
    setState(() {
      _image = Uint8List.fromList(imgBytes);
    });
  }

  void selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final imgBytes = await image.readAsBytes();
      setState(() {
        _imagePath = image.path;
        _image = Uint8List.fromList(imgBytes);
      });
      if (widget.onImagePathChanged != null) {
        widget.onImagePathChanged!(_imagePath);
      }
    } else {
      print('No image selected'); // Caso não haja imagem selecionada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                : const CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/nophoto.png'),
                  ),
            Positioned(
              bottom: -10,
              left: 80,
              child: IconButton(
                onPressed: selectImage,
                icon: const Icon(Icons.add_a_photo),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
