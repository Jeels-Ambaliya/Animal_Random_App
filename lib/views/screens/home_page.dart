import 'dart:typed_data';

import 'package:animal_random_app/model/animal.dart';
import 'package:animal_random_app/views/screens/category_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/db_helpers.dart';
import '../../model/globals.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  late Future<List<Animal>> getAnimals;

  final GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController decController = TextEditingController();

  String? name;
  String? dec;
  Uint8List? imageBytes;

  getFromGallery() async {
    ImagePicker picker = ImagePicker();

    XFile? xFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    imageBytes = await xFile!.readAsBytes();
  }

  @override
  void initState() {
    super.initState();
    getAnimals = DBHelper.dbHelper.fetchAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              floating: true,
              snap: true,
              pinned: true,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Animals"),
                background: Image.network(
                  "https://akm-img-a-in.tosshub.com/indiatoday/images/story/202109/World_Animal_Day_19092021_0.jpg?size=1200:675",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate((context, i) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Category_Page(
                              name: "${Globals.animalList[i]['Name']}"),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 140,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "${Globals.animalList[i]['Image']}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: Text(
                            "${Globals.animalList[i]['Name']}",
                            style: GoogleFonts.actor(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: Globals.animalList.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          validateInsert();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void validateInsert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text("Insert Record"),
          ),
          content: Form(
            key: insertFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      getFromGallery();
                    },
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.deepPurple.shade100,
                      child: const Text(
                        "ADD",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter name first.....";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    name = val;
                  },
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: decController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter Description first.....";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    dec = val;
                  },
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                nameController.clear();
                decController.clear();
                setState(() {
                  name = null;
                  dec = null;
                  imageBytes = null;
                });
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            OutlinedButton(
              onPressed: () async {
                if (insertFormKey.currentState!.validate()) {
                  insertFormKey.currentState!.save();

                  Animal a1 = Animal(
                    name: name!,
                    dec: dec!,
                    image: imageBytes!,
                  );

                  int id = await DBHelper.dbHelper.insertRecord(animal: a1);

                  if (id > 0) {
                    setState(() {
                      getAnimals = DBHelper.dbHelper.fetchAllRecords();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$id : Record Inserted successfully..."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Record Insertion failed..."),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }

                nameController.clear();
                decController.clear();

                setState(() {
                  name = null;
                  dec = null;
                  imageBytes = null;
                });

                Navigator.pop(context);
              },
              child: const Text("Insert"),
            ),
          ],
        );
      },
    );
  }
}
