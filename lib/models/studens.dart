import 'dart:typed_data';

class Student {
  int? id;
  final String name;
  final int age;
  final String course;
  Uint8List? image;

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.course,
    this.image,
  });

  //Row data to Custom object (Map => Student)
  factory Student.fromMap({required Map<String, dynamic> data}) {
    return Student(
      id: data['Id'],
      name: data['Name'],
      age: data['Age'],
      course: data['Course'],
      image: data['Image'],
    );
  }
}
