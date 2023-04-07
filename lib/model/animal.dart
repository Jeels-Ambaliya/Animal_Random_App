import 'dart:typed_data';

class Animal {
  int? id;
  final String name;
  final String dec;
  final Uint8List image;

  Animal({
    this.id,
    required this.name,
    required this.dec,
    required this.image,
  });

  //Row data to Custom object (Map => Animal)
  factory Animal.fromMap({required Map<String, dynamic> data}) {
    return Animal(
      id: data['Id'],
      name: data['Name'],
      dec: data['Dec'],
      image: data['Image'],
    );
  }
}
