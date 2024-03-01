import 'dart:async';
import 'dart:typed_data';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restrorder/Kitchen/dashboardScreen.dart';
import 'package:restrorder/Waiter/waiterData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
    FirebaseFirestore.instance.collection(dropdownvalue).doc(docname1).update(
        {'complete': toPay, 'Order': {}, 'newOrder': {}, 'Bill Status': true});
    toPay.clear();
    sumOfTp = 0;
    Navigator.pop(context);
    setState(() {});
    print("Payment Success");
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Error Occcues");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
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

  TextEditingController _name = TextEditingController();
  TextEditingController _number = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.reference();
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
    print(count1);
    count = count1;
    print(count);
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

  List Table = [
    "Table 1",
    "Table 2",
    "Table 3",
    "Table 4",
    "Table 5",
    "Table 6"
  ];

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
        print(resultList1);

        int sum1 = 0;

        for (int number in resultList1) {
          sum1 += number;
        }
        sumOfTp = sum1;
      });
      setState(() {});
    } else {
      // If there are no documents in the collection, return null
      print("null");
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
            .collection('Menu')
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
    print(docname);

    print("To Pay");
  }

  var dropdownvalue = "Table 1";

  bool isContainer1Expanded = true;
  bool isContainer2Expanded = false;
  List<bool> isSelected = [true, false];

  void toggleContainers() {
    print("its called");

    setState(() {
      isContainer1Expanded = !isContainer1Expanded;
      isContainer2Expanded = !isContainer2Expanded;
    });

    print("its change");
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  void updateTable1() {
    databaseReference.child(dropdownvalue).update(orderMap).then((_) {
      print("success");
    }).catchError((error) {
      print('Error updating property: $error');
    });
  }

  void mergeMaps(Map<String, dynamic> map1, Map<String, dynamic> map2,
      Map<String, dynamic> map3) async {
    var firstmap = map1;

    map2.forEach((key, value) {
      if (firstmap.containsKey(key)) {
        // If the key already exists in map1, combine the values
        firstmap[key] = firstmap[key as String]! + value as num;
      } else {
        // If the key doesn't exist in map1, add it
        firstmap[key] = value;
      }
    });

    orderMap = firstmap;

    print(orderMap);
    print(toPay);
    Map complete = {};

    FirebaseFirestore.instance.collection(dropdownvalue).doc(docname1).set({
      'Order': orderMap,
      'Name': _name.text,
      'Number': _number.text,
      'newOrder': map3,
      'complete': complete,
      'Bill Status': false
    });
    _database.child(dropdownvalue).remove();

    orderMap.clear();
    newOrder.clear();

    setState(() {});
  }

  Future<List<DataSnapshot>> getAllData(String dropdownValue) async {
    try {
      // Get reference to the data
      final reference = _database.child(dropdownValue);

      // Get a list of snapshots
      final event = await reference.once();

      // Check if any data exists
      if (event.snapshot.exists) {
        // List to store snapshots
        final List<DataSnapshot> data = [];

        // Iterate through each childsen
        for (final childSnapshot in event.snapshot.children) {
          data.add(childSnapshot);
        }

        return data;
      } else {
        return [];
      }
    } catch (error) {
      print('Error retrieving data: $error');

      return [];
    }
  }

  void procesmap() async {
    final dropdownvalue1 = dropdownvalue;
    final data = await getAllData(dropdownvalue1);

    List cartKey = [];
    List cartValue = [];

    if (data.isNotEmpty) {
      // Process the list of data snapshots
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
      print(Price);

      cartPriceOut = Price;
      IterableZip zipResult = IterableZip([cartPriceOut, quantity]);

      for (List elements in zipResult) {
        // Multiply corresponding elements and add the result to the new list
        resultList.add(elements[0] * elements[1]);
      }
      print(resultList);

      int sum = 0;

      for (int number in resultList) {
        sum += number;
      }
      sumOfPending = sum;
      print(sum);

      orderMap.clear();

      orderMap = Map.fromIterables(
        cartItems
            .map((item) => item.toString()), // Ensure each item is a String
        quantity.map((qty) => qty as int), // Ensure each qty is an int
      );

      setState(() {});
      print(orderMap);
    } else {
      cartItems = cartKey;
      quantity = cartValue;
      sumOfPending = 0;
      setState(() {});
    }
  }

  void handleItemClick(String itemName) {
    setState(() {
      // Use the null-aware operator ?? to provide a default value of 0
      int currentQuantity = orderMap[itemName] ?? 0;

      // If the item is not in the order, add it with quantity 1
      orderMap[itemName] = currentQuantity + 1;
    });
    int currentQuantityfornew = newOrder[itemName] ?? 0;
    newOrder[itemName] = currentQuantityfornew + 1;
  }

  int count = 0;

  Future<void> _printInvoice(BuildContext context) async {
    final pdf = await generateInvoice();

    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf,
    );
  }

  Future<Uint8List> generateInvoice() async {
    final pdf = pw.Document();

    // Add your content to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => _buildInvoice(),
      ),
    );

    // Save the PDF to a file or return it as Uint8List
    return pdf.save();
  }

  pw.Widget _buildInvoice() {
    // Customize this method to build your invoice content
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Restrorder', style: pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 10),
          pw.Text('Invoice Number: ${docname1}'),
          pw.SizedBox(height: 10),
          pw.Text('Date: ${DateTime.now().toLocal()}'),
          pw.SizedBox(height: 20),
          pw.Row(children: [
          pw.Text('Items:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(width: 200),
              pw.Text('quantity:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

          ]),
          pw.SizedBox(height: 10),
          _buildInvoiceItems(),
          pw.SizedBox(height: 20),
          pw.Text('Total:  Rs  ${sumOfTp}'),
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

    print("Rebuild");
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
        centerTitle: true,
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,

        // title: const MyTextField(),
        leading: Padding(
          padding: EdgeInsets.only(left: 18.0),
          child: Center(
              child: GestureDetector(
            onTap: () => print(size.height),
            child: Text(
              "Restrorder",
              style: GoogleFonts.roboto(color: Colors.black),
            ),
          )),
          // child: Image(
          //   image: AssetImage('Assets/Images/logoblack.png'),
          //   fit: BoxFit.fitHeight,
          // ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const KitchenDashboardScreen(),
                  ));
                },
                icon: const Icon(
                  Icons.chat,
                  color: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
      backgroundColor: Colors.white,
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
                    // width: 850,
                    height: size.height * 0.30,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 20, right: 20),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
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
                              print(menu[index]);
                            },
                            child: SizedBox(
                              height: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: color[index],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                // width: 200,
                                // color of grid items
                                child: Center(
                                  child: Text(
                                    menu[index],
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
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
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 232, 231, 230),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    // width: size.width * 0.6,
                    width: double.infinity,
                    height: 50,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: Catagory.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                    style: GoogleFonts.roboto(
                                        color: selectedIndex == index
                                            ? Colors
                                                .white // Text color when selected
                                            : Colors
                                                .black, // Text color when unselected
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5),
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
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      height: double.infinity,
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.5,
                          crossAxisCount: 3,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 30.0,
                        ),
                        itemBuilder: (context, index) {
                          String itemName = MenuItem.keys.elementAt(index);
                          int itemPrice = MenuItem[itemName];

                          return GestureDetector(
                            onTap: () async {
                              print("Me");

                              handleItemClick(itemName);
                              print(orderMap);
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
                                        color: Colors.black, width: 2),
                                  ),
                                  color: Color.fromARGB(255, 232, 231, 230),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        maxLines: 2,
                                        itemName,
                                        style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 16,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      AutoSizeText('₹ ${itemPrice.toString()}',
                                          maxLines: 1,
                                          style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
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
                            color: const Color.fromARGB(255, 232, 231, 230),
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, left: 16),
                              child: Text(
                                "Select Table",
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: Container(
                                width: double.infinity,
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: const Border(
                                      bottom: BorderSide.none,
                                    )),
                                child: Center(
                                  child: DropdownButton(
                                    borderRadius: BorderRadius.circular(20),
                                    alignment: Alignment.center,
                                    dropdownColor: Colors.white,
                                    isExpanded: true,
                                    underline: Container(),
                                    padding: const EdgeInsets.only(left: 10),
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    isDense: true,
                                    value: dropdownvalue,
                                    onChanged: (newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                        orderMap.clear();

                                        newOrder.cast();
                                        toPay.clear();
                                        tpItem.clear();
                                        tpQuntity.clear();
                                        sumOfTp = 0;

                                        // _updateCartItems();
                                        updateTable1();
                                        procesmap();
                                        updateDocId();
                                        updateTpData();
                                      });
                                      setState(() {});
                                    },
                                    items: Table.map<DropdownMenuItem>((value) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
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
                                      ? size.height * 0.65
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
                                            print("Hello");
                                            toggleContainers();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8),
                                            child: Row(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Pending",
                                                  style: GoogleFonts.roboto(
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
                                                  style: GoogleFonts.roboto(
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
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        Expanded(
                                          flex: 7,
                                          child: ListView.builder(
                                            // shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: cartItems.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0,
                                                    right: 8.0,
                                                    left: 8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: const Color.fromARGB(
                                                        255, 215, 212, 211),
                                                  ),
                                                  // height: 60,
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                                style: GoogleFonts.roboto(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                            Text(
                                                              '₹  ${cartPriceOut[index].toString()}',
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            IconButton(
                                                                onPressed:
                                                                    () async {
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
                                                                    orderMap
                                                                        .clear();
                                                                    newOrder
                                                                        .clear();
                                                                  } else {
                                                                    orderMap[cartItems[
                                                                            index]] =
                                                                        (orderMap[cartItems[index]]! -
                                                                            1);
                                                                    newOrder[cartItems[
                                                                            index]] =
                                                                        (newOrder[cartItems[index]]! -
                                                                            1);
                                                                    updateTable1();
                                                                  }

                                                                  procesmap();

                                                                  print(
                                                                      orderMap);
                                                                  setState(
                                                                      () {});
                                                                  //
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .remove)),
                                                            Text(
                                                              quantity[index]
                                                                  .toString(),
                                                              style: GoogleFonts.roboto(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  orderMap[cartItems[
                                                                          index]] =
                                                                      (orderMap[
                                                                              cartItems[index]]! +
                                                                          1);
                                                                  newOrder[cartItems[
                                                                          index]] =
                                                                      (newOrder[
                                                                              cartItems[index]]! +
                                                                          1);

                                                                  updateTable1();
                                                                  procesmap();

                                                                  print(
                                                                      cartItems);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon: const Icon(
                                                                    Icons.add))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: buttonSize(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 50,
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape:
                                                      ContinuousRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 255, 124, 92),
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
                                                                  buttonPadding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                  actions: [
                                                                    Container(
                                                                      height:
                                                                          230,
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Form(
                                                                        key:
                                                                            _formKey,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return 'Please enter some text';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                controller: _name,
                                                                                decoration: InputDecoration(
                                                                                    contentPadding: const EdgeInsets.all(10),
                                                                                    prefixIcon: const Padding(
                                                                                      padding: EdgeInsets.only(left: 10, right: 10.0),
                                                                                      child: Icon(
                                                                                        Icons.person,
                                                                                        // fill: Checkbox.width,
                                                                                        color: const Color.fromARGB(255, 255, 124, 92),
                                                                                      ),
                                                                                    ),
                                                                                    fillColor: const Color.fromARGB(255, 242, 242, 242),
                                                                                    filled: true,
                                                                                    hintText: "Name",
                                                                                    hintStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                                                                                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12)),
                                                                                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12)),
                                                                                    border: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12))),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return 'Please enter Mobile Number';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                controller: _number,
                                                                                keyboardType: TextInputType.number,
                                                                                decoration: InputDecoration(
                                                                                    contentPadding: const EdgeInsets.all(10),
                                                                                    prefixIcon: const Padding(
                                                                                      padding: EdgeInsets.only(left: 10, right: 10.0),
                                                                                      child: Icon(
                                                                                        FontAwesomeIcons.whatsapp,
                                                                                        // fill: Checkbox.width,
                                                                                        color: const Color.fromARGB(255, 255, 124, 92),
                                                                                      ),
                                                                                    ),
                                                                                    fillColor: const Color.fromARGB(255, 242, 242, 242),
                                                                                    filled: true,
                                                                                    hintText: "Number",
                                                                                    hintStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                                                                                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12)),
                                                                                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12)),
                                                                                    border: OutlineInputBorder(borderSide: const BorderSide(width: 0, style: BorderStyle.solid, color: Color.fromARGB(255, 255, 255, 255)), borderRadius: BorderRadius.circular(12))),
                                                                              ),
                                                                            ),
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  if (_formKey.currentState?.validate() ?? true) {
                                                                                    makeDocNameForFirebase();

                                                                                    print(_name);
                                                                                    print(_number);

                                                                                    mergeMaps(orderMap, toPay, newOrder);
                                                                                    procesmap();
                                                                                    updateTpData();
                                                                                    setState(() {});
                                                                                    _name.clear();
                                                                                    _number.clear();

                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  width: size.width * 0.05,
                                                                                  height: 30,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(14),
                                                                                    color: const Color.fromARGB(255, 255, 124, 92),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "Ok",
                                                                                      style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                );
                                                              });
                                                        } else {
                                                          mergeMaps(orderMap,
                                                              toPay, newOrder);
                                                          procesmap();
                                                          updateTpData();
                                                          print(cartPriceOut);
                                                          setState(() {});
                                                        }
                                                        _name.clear();
                                                        _number.clear();
                                                        print(
                                                            "Send Data to the Kitchen");
                                                      },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "To Kitchen",
                                                      style: GoogleFonts.roboto(
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
                                                      style: GoogleFonts.roboto(
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
                                      : size.height * 0.65,
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
                                            print("Hello");
                                            toggleContainers();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8),
                                            child: Row(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "To Pay",
                                                  style: GoogleFonts.roboto(
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
                                                  style: GoogleFonts.roboto(
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
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    right: 6,
                                                    left: 6,
                                                    bottom: 8),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: const Color.fromARGB(
                                                        255, 215, 212, 211),
                                                  ),
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 10),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: Center(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                tpQuntity[index]
                                                                    .toString()),
                                                          )),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        SizedBox(
                                                          width: 120,
                                                          child: Text(
                                                            tpItem[index],
                                                            style: GoogleFonts.roboto(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                            '₹ ${tpPriceOut[index].toString()}'),
                                                      ],
                                                    ),
                                                  ),
                                                  // child: Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   children: [
                                                  //     Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(
                                                  //               left: 10.0),
                                                  //       child: Container(
                                                  //         decoration:
                                                  //             const BoxDecoration(
                                                  //                 color: Colors
                                                  //                     .white,
                                                  //                 shape: BoxShape
                                                  //                     .circle),
                                                  //         child: Center(
                                                  //             child: Padding(
                                                  //           padding:
                                                  //               const EdgeInsets
                                                  //                   .all(8.0),
                                                  //           child: Text(
                                                  //               tpQuntity[
                                                  //                       index]
                                                  //                   .toString()),
                                                  //         )),
                                                  //       ),
                                                  //     ),
                                                  //     Flexible(
                                                  //       child: Padding(
                                                  //         padding:
                                                  //             const EdgeInsets
                                                  //                 .symmetric(
                                                  //                 horizontal:
                                                  //                     10.0,
                                                  //                 vertical:
                                                  //                     10),
                                                  //         child: Text(
                                                  //           tpItem[index],
                                                  //           style: GoogleFonts.roboto(
                                                  //               color: Colors
                                                  //                   .black,
                                                  //               fontSize: 15,
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .w500),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //     Spacer(),
                                                  //     Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(
                                                  //               right: 10.0),
                                                  //       child: Text(
                                                  //           '₹ ${tpPriceOut[index].toString()}'),
                                                  //     )
                                                  //   ],
                                                  // ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: buttonSize(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 40,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape:
                                                      ContinuousRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          255, 124, 92, 1),
                                                ),
                                                onPressed: toPay.isEmpty
                                                    ? null
                                                    : () {
                                                        // print("hello");
                                                        // print(orderMap);
                                                        // FirebaseFirestore.instance
                                                        //     .collection(
                                                        //         dropdownvalue)
                                                        //     .doc(docname1)
                                                        //     .update({
                                                        //   'complete': toPay,
                                                        //   'Order': {},
                                                        //   'newOrder': {}
                                                        // });
                                                        // toPay.clear();
                                                        // sumOfTp = 0;
                                                        // setState(() {});

                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                                actionsAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                actions: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Choose Payment Method",
                                                                        style: GoogleFonts.roboto(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.black),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () async {
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
                                                                          style: ElevatedButton
                                                                              .styleFrom(
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                82,
                                                                                64,
                                                                                114),
                                                                          ),
                                                                          child:
                                                                              const Text(
                                                                            "UPI",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                      ElevatedButton(
                                                                          style: ElevatedButton
                                                                              .styleFrom(
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                66,
                                                                                130,
                                                                                113),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            FirebaseFirestore.instance.collection(dropdownvalue).doc(docname1).update({
                                                                              'complete': toPay,
                                                                              'Order': {},
                                                                              'newOrder': {},
                                                                              'Bill Status': false
                                                                            });
                                                                            toPay.clear();
                                                                            sumOfTp =
                                                                                0;
                                                                            Navigator.pop(context);
                                                                            setState(() {});
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            "Cash",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                      ElevatedButton(
                                                                          style: ElevatedButton
                                                                              .styleFrom(
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                51,
                                                                                51,
                                                                                50),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            FirebaseFirestore.instance.collection(dropdownvalue).doc(docname1).update({
                                                                              'complete': toPay,
                                                                              'Order': {},
                                                                              'newOrder': {},
                                                                              'Bill Status': false
                                                                            });
                                                                            toPay.clear();
                                                                            sumOfTp =
                                                                                0;
                                                                            Navigator.pop(context);
                                                                            setState(() {});
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            "Card",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                      ElevatedButton(
                                                                          onPressed: () => _printInvoice(
                                                                              context),
                                                                          child:
                                                                              Text("Generate Invoice"))
                                                                    ],
                                                                  ),
                                                                ]);
                                                          },
                                                        );

                                                        // showModalBottomSheet(
                                                        //   isScrollControlled: true,
                                                        //     context: context,
                                                        //     builder: (context) {
                                                        //       return Column(
                                                        //         children: [
                                                        //           Expanded(
                                                        //             child:
                                                        //                 InAppWebView(
                                                        //               initialUrlRequest:
                                                        //                   URLRequest(
                                                        //                       url:
                                                        //                           Uri.parse('https://flutter.dev')),
                                                        //               initialOptions:
                                                        //                   InAppWebViewGroupOptions(
                                                        //                 crossPlatform:
                                                        //                     InAppWebViewOptions(
                                                        //                   javaScriptEnabled:
                                                        //                       true,
                                                        //                 ),
                                                        //               ),
                                                        //             ),
                                                        //           ),
                                                        //         ],
                                                        //       );
                                                        //     });
                                                      },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "To Pay ",
                                                      style: GoogleFonts.roboto(
                                                          color: toPay.isEmpty
                                                              ? Colors.black
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      '₹ ${sumOfTp.toString()}',
                                                      style: GoogleFonts.roboto(
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

// class YourBodyWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (context) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ListTile(
//                     leading: const Icon(Icons.camera),
//                     title: const Text('Camera'),
//                     onTap: () {
//                       // Handle camera tap
//                     },
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.photo),
//                     title: const Text('Gallery'),
//                     onTap: () {
//                       // Handle gallery tap
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//         child: const Text('Show Bottom Sheet'),
//       ),
//     );
//   }
// }

class MyTextField extends StatefulWidget {
  const MyTextField({super.key});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  // final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 21, 41, 74),
            ),
            child: Center(
              child: Text(
                "Dine In",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )),
    );
  }
}
