import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../_utils/utils.dart'; // Ajuste o caminho conforme necessário

class AvatarImage extends StatefulWidget {
  final Function(String)? onImagePathChanged; // Torna o callback opcional

  const AvatarImage({super.key, this.onImagePathChanged});

  @override
  State<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends State<AvatarImage> {
  Uint8List? _image;
  String imagePath = '';

  void selectImage() async {
    // Use apenas uma chamada para obter a imagem e os bytes
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imagePath = image.path;
        if (widget.onImagePathChanged != null) {
          widget.onImagePathChanged!(
              imagePath); // Verifica se o callback não é nulo antes de chamá-lo
        }
      });

      final imgBytes = await image.readAsBytes();
      setState(() {
        _image = Uint8List.fromList(
            imgBytes); // Convertendo List<int> para Uint8List
      });
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
