import 'dart:typed_data';
 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:app_nutricao/_utils/utils.dart'; // Verifique se o import está correto
 

class AvatarImage extends StatefulWidget {
  const AvatarImage({super.key}); // Corrigido super.key para Key? key
 
  @override
  State<AvatarImage> createState() => _AvatarImageState();
}
 
class _AvatarImageState extends State<AvatarImage> {
  Uint8List? _image;
 
  void selectImage() async {
    List<int>? imgBytes = await Utils.pickImageAsBytes(
        ImageSource.gallery); // Corrigido para aceitar List<int>?
 
    if (imgBytes != null) {
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
 