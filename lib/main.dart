import 'dart:math';

import 'package:animal_random_app/model/animal.dart';
import 'package:animal_random_app/views/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/db_helpers.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Splesh_Screen(),
    ),
  );
}

class Splesh_Screen extends StatefulWidget {
  const Splesh_Screen({Key? key}) : super(key: key);

  @override
  State<Splesh_Screen> createState() => _Splesh_ScreenState();
}

class _Splesh_ScreenState extends State<Splesh_Screen> {
  splesh() async {
    await Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Home_Page(),
        ),
      );
    });
  }

  late Future<List<Animal>> getAnimals;
  late int i;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    splesh();
    getAnimals = DBHelper.dbHelper.fetchAllRecords();
    i = random.nextInt(11);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: FutureBuilder(
                future: getAnimals,
                builder: (context, snapShot) {
                  if (snapShot.hasError) {
                    return Center(
                      child: Text("ERROR : ${snapShot.error}"),
                    );
                  } else if (snapShot.hasData) {
                    List<Animal>? data = snapShot.data;

                    return (data == null || data.isEmpty)
                        ? SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 500,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                        "https://media.istockphoto.com/id/621138854/photo/dog-on-the-phone.jpg?s=612x612&w=0&k=20&c=WSgZnMYbEN-QvZc8YxB_rXcDuXiw-YNbL_kaZZ5vgVw=",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 20,
                                  ),
                                  child: Text(
                                    "Dog",
                                    style: GoogleFonts.actor(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 10,
                                    top: 20,
                                  ),
                                  child: Text(
                                    "A dog is a domestic mammal of the family Canidae and the order Carnivora. Its scientific name is Canis lupus familiaris. Dogs are a subspecies of the gray wolf, and they are also related to foxes and jackals. Dogs are one of the two most ubiquitous and most popular domestic animals in the world.",
                                    style: GoogleFonts.actor(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 500,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        data[i].image,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 20,
                                  ),
                                  child: Text(
                                    data[i].name,
                                    style: GoogleFonts.actor(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 10,
                                    top: 20,
                                  ),
                                  child: Text(
                                    data[i].dec,
                                    style: GoogleFonts.actor(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            // Container(
            //   height: 500,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade200,
            //     image: const DecorationImage(
            //       image: NetworkImage(
            //         "https://media.istockphoto.com/id/621138854/photo/dog-on-the-phone.jpg?s=612x612&w=0&k=20&c=WSgZnMYbEN-QvZc8YxB_rXcDuXiw-YNbL_kaZZ5vgVw=",
            //       ),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     left: 20,
            //     right: 20,
            //     top: 20,
            //   ),
            //   child: Text(
            //     "Dog",
            //     style: GoogleFonts.actor(
            //       textStyle: const TextStyle(
            //         fontWeight: FontWeight.w600,
            //         fontSize: 30,
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     left: 20,
            //     right: 10,
            //     top: 20,
            //   ),
            //   child: Text(
            //     "A dog is a domestic mammal of the family Canidae and the order Carnivora. Its scientific name is Canis lupus familiaris. Dogs are a subspecies of the gray wolf, and they are also related to foxes and jackals. Dogs are one of the two most ubiquitous and most popular domestic animals in the world.",
            //     style: GoogleFonts.actor(
            //       textStyle: const TextStyle(
            //         fontWeight: FontWeight.w400,
            //         fontSize: 22,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
