import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restrorder/Cash%20Counter/dashboadrScreen.dart';
import 'package:restrorder/Waiter/waiterData.dart';

Map concatingMap = {};

class KitchenDashboardScreen extends StatefulWidget {
  const KitchenDashboardScreen({super.key});

  // final Map concateMap;

  // const KitchenDashboardScreen({super.key, required this.concateMap});
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

    print(i);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection(table[i]).snapshots(),
      builder: (context, snapshot) {
        print(table[i]);
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
                  // Key already exists, combine values
                  concateMap[key] += value;
                } else {
                  // Key doesn't exist, add it to the map
                  concateMap[key] = value;
                }
              },
            );
          }
        }
        return Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: docIds.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' ${docIds[index]}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: mapDataList[index].length == 1
                        ? 70
                        : mapDataList[index].length == 2
                            ? 140
                            : mapDataList[index].length == 3
                                ? 210
                                : 250,
                    width: double.infinity,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: mapDataList[index].length,
                      itemBuilder: (context, mapIndex) {
                        var key = mapDataList[index].keys.elementAt(mapIndex);
                        var value = mapDataList[index][key];
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 18.0, right: 18, left: 18),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(255, 220, 218, 215),
                                ),
                                height: 40,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 16,
                                        child: Text(
                                          value?.toString() ?? 'N/A',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        key,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: IconButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection(table[i])
                                                .doc(docIds[index])
                                                .update({
                                              'newOrder.${key}':
                                                  FieldValue.delete()
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
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  streamfunc1(i) {
    if (i == 0) {
      concatingMap.clear();
    }
    print(i);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection(table[i]).snapshots(),
        builder: (context, snapshot) {
          print(table[i]);
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
                  // Key already exists, combine values
                  concatingMap[key] += value;
                } else
                  // Key doesn't exist, add it to the map
                  concatingMap[key] = value;
              });
            }
          }
          return Column(
            children: [
              if (i == 5) const CustomListviewBuilder(),
            ],
          );
          // return Column(children: [
          //   // if (i == 5)
          //     ListView.builder(
          //       physics: BouncingScrollPhysics(),
          //       itemCount: concatingMap.length,
          //       itemBuilder: (context, index) {
          //         return Padding(
          //           padding:
          //               const EdgeInsets.only(top: 20.0, left: 20, right: 20),
          //           child: Container(
          //             height: 70,
          //             width: 300,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(20),
          //               color: Colors.white,
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.only(
          //                   left: 18.0, top: 6, bottom: 6, right: 18),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.only(left: 12.0),
          //                     child: CircleAvatar(
          //                       backgroundColor:
          //                           const Color.fromARGB(255, 220, 218, 215),
          //                       radius: 16,
          //                       child: Text(
          //                         concatingMap.values
          //                             .elementAt(index)
          //                             .toString(),
          //                         style: GoogleFonts.roboto(
          //                             color: Colors.black,
          //                             fontSize: 20,
          //                             fontWeight: FontWeight.bold),
          //                       ),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.only(left: 18.0),
          //                     child: Text(
          //                       concatingMap.keys.elementAt(index).toString(),
          //                       style: GoogleFonts.roboto(
          //                           color: Colors.black,
          //                           fontSize: 18,
          //                           fontWeight: FontWeight.bold),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          // ]);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const MyTextField(),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 18.0),
          child: Image(
            image: AssetImage('Assets/Images/logoblack.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.chat_rounded,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CashCounterDashboardScreen(),
                  ));
                },
                icon: const Icon(
                  Icons.person,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 219, 219, 245),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 15),
                        child: Text(
                          "In Progress",
                          style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
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
            ),
            // Expanded(
            //   flex: 1,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(
            //       height: double.infinity,
            //       decoration: BoxDecoration(
            //           color: const Color.fromARGB(255, 232, 231, 230),
            //           borderRadius: BorderRadius.circular(20)),
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Container(
            //           height: double.infinity,
            //           decoration: BoxDecoration(
            //               color: const Color.fromARGB(255, 232, 231, 230),
            //               borderRadius: BorderRadius.circular(20)),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.only(top: 10.0, left: 15),
            //                 child: Text(
            //                   "Completed",
            //                   style: GoogleFonts.roboto(
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.w600,
            //                       fontSize: 20),
            //                 ),
            //               ),
            //               const Expanded(
            //                   child: SizedBox(
            //                 width: double.infinity,
            //                 child: Padding(
            //                   padding: EdgeInsets.all(8.0),
            //                 ),
            //               ))
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 219, 219, 245),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 15),
                        child: Text(
                          "Your Orders ",
                          style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ),
                      for (int i = 0; i < 6; i++) streamfunc1(i)
                    ],
                  ),
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
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.59,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: concatingMap.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Container(
              height: 70,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, top: 6, bottom: 6, right: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 220, 218, 215),
                        radius: 16,
                        child: Text(
                          concatingMap.values.elementAt(index).toString(),
                          style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        concatingMap.keys.elementAt(index).toString(),
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  const MyTextField({super.key});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 21, 41, 74),
            ),
            child: Center(
              child: Text(
                "Dine In",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

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
                                            onPressed: () {
                                              print("Reject");
                                            },
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
