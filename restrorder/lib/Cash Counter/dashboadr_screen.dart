// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restrorder/Waiter/waiter_data.dart';

import '../login_screen.dart';

Map completedOrders = {};
Map CompleteData = {};
String tableOut = '';
Iterable data = {};
List docid = [];
List pendingIds = [];
int sum = 0;
int totalsell = 0;
List allItemsforReceipt = [];
String customerName = '';
String amount = '';

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
      FirebaseFirestore.instance.collection('menu');
  Map pavbhajiData = {};
  Map starterData = {};
  Map extraDipData = {};
  Map fancyDosaData = {};
  Map frenchFriesData = {};
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

    for (List elements in zipResult) {
      resultList1.add(elements[0] * elements[1]);
    }

    int sum1 = 0;
    for (int number in resultList1) {
      sum1 += number;
    }

    totalsell = sum1;
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
      pendingIds.clear();
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
              mapData.forEach((key, value) {
                if (CompleteData.containsKey(key)) {
                  CompleteData[key] += value;
                } else {
                  CompleteData[key] = value;
                }
              });
            }
          }
          List<Map<String, dynamic>> mapPendingDataList = [];
          for (var doc in snapshot.data!.docs) {
            Map<String, dynamic>? mapData = doc['Order'];
            if (mapData != null && mapData.isNotEmpty) {
              pendingIds.add(doc.id);
              mapPendingDataList.add(mapData);
              mapData.forEach((key, value) {
                if (CompleteData.containsKey(key)) {
                  CompleteData[key] += value;
                } else {
                  CompleteData[key] = value;
                }
              });
            }
          }
          if (i == 5) {
            sum = CompleteData.values
                .fold(0, (currentSum, value) => currentSum + value as int);
            revenue();
          }
          return Column(
            children: [if (i == 5) const DashBoadrData()],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 232, 231, 230),
        elevation: 0,
        title: const Text(
          'Cash Counter',
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
                  setState(() {
                    revenue();
                  });
                },
                icon: const Icon(
                  // Icons.currency_rupee,
                  Icons.refresh,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
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
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 20.0,
              ),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 232, 231, 230),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < 6; i++) dashboardData(i),
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
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 232, 231, 230),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 252, 130, 74),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Payment Status",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          for (int i = 0; i < 6; i++) paymetStatus(i)
                        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCard(
          Icons.add_chart_rounded,
          'Total Revenue',
          '₹ ${totalsell.toStringAsFixed(2)}',
        ),
        const SizedBox(
          height: 10,
        ),
        buildCard(
          Icons.shopping_bag_rounded,
          'Completed Orders',
          docid.length.toString(),
        ),
        const SizedBox(
          height: 10,
        ),
        buildCard(
          Icons.pending_actions,
          'Pending Orders',
          pendingIds.length.toString(),
        ),
        const SizedBox(
          height: 10,
        ),
        buildCard(
          Icons.coffee_outlined,
          'Items Ordered',
          sum.toString(),
        ),
        const SizedBox(
          height: 10,
        ),
        buildCard(
          Icons.table_bar,
          'Total Tables',
          '6',
        ),
      ],
    );
  }

  Widget buildCard(
    IconData icon,
    String name,
    String count,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 252, 130, 74),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
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

    completedOrders = menuSnapshot['complete'];
    customerName = menuSnapshot['Name'];
    amount = menuSnapshot['Amount'];
  }

  Future<void> pendingOrder(table, docid) async {
    final CollectionReference menuCollection =
        FirebaseFirestore.instance.collection(table);

    DocumentSnapshot menuSnapshot = await menuCollection.doc(docid).get();

    completedOrders = menuSnapshot['Order'];
    customerName = '-';
    amount = '-';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height - 230,
            margin: const EdgeInsets.only(
              top: 20,
              right: 10,
              left: 20,
              bottom: 20,
            ),
            padding: const EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Pending",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  color: Colors.grey,
                  height: 1.0,
                ),
                SizedBox(
                  height: 470,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: falseDocumentIds.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          String table = 'Table ${falseDocumentIds[index][1]}';

                          tableOut = falseDocumentIds[index];
                          await pendingOrder(table, falseDocumentIds[index]);

                          Scaffold.of(context).openEndDrawer();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(20.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromARGB(255, 232, 231, 230),
                            border: const Border(
                              left: BorderSide(
                                color: Color.fromARGB(255, 255, 81, 0),
                                width: 5,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Table : ${falseDocumentIds[index].substring(1, 2)}',
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Order No : ${falseDocumentIds[index].substring(3)}",
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height - 230,
            margin: const EdgeInsets.only(
              top: 20,
              right: 20,
              left: 10,
              bottom: 20,
            ),
            padding: const EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Completed",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  color: Colors.grey,
                  height: 1.0,
                ),
                SizedBox(
                  height: 470, // 470
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: trueDocumentIds.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          String table = 'Table ${trueDocumentIds[index][1]}';
                          tableOut = trueDocumentIds[index];
                          await completedOrder(table, trueDocumentIds[index]);

                          Scaffold.of(context).openEndDrawer();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(20.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromARGB(255, 232, 231, 230),
                            border: const Border(
                              left: BorderSide(
                                color: Colors.green,
                                width: 5,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Table : ${trueDocumentIds[index].substring(1, 2)}',
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Order No : ${trueDocumentIds[index].substring(3)}",
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
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
              ],
            ),
          ),
        )
      ],
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Widget buildRow(
    String title,
    String data,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$title : ',
          style: GoogleFonts.roboto(
            color: const Color.fromRGBO(0, 0, 0, 1),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          data,
          style: GoogleFonts.roboto(
            color: const Color.fromRGBO(0, 0, 0, 1),
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
        width: size.width * 0.5,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 232, 231, 230),
                  border: const Border(
                    left: BorderSide(
                      color: Color.fromARGB(255, 255, 81, 0),
                      width: 5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildRow("Table No", tableOut.substring(1, 2)),
                        buildRow("Order No", tableOut.substring(3)),
                        buildRow("Customer Name", customerName),
                        buildRow("Bill Amount", amount),
                      ],
                    ),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        image: const DecorationImage(
                          image: AssetImage('Assets/Images/logoblack.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Summary",
                    style: GoogleFonts.roboto(
                      color: const Color.fromARGB(255, 255, 81, 0),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.download_for_offline_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                color: Colors.grey,
                height: 1.0,
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.63,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: completedOrders.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 232, 231, 230),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      completedOrders.values
                                          .elementAt(index)
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  completedOrders.keys.elementAt(index),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
