import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restrorder/Waiter/waiterData.dart';

Map completedOrders = {};
Map CompleteData = {};
String tableOut = '';
Iterable data = {};
List docid = [];

int sum = 0;
int totalsell = 0;

class CashCounterDashboardScreen extends StatefulWidget {
  const CashCounterDashboardScreen({super.key});

  @override
  State<CashCounterDashboardScreen> createState() =>
      _CashCounterDashboardScreenState();
}

List<String> trueDocumentIds = [];
List<String> falseDocumentIds = [];

class _CashCounterDashboardScreenState
    extends State<CashCounterDashboardScreen> {
  final CollectionReference menuCollection =
      FirebaseFirestore.instance.collection('Menu');
  Map pavbhajiData = {};
  Map starterData = {};
  Map extraDipData = {};
  Map fancyDosaData = {};
  Map frenchFriesData = {};
  // Map manchurianData = {};
  Map masalaDosaStuffedData = {};
  Map mysoreDosaGravyData = {};
  Map noodlesData = {};
  Map papadAndSaladData = {};
  Map paperAndSadaDosaData = {};
  Map pizzaData = {};
  Map pulaoData = {};
  Map riceData = {};
  Map sizzlerData = {};
  Map soupData = {};
  Map manchurianData = {};
  Map All = {};

  Future<void> fetchMenuData() async {
    DocumentSnapshot menuSnapshot =
        await menuCollection.doc('2JrHudMumgUGK6m7Zdxt').get();

    Map<String, dynamic> menuData = menuSnapshot.data() as Map<String, dynamic>;

    setState(() {
      pavbhajiData = (menuData['Pavbhaji']);
      manchurianData = (menuData['Manchurian']);

      starterData = (menuData['Starter']);
      extraDipData = (menuData['Extra Dips']);
      fancyDosaData = (menuData['Fancy Dosa']);
      frenchFriesData = (menuData['French Fries']);
      masalaDosaStuffedData = (menuData['Masala Dosa (Stuffed)']);
      mysoreDosaGravyData = (menuData['Mysore Dosa (Gravy)']);
      noodlesData = (menuData['Noodles']);
      papadAndSaladData = (menuData['Papad/Salad']);
      paperAndSadaDosaData = (menuData['Paper/Sada Dosa']);
      pizzaData = (menuData['Pizza']);
      pulaoData = (menuData['Pulao']);
      riceData = (menuData['Rice']);
      sizzlerData = (menuData['Sizzler']);
      soupData = (menuData['Soup']);

      All = {
        ...starterData,
        ...soupData,
        ...papadAndSaladData,
        ...pavbhajiData,
        ...pulaoData,
        ...masalaDosaStuffedData,
        ...mysoreDosaGravyData,
        ...paperAndSadaDosaData,
        ...noodlesData,
        ...manchurianData,
        ...riceData,
        ...fancyDosaData,
        ...frenchFriesData,
        ...pizzaData,
        ...sizzlerData,
        ...extraDipData,
      };
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMenuData();
    const DashBoadrData();
    const PaymentStatus();
  }

  final List<String> collections = [
    'Table 1',
    'Table 2',
    'Table 3',
    'Table 4',
    'Table 5',
    'Table 6',
  ];

  void revenue() {
    List<String> allItem = [];
    List<int> quantity = [];
    List<int> resultList1 = [];

    // Assuming CompleteData and All are defined somewhere in your code
    List<dynamic> price = CompleteData.keys.map((key) => All[key]).toList();

    for (var data1 in CompleteData.keys) {
      allItem.add(data1);
      quantity.add(CompleteData[data1]);
    }

    IterableZip zipResult = IterableZip([price, quantity]);
    print(zipResult);

    for (List elements in zipResult) {
      resultList1.add(elements[0] * elements[1]);
    }

    int sum1 = 0;
    for (int number in resultList1) {
      sum1 += number;
    }

    totalsell = sum1;
    print(totalsell);
  }

  paymetStatus(i) {
    if (i == 0) {
      trueDocumentIds.clear();
      falseDocumentIds.clear();
    }
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(table[i]).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        for (var doc in snapshot.data!.docs) {
          final bool billStatus = doc['Bill Status'] ?? false;

          if (billStatus) {
            trueDocumentIds.add(doc.id);
          } else {
            falseDocumentIds.add(doc.id);
          }
        }
        return Column(
          children: [if (i == 5) const PaymentStatus()],
        );
      },
    );
  }

  dashboardData(i) {
    if (i == 0) {
      CompleteData.clear();
      docid.clear();
    }
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(table[i]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          List<Map<String, dynamic>> mapDataList = [];
          for (var doc in snapshot.data!.docs) {
            Map<String, dynamic>? mapData = doc['complete'];
            if (mapData != null && mapData.isNotEmpty) {
              docid.add(doc.id);
              mapDataList.add(mapData);
              // Add each key individually to CompleteData
              mapData.forEach((key, value) {
                if (CompleteData.containsKey(key)) {
                  // Key already exists, combine values
                  CompleteData[key] += value;
                } else
                  // Key doesn't exist, add it to the map
                  CompleteData[key] = value;
              });
            }

            print(CompleteData);
          }
          if (i == 5) {
            sum = CompleteData.values
                .fold(0, (currentSum, value) => currentSum + value as int);
            print(sum);
            print(docid);
            revenue();
          }
          return Row(
            children: [if (i == 5) const DashBoadrData()],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 219, 245),
      endDrawer: const MyDrawer(),
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 0.3,
          ),
        ),
        elevation: 0,
        title: Container(
          height: 25,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 224, 224, 248),
          ),
          child: Center(
              child: Text(
            "Overview",
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          )),
        ),
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
                onPressed: () {
                  revenue();
                },
                icon: const Icon(
                  Icons.chat_rounded,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(width: 0.3, color: Colors.black),
                ),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < 6; i++) dashboardData(i),
                  // Padding(
                  //   padding: const EdgeInsets.all(18.0),
                  //   child: Container(
                  //     height: 40,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: const Color.fromARGB(255, 224, 224, 248),
                  //     ),
                  //     child: Center(
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           const Icon(Icons.bar_chart),
                  //           Text(
                  //             "Overview",
                  //             style: GoogleFonts.roboto(
                  //               color: Colors.black,
                  //               fontSize: 18,
                  //               letterSpacing: 1,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(18.0),
                  //   child: Container(
                  //     height: 40,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: const Color.fromARGB(255, 255, 255, 255),
                  //     ),
                  //     child: Center(
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           const Icon(Icons.bar_chart),
                  //           Text(
                  //             "Tables",
                  //             style: GoogleFonts.roboto(
                  //               color: Colors.black,
                  //               fontSize: 18,
                  //               letterSpacing: 1,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 18,
                      right: 18.0,
                      left: 18,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                "Payment Status",
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 16,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            for (int i = 0; i < 6; i++) paymetStatus(i)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashBoadrData extends StatefulWidget {
  const DashBoadrData({super.key});

  @override
  State<DashBoadrData> createState() => _DashBoadrDataState();
}

class _DashBoadrDataState extends State<DashBoadrData> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      // width: size.width * 0.8,
      height: size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                // height: double.infinity,'

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 224, 224, 248),
                        radius: 30,
                        child: Icon(
                          Icons.coffee_outlined,
                          // size: 40,
                          color: Color.fromARGB(255, 75, 75, 211),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            maxLines: 1,
                            sum.toString(),
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Total Items",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 224, 224, 248),
                        radius: 30,
                        child: Icon(
                          FontAwesomeIcons.chartColumn,
                          // size: 40,
                          color: Color.fromARGB(255, 75, 75, 211),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            totalsell.toString(),
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Total Revenue",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 224, 224, 248),
                        radius: 30,
                        child: Icon(
                          Icons.assignment_rounded,
                          // size: 40,
                          color: Color.fromARGB(255, 75, 75, 211),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            docid.length.toString(),
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          AutoSizeText(
                            maxLines: 2,
                            "Total Order",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentStatus extends StatefulWidget {
  const PaymentStatus({super.key});

  @override
  State<PaymentStatus> createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {
  Future<void> completedOrder(table, docid) async {
    final CollectionReference menuCollection =
        FirebaseFirestore.instance.collection(table);

    DocumentSnapshot menuSnapshot = await menuCollection.doc(docid).get();

    print(menuSnapshot['complete']);
    completedOrders = menuSnapshot['complete'];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 224, 224, 248),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 8,
                      bottom: 8,
                    ),
                    child: Text(
                      "Pending",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 14,
                          // letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                      height: 200,
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 2,
                          crossAxisCount: 2, // Number of items in each row
                          crossAxisSpacing:
                              12.0, // Horizontal spacing between items
                          mainAxisSpacing:
                              12.0, // Vertical spacing between items
                        ),
                        itemCount: falseDocumentIds.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                              child: Container(
                                height: 40,
                                width:
                                    150, // Adjust the width as needed for 2 items in a row
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, top: 6, bottom: 6, right: 18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            falseDocumentIds[index],
                                            style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 224, 224, 248),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8, bottom: 8),
                    child: Text(
                      "Completed",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 14,
                          // letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                      height: 200,
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 2,
                          crossAxisCount: 2, // Number of items in each row
                          crossAxisSpacing:
                              12.0, // Horizontal spacing between items
                          mainAxisSpacing:
                              12.0, // Vertical spacing between items
                        ),
                        itemCount: trueDocumentIds.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                              onTap: () {
                                String table =
                                    'Table ${trueDocumentIds[index][1]}';

                                tableOut = trueDocumentIds[index];
                                completedOrder(table, trueDocumentIds[index]);
                                setState(() {});

                                Scaffold.of(context).openEndDrawer();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    trueDocumentIds[index],
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ],
              ),
            ),
          ),
        )
      ],
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
          width: size.width * 0.5,
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
                      tableOut,
                      style: GoogleFonts.roboto(
                          color: const Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
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
                          "Order Summary",
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
                            itemCount: completedOrders.length,
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
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 220, 218, 215),
                                              radius: 20,
                                              child: Text(
                                                completedOrders.values
                                                    .elementAt(index)
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 18.0),
                                            child: Text(
                                              completedOrders.keys
                                                  .elementAt(index),
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
