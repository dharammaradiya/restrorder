// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restrorder/Waiter/waiter_data.dart';

import '../login_screen.dart';

Map concatingMap = {};

class KitchenDashboardScreen extends StatefulWidget {
  const KitchenDashboardScreen({super.key});
  @override
  State<KitchenDashboardScreen> createState() => _KitchenDashboardScreenState();
}

class _KitchenDashboardScreenState extends State<KitchenDashboardScreen> {
  late Map concateMap = {};
  @override
  void initState() {
    super.initState();

    clearConcateMap();
  }

  void clearConcateMap() {
    setState(() {
      concateMap.clear();
      concatingMap.clear();
    });
  }

  streamfunc(i) {
    if (i == 0) {
      concateMap.clear();
    }
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection(table[i]).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        List<String> docIds = [];
        List<Map<String, dynamic>> mapDataList = [];

        docIds.clear();
        mapDataList.clear();

        for (var doc in snapshot.data!.docs) {
          Map<String, dynamic>? mapData = doc['newOrder'];
          if (mapData != null && mapData.isNotEmpty) {
            String docId = doc.id;
            docIds.add(docId);
            mapDataList.add(mapData);

            mapData.forEach(
              (key, value) {
                if (concateMap.containsKey(key)) {
                  concateMap[key] += value;
                } else {
                  concateMap[key] = value;
                }
              },
            );
          }
        }
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: docIds.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Table : ${docIds[index][1]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: mapDataList[index].length * 48,
                        width: double.infinity,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: mapDataList[index].length,
                          itemBuilder: (context, mapIndex) {
                            var key =
                                mapDataList[index].keys.elementAt(mapIndex);
                            var value = mapDataList[index][key];
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                            horizontal: 12.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 232, 231, 230),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            value?.toString() ?? 'N/A',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          key,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection(table[i])
                                            .doc(docIds[index])
                                            .update({
                                          'newOrder.$key': FieldValue.delete()
                                        });

                                        if (mapDataList[index].isEmpty) {
                                          FirebaseFirestore.instance
                                              .collection(table[i])
                                              .doc(docIds[index])
                                              .update({
                                            'newOrder': FieldValue.delete()
                                          });
                                        }
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.done_all,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        );
      },
    );
  }

  streamfunc1(i) {
    if (i == 0) {
      concatingMap.clear();
    }
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection(table[i]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          List<String> docIds = [];
          List<Map<String, dynamic>> mapDataList = [];

          docIds.clear();
          mapDataList.clear();

          for (var doc in snapshot.data!.docs) {
            Map<String, dynamic>? mapData = doc['newOrder'];
            if (mapData != null && mapData.isNotEmpty) {
              String docId = doc.id;
              docIds.add(docId);
              mapDataList.add(mapData);

              mapData.forEach((key, value) {
                if (concatingMap.containsKey(key)) {
                  concatingMap[key] += value;
                } else {
                  concatingMap[key] = value;
                }
              });
            }
          }
          return Column(
            children: [
              if (i == 5) const CustomListviewBuilder(),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      endDrawer: SizedBox(
        width: size.width * 0.5,
        child: const MyDrawer(),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 232, 231, 230),
        elevation: 0,
        title: const Text(
          'Kitchen Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color.fromARGB(255, 255, 81, 0),
          ),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
                },
                icon: const Icon(
                  Icons.logout,
                  size: 34,
                  color: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 232, 231, 230),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 252, 130, 74),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "In Progress",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              for (int i = 0; i < 6; i++) streamfunc(i),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 232, 231, 230),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 252, 130, 74),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Your Orders",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            for (int i = 0; i < 6; i++) streamfunc1(i)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListviewBuilder extends StatefulWidget {
  const CustomListviewBuilder({super.key});

  @override
  State<CustomListviewBuilder> createState() => _CustomListviewBuilderState();
}

class _CustomListviewBuilderState extends State<CustomListviewBuilder> {
  @override
  Widget build(BuildContext context) {
    return concatingMap.isEmpty
        ? SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            child: const Center(
              child: Text(
                "No Orders here..",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: concatingMap.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    top: 10,
                    right: 10,
                    left: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 232, 231, 230),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          concatingMap.values.elementAt(index).toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        concatingMap.keys.elementAt(index).toString(),
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
          child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: CircleAvatar(
              backgroundImage: AssetImage('Assets/Images/logoblack.png'),
              backgroundColor: Colors.transparent,
              radius: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order#301",
                  style: GoogleFonts.roboto(
                      color: const Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.table_restaurant,
                      size: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "4",
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 220, 218, 215),
                  borderRadius: BorderRadius.circular(20)),
              height: size.height * 0.62,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      "Order Summary ",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 14.0, left: 14, right: 14, bottom: 10),
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromARGB(
                                              255, 220, 218, 215),
                                          radius: 20,
                                          child: Text(
                                            "2",
                                            style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Text(
                                          "Pavbhaji",
                                          style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                                FontAwesomeIcons.xmark))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                          height: 40,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 10),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, elevation: 0),
                              child: Text(
                                "Reject",
                                style: GoogleFonts.roboto(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: SizedBox(
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () {},
                                child: Text(
                                  "Accept",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
