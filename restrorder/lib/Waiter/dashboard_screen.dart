// ignore_for_file: deprecated_member_use, non_constant_identifier_names, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';
import 'dart:typed_data';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restrorder/Waiter/waiter_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:restrorder/login_screen.dart';

class WaiterDashboardScreen extends StatefulWidget {
  const WaiterDashboardScreen({super.key});

  @override
  State<WaiterDashboardScreen> createState() => _WaiterDashboardScreenState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _WaiterDashboardScreenState extends State<WaiterDashboardScreen> {
  // InAppWebViewController? _webViewController;
  @override
  void initState() {
    super.initState();
    updateDocId();
    fetchMenuData();
    procesmap();
    updateTpData();
    updateCount();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    FirebaseFirestore.instance.collection(dropdownvalue).doc(docname1).update({
      'complete': toPay,
      'Order': {},
      'newOrder': {},
      'Bill Status': true,
      'Amount': sumOfTp.toString(),
    });
    toPay.clear();
    sumOfTp = 0;
    Navigator.pop(context);
    _printInvoice(context);
    setState(() {});
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger(child: Text('Payment Failed'));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger(child: Text('Payment Failed'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<dynamic> cartItems = [];
  List cartPriceOut = [];
  List tpPriceOut = [];
  List<dynamic> quantity = [];
  Map<String, dynamic> orderMap = {};
  String totalAmount = '';

  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();

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

  int sumOfPending = 0;
  int sumOfTp = 0;

  Map All = {};

  Map<String, dynamic> toPay = {};
  Map<String, dynamic> newOrder = {};

  List tpItem = [];
  List tpQuntity = [];

  Future<void> updateCount() async {
    DocumentSnapshot menuSnapshot =
        await menuCollection.doc('2JrHudMumgUGK6m7Zdxt').get();

    int count1 = menuSnapshot.get('count');
    count = count1;
  }

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

  String docname1 = "";

  Future<void> updateDocId() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(dropdownvalue);

    QuerySnapshot querySnapshot = await collectionReference
        .orderBy(FieldPath.documentId,
            descending: true) // Order by document ID in descending order
        .limit(1) // Limit the result to one document
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If there are documents, return the document ID of the first document
      var DocId = querySnapshot.docs.first.id;
      docname1 = DocId;
    }
  }

  Future<void> updateTpData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(dropdownvalue);
    newOrder.clear();

    QuerySnapshot querySnapshot = await collectionReference
        .orderBy(FieldPath.documentId,
            descending: true) // Order by document ID in descending order
        .limit(1) // Limit the result to one document
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If there are documents, return the document ID of the first document
      var tpData = querySnapshot.docs.first.id;

      DocumentSnapshot tpd = await collectionReference.doc(tpData).get();
      Map<String, dynamic> topaydata = tpd.data() as Map<String, dynamic>;
      List tpItemIn = [];

      List tpQuntityIn = [];
      Map<String, dynamic> toPay1 = (topaydata['Order']);
      Map<String, dynamic> newOr = (topaydata['newOrder']);

      toPay = toPay1;
      newOrder = newOr;
      List<int> resultList1 = [];

      List<dynamic> price = toPay1.keys.map((key) => All[key]).toList();

      tpPriceOut = price;

      setState(() {
        for (var data in toPay.keys) {
          tpItemIn.add(data);
          tpQuntityIn.add(toPay[data]);
        }
        tpItem = tpItemIn;
        tpQuntity = tpQuntityIn;

        IterableZip zipResult = IterableZip([tpPriceOut, tpQuntity]);

        for (List elements in zipResult) {
          // Multiply corresponding elements and add the result to the new list
          resultList1.add(elements[0] * elements[1]);
        }

        int sum1 = 0;

        for (int number in resultList1) {
          sum1 += number;
        }
        sumOfTp = sum1;
      });
      setState(() {});
    } else {
      // If there are no documents in the collection, return null
    }
  }

  void makeDocNameForFirebase() {
    List tempListname = [];
    for (int i = 0; i < 1; i++) {
      tempListname.add(dropdownvalue[0]);

      tempListname.add([dropdownvalue[dropdownvalue.length - 1]].join());

      tempListname.add('o');
      for (int i = 0; i < 1; i++) {
        count = count + 1;
        FirebaseFirestore.instance
            .collection('menu')
            .doc('2JrHudMumgUGK6m7Zdxt')
            .update({
          'count': count,
        });
        updateCount();
      }
      tempListname.add(count.toString());
    }

    String docname = tempListname.join();
    docname1 = docname;
    setState(() {});
  }

  var dropdownvalue = "Table 1";

  bool isContainer1Expanded = true;
  bool isContainer2Expanded = false;
  List<bool> isSelected = [true, false];

  void toggleContainers() {
    setState(() {
      isContainer1Expanded = !isContainer1Expanded;
      isContainer2Expanded = !isContainer2Expanded;
    });
  }

  final databaseReference = FirebaseDatabase.instance.ref('');

  void updateTable1() {
    databaseReference
        .child(dropdownvalue)
        .update(orderMap)
        .then((_) {})
        .catchError(
          (error) {},
        );
  }

  void mergeMaps(Map<String, dynamic> map1, Map<String, dynamic> map2,
      Map<String, dynamic> map3) async {
    var firstmap = map1;

    map2.forEach((key, value) {
      if (firstmap.containsKey(key)) {
        firstmap[key] = firstmap[key]! + value as num;
      } else {
        firstmap[key] = value;
      }
    });

    orderMap = firstmap;

    Map complete = {};

    FirebaseFirestore.instance.collection(dropdownvalue).doc(docname1).set({
      'Order': orderMap,
      'Name': _name.text,
      'Number': _number.text,
      'newOrder': map3,
      'complete': complete,
      'Bill Status': false
    });
    databaseReference.child(dropdownvalue).remove();
    setState(() {
      orderMap.clear();
      newOrder.clear();
    });
  }

  Future<List<DataSnapshot>> getAllData(String dropdownValue) async {
    try {
      final reference = databaseReference.child(dropdownValue);
      final event = await reference.once();
      if (event.snapshot.exists) {
        final List<DataSnapshot> data = [];
        for (final childSnapshot in event.snapshot.children) {
          data.add(childSnapshot);
        }
        return data;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  void procesmap() async {
    final dropdownvalue1 = dropdownvalue;
    final data = await getAllData(dropdownvalue1);

    List cartKey = [];
    List cartValue = [];

    if (data.isNotEmpty) {
      for (final snapshot in data) {
        final key = snapshot.key;
        final value = snapshot.value;
        cartKey.add(key);
        cartValue.add(value);
        // ...
      }
      cartItems = cartKey;
      quantity = cartValue;

      List<int> resultList = [];
      List Price = cartItems.map((key) => All[key]).toList();

      cartPriceOut = Price;
      IterableZip zipResult = IterableZip([cartPriceOut, quantity]);

      for (List elements in zipResult) {
        resultList.add(elements[0] * elements[1]);
      }

      int sum = 0;

      for (int number in resultList) {
        sum += number;
      }
      sumOfPending = sum;

      orderMap.clear();

      orderMap = Map.fromIterables(
        cartItems
            .map((item) => item.toString()), // Ensure each item is a String
        quantity.map((qty) => qty as int), // Ensure each qty is an int
      );

      setState(() {});
    } else {
      cartItems = cartKey;
      quantity = cartValue;
      sumOfPending = 0;
      setState(() {});
    }
  }

  void handleItemClick(String itemName) {
    setState(() {
      int currentQuantity = orderMap[itemName] ?? 0;
      orderMap[itemName] = currentQuantity + 1;
    });
    int currentQuantityfornew = newOrder[itemName] ?? 0;
    newOrder[itemName] = currentQuantityfornew + 1;
  }

  int count = 0;

  Future<void> _printInvoice(BuildContext context) async {
    final pdf = await generateInvoice();
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf,
    );
  }

  Future<Uint8List> generateInvoice() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => _buildInvoice(),
      ),
    );
    return pdf.save();
  }

  pw.Widget _buildInvoice() {
    double sgstRate = 2.5; // SGST rate
    double cgstRate = 2.5; // CGST rate

    // Calculate total tax amount
    double totalTax = sumOfTp * (sgstRate + cgstRate) / 100;

    // Customize this method to build your invoice content
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Restrorder', style: const pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 10),
          pw.Text('Invoice Number: $docname1'),
          pw.SizedBox(height: 10),
          pw.Text('Date: ${DateTime.now().toLocal()}'),
          pw.SizedBox(height: 20),
          pw.Row(children: [
            pw.Text('Items:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(width: 200),
            pw.Text('Quantity:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ]),
          pw.SizedBox(height: 10),
          _buildInvoiceItems(),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                  'SGST (${sgstRate.toString()}%):  Rs ${(sumOfTp * sgstRate / 100).toString()}'),
              pw.Text(
                  'CGST (${cgstRate.toString()}%):  Rs ${(sumOfTp * cgstRate / 100).toString()}'),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text('Total (excluding GST):  Rs ${sumOfTp.toString()}'),
          pw.Text(
              'Total (including GST):  Rs ${(sumOfTp + totalTax).toString()}'),
        ],
      ),
    );
  }

  pw.Widget _buildInvoiceItems() {
    List<pw.Widget> items = [];

    for (int i = 0; i < tpItem.length; i++) {
      items.add(
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(tpItem[i]),
            pw.Text('Quantity: ${tpQuntity[i]}'),
            pw.Text('Price: Rs ${tpPriceOut[i]}'),
          ],
        ),
      );
    }

    return pw.Column(children: items);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int buttonSize() {
      int bsize;
      if (size.height < 600) {
        bsize = 2;
      } else {
        bsize = 1;
      }
      return bsize;
    }

    Map MenuItem = {};
    // List Item = [];

    switch (selectedIndex) {
      case 0:
        MenuItem = All;
        break;
      case 1:
        MenuItem = starterData;
        break;
      case 2:
        MenuItem = soupData;
        break;
      case 3:
        MenuItem = papadAndSaladData;
        break;
      case 4:
        MenuItem = pavbhajiData;
        break;
      case 5:
        MenuItem = pulaoData;
        break;
      case 6:
        MenuItem = masalaDosaStuffedData;
        break;
      case 7:
        MenuItem = mysoreDosaGravyData;
        break;
      case 8:
        MenuItem = paperAndSadaDosaData;
        break;
      case 9:
        MenuItem = noodlesData;
        break;
      case 10:
        MenuItem = riceData;
        break;
      case 11:
        MenuItem = manchurianData;
        break;
      case 12:
        MenuItem = fancyDosaData;
        break;
      case 13:
        MenuItem = frenchFriesData;
        break;
      case 14:
        MenuItem = pizzaData;
        break;
      case 15:
        MenuItem = sizzlerData;
        break;
      case 16:
        MenuItem = extraDipData;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 232, 231, 230),
        title: Text(
          "RestrOrder",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
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
                ),
              ),
            ],
          )
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (size.height > 600)
                  SizedBox(
                    height: size.height * 0.28,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 20, right: 20),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: menu.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 3,
                          crossAxisCount: 3,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 20.0,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              //  print(menu[index]);
                              setState(() {
                                dropdownvalue = menu[index];
                                orderMap.clear();

                                newOrder.cast();
                                toPay.clear();
                                tpItem.clear();
                                tpQuntity.clear();
                                sumOfTp = 0;

                                //_updateCartItems();
                                updateTable1();
                                procesmap();
                                updateDocId();
                                updateTpData();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: dropdownvalue == menu[index]
                                    ? const Color.fromARGB(255, 255, 81, 0)
                                    : const Color.fromARGB(255, 232, 231, 230),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 232, 231, 230)),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),

                              // color of grid items
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.table_bar,
                                      size: 34,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      menu[index],
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: dropdownvalue == menu[index]
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 232, 231, 230),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    width: double.infinity,
                    height: 60,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: Catagory.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex =
                                    index; // Update the selected index
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),

                              // Increased width for better visibility
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? Catagarycolor[index] // Selected color
                                    : Colors.white, // Unselected color
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    Catagory[index],
                                    style: TextStyle(
                                      color: selectedIndex == index
                                          ? Colors
                                              .white // Text color when selected
                                          : Colors
                                              .black, // Text color when unselected
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2,
                      crossAxisCount: 3,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                    ),
                    itemBuilder: (context, index) {
                      String itemName = MenuItem.keys.elementAt(index);
                      int itemPrice = MenuItem[itemName];
                      return GestureDetector(
                        onTap: () {
                          handleItemClick(itemName);
                          procesmap();
                          updateTable1();
                        },
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border(
                                left: BorderSide(
                                    color: Color.fromARGB(255, 255, 81, 0),
                                    width: 5),
                              ),
                              color: Color.fromARGB(255, 224, 224, 224),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    maxLines: 2,
                                    itemName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  AutoSizeText(
                                    '₹ ${itemPrice.toString()}',
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: MenuItem.length,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 18.0, right: 18, bottom: 18),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 15.0,
                                  right: 15,
                                  left: 15,
                                ),
                                child: AnimatedContainer(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  height: isContainer1Expanded
                                      ? size.height * 0.73
                                      : 50,
                                  width: double.infinity,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOutExpo,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12.0,
                                      right: 8,
                                      left: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            toggleContainers();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Pending",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    color: Colors.white,
                                                    height: 26,
                                                  ),
                                                ),
                                                Text(
                                                  '₹ ${sumOfPending.toString()}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const DottedLine(
                                          dashColor: Colors.black,
                                          lineThickness: 2,
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: cartItems.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(14.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: const Color.fromARGB(
                                                      255, 232, 231, 230),
                                                ),
                                                width: double.infinity,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            cartItems[index]
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(
                                                          '₹  ${cartPriceOut[index].toString()}',
                                                          style: GoogleFonts
                                                              .roboto(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            final deleteData =
                                                                cartItems[
                                                                    index];

                                                            if (orderMap[
                                                                    cartItems[
                                                                        index]] ==
                                                                1) {
                                                              await databaseReference
                                                                  .child(
                                                                      dropdownvalue)
                                                                  .child(
                                                                      deleteData)
                                                                  .remove();
                                                              orderMap.clear();
                                                              newOrder.clear();
                                                            } else {
                                                              orderMap[cartItems[
                                                                  index]] = (orderMap[
                                                                      cartItems[
                                                                          index]]! -
                                                                  1);
                                                              newOrder[cartItems[
                                                                  index]] = (newOrder[
                                                                      cartItems[
                                                                          index]]! -
                                                                  1);
                                                              updateTable1();
                                                            }

                                                            procesmap();

                                                            setState(() {});
                                                            //
                                                          },
                                                          child: Container(
                                                            color: Colors.red,
                                                            child: const Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          quantity[index]
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            orderMap[cartItems[
                                                                index]] = (orderMap[
                                                                    cartItems[
                                                                        index]]! +
                                                                1);
                                                            newOrder[cartItems[
                                                                index]] = (newOrder[
                                                                    cartItems[
                                                                        index]]! +
                                                                1);

                                                            updateTable1();
                                                            procesmap();

                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            color: Colors.green,
                                                            child: const Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: buttonSize(),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: SizedBox(
                                              height: 50,
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape:
                                                      ContinuousRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                    255,
                                                    255,
                                                    124,
                                                    92,
                                                  ),
                                                ),
                                                onPressed: cartItems.isEmpty
                                                    ? null
                                                    : () {
                                                        if (tpItem.isEmpty) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            14.0,
                                                                        left:
                                                                            14.0),
                                                                    child: Text(
                                                                      "Customer Information",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  titlePadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  content:
                                                                      Container(
                                                                    margin: EdgeInsets
                                                                        .all(
                                                                            14),
                                                                    width: double
                                                                        .infinity,
                                                                    child: Form(
                                                                      key:
                                                                          _formKey,
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          TextFormField(
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return 'Please enter customer name!';
                                                                              }
                                                                              return null;
                                                                            },
                                                                            controller:
                                                                                _name,
                                                                            decoration: InputDecoration(
                                                                                contentPadding: const EdgeInsets.all(8),
                                                                                prefixIcon: const Padding(
                                                                                  padding: EdgeInsets.only(left: 10, right: 10.0),
                                                                                  child: Icon(
                                                                                    Icons.person,
                                                                                    color: Color.fromARGB(255, 255, 124, 92),
                                                                                  ),
                                                                                ),
                                                                                fillColor: const Color.fromARGB(255, 232, 231, 230),
                                                                                filled: true,
                                                                                hintText: "Customer Name",
                                                                                hintStyle: const TextStyle(color: Colors.black54),
                                                                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12)),
                                                                                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12)),
                                                                                border: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12))),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          TextFormField(
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return 'Please enter Mobile Number';
                                                                              }
                                                                              return null;
                                                                            },
                                                                            controller:
                                                                                _number,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            decoration: InputDecoration(
                                                                                contentPadding: const EdgeInsets.all(10),
                                                                                prefixIcon: const Padding(
                                                                                  padding: EdgeInsets.only(left: 10, right: 10.0),
                                                                                  child: Icon(
                                                                                    FontAwesomeIcons.whatsapp,
                                                                                    color: Color.fromARGB(255, 255, 124, 92),
                                                                                  ),
                                                                                ),
                                                                                fillColor: const Color.fromARGB(255, 232, 231, 230),
                                                                                filled: true,
                                                                                hintText: "Mobile Number",
                                                                                hintStyle: const TextStyle(color: Colors.black54),
                                                                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12)),
                                                                                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12)),
                                                                                border: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12))),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  actionsPadding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    right: 14,
                                                                    left: 14,
                                                                    bottom: 14,
                                                                  ),
                                                                  actions: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (_formKey.currentState?.validate() ??
                                                                            true) {
                                                                          makeDocNameForFirebase();

                                                                          mergeMaps(
                                                                              orderMap,
                                                                              toPay,
                                                                              newOrder);
                                                                          procesmap();
                                                                          updateTpData();
                                                                          setState(
                                                                              () {
                                                                            _name.clear();
                                                                            _number.clear();
                                                                            cartItems.clear();
                                                                          });

                                                                          Navigator.pop(
                                                                              context);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 10),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(14),
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              255,
                                                                              124,
                                                                              92),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "Submit",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        } else {
                                                          mergeMaps(orderMap,
                                                              toPay, newOrder);
                                                          procesmap();
                                                          updateTpData();
                                                          setState(() {});
                                                        }
                                                        _name.clear();
                                                        _number.clear();
                                                      },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "To Kitchen",
                                                      style: TextStyle(
                                                          color: cartItems
                                                                  .isEmpty
                                                              ? Colors.black
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      '₹ ${sumOfPending.toString()}',
                                                      style: TextStyle(
                                                          color: cartItems
                                                                  .isEmpty
                                                              ? Colors.black
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0, right: 15, left: 15, bottom: 15),
                                child: AnimatedContainer(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  height: isContainer1Expanded
                                      ? 50
                                      : size.height * 0.73,
                                  width: double.infinity,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOutExpo,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12.0,
                                      right: 8,
                                      left: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            toggleContainers();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "To Pay",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    color: Colors.white,
                                                    height: 26,
                                                  ),
                                                ),
                                                Text(
                                                  '₹ ${sumOfTp.toString()}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const DottedLine(
                                          dashColor: Colors.black,
                                          lineThickness: 2,
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: toPay.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                  color: const Color.fromARGB(
                                                      255, 232, 231, 230),
                                                ),
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          tpQuntity[index]
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      width: 280,
                                                      child: Text(
                                                        tpItem[index],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      '₹ ${(tpPriceOut[index] * tpQuntity[index]).toString()}',
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: buttonSize(),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 40,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape:
                                                      ContinuousRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          255, 124, 92, 1),
                                                ),
                                                onPressed: toPay.isEmpty
                                                    ? null
                                                    : () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              title: Text(
                                                                "Select payment method",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              actions: [
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child: ElevatedButton(
                                                                          onPressed: () async {
                                                                            Razorpay
                                                                                razorpay =
                                                                                Razorpay();

                                                                            var options =
                                                                                {
                                                                              'key': 'rzp_test_oQYeU0nxGKJOOj',
                                                                              'amount': sumOfTp * 100,
                                                                              'name': 'Restrorder',
                                                                              'description': 'Your Food',
                                                                            };
                                                                            razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                                                                _handlePaymentSuccess);
                                                                            razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                                                                _handlePaymentError);
                                                                            razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                                                                _handleExternalWallet);
                                                                            razorpay.open(options);
                                                                          },
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                82,
                                                                                64,
                                                                                114),
                                                                          ),
                                                                          child: const Text(
                                                                            "UPI",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              66,
                                                                              130,
                                                                              113),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection(dropdownvalue)
                                                                              .doc(docname1)
                                                                              .update({
                                                                            'complete':
                                                                                toPay,
                                                                            'Order':
                                                                                {},
                                                                            'newOrder':
                                                                                {},
                                                                            'Bill Status':
                                                                                true,
                                                                            'Amount':
                                                                                sumOfTp.toString(),
                                                                          });
                                                                          toPay
                                                                              .clear();
                                                                          sumOfTp =
                                                                              0;
                                                                          Navigator.pop(
                                                                              context);
                                                                          _printInvoice(
                                                                              context);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          "Cash",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "To Pay ",
                                                      style: TextStyle(
                                                          color: toPay.isEmpty
                                                              ? Colors.black
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      '₹ ${sumOfTp.toString()}',
                                                      style: TextStyle(
                                                          color: toPay.isEmpty
                                                              ? Colors.black
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
