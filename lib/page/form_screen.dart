import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';

import '../api/pdf_api.dart';
import '../api/pdf_invoice_api.dart';
import '../constants.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../pdf_logic.dart';
import 'settings_page.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  static const double spacing = 15;
  final List<TextEditingController> _itemControllers = [];
  final List<TextEditingController> _feeControllers = [];
  final List<Widget> _itemAndRowFields = [];

  final TextEditingController _customerName = TextEditingController();
  String customerName = '';
  final TextEditingController _totalPaid = TextEditingController();
  String totalPaid = '0';
  int? totalExpected;

  // List<String> itemNames = [];
  List<InvoiceItem> itemNames = [];
  List<int> fees = [];
  String todayDate = '';
  int? totalPaidAsInt = 0;
  int? outstanding;
  Logger logger = Logger();

  @override
  void dispose() {
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    for (final controller in _feeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _addFields() {
    return ListTile(
      title: const Icon(Icons.add),
      onTap: () {
        final itemController = TextEditingController();
        final feeController = TextEditingController();
        final fields = Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: [
                // item's name field
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kLightGrey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: itemController,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),
                            labelText: "Item ${_itemControllers.length + 1}",
                            labelStyle: const TextStyle(
                              color: kblack,
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: kblack,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // end of item's name field

                const SizedBox(
                  width: spacing,
                ),

                // fee field
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: kLightGrey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: feeController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10.0),
                          isDense: true,
                          prefixText: 'NGN ', // TODO: set a method to get the currency the user choose from the configuration
                          labelText: "Fee ${_feeControllers.length + 1}",
                          labelStyle: const TextStyle(
                            color: kblack,
                          ),
                          floatingLabelStyle: const TextStyle(
                            color: kblack,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          
                        },
                      ),
                    ),
                  ),
                ),
                // end of fee field

                IconButton(
                  onPressed: () {
                    setState(() {
                      _itemAndRowFields.removeLast();
                      _itemControllers.removeLast();
                      _feeControllers.removeLast();
                    });
                  },
                  icon: const Icon(Icons.cancel),
                ),
              ],
            ));

        setState(() {
          //agregar
          _itemControllers.add(itemController);
          _feeControllers.add(feeController);
          _itemAndRowFields.add(fields);
        });
      },
    );
  }

  Widget _listView() {
    return ListView.builder(
        itemCount: _itemAndRowFields.length,
        itemBuilder: (context, index) {
          return Container(
            child: _itemAndRowFields[index],
          );
        });
  }

  void showInSnackBar(context, String value) {
    final snackBar = SnackBar(
      content: Text(value),
      backgroundColor: kred,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: kwhite,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Generator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // customer name field
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: kLightGrey,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                  controller: _customerName,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: "Customer's Name",
                    labelStyle: TextStyle(
                      color: kblack,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: kblack,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    customerName = value;
                  },
                ),
              ),
            ),
          ),
          // end of customer name field
          const SizedBox(
            height: spacing,
          ),
          Expanded(
            child: _listView(),
          ),
          _addFields(),

          // total paid field
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: kLightGrey,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                  controller: _totalPaid,
                  cursorColor: kblack,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    color: kblack,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    prefixText: 'NGN ',
                    labelText: 'Total Paid',
                    labelStyle: TextStyle(
                      color: kblack,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: kblack,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    totalPaid = value;

                    logger.i("Total paid => " + totalPaid);
                  },
                ),
              ),
            ),
          ),
          // end of total paid field

          const SizedBox(
            height: spacing,
          ),

          Center(
            child: MaterialButton(
              onPressed: () {
                logger.v("total paid field: " + _totalPaid.text);

                if (_customerName.text.isEmpty) {
                  showInSnackBar(
                      context, 'Please enter in the Customer\'s Name.');
                } else if (itemNames.length < 1) {
                  showInSnackBar(context, "Please add items");
                } else if (totalPaid == '0') {
                  showInSnackBar(context, 'Please enter the total paid.');
                }
                else {
                  // makes sure the lists are empty before adding new values.
                  // This is especially useful for when a user generates a PDF,
                  // then goes back to make changes to the entered values.
                  itemNames.clear();
                  fees.clear();
                }

                // adds content of non-empty text fields for item names and
                // adds them to itemNames list
                _itemControllers
                    .where((element) => element.text != '')
                    .forEach((element) {
                  itemNames = [
                    InvoiceItem(
                      description: element.text,
                      date: DateTime.now(),
                      quantity: 3, //TODO: ADD QUANTITY
                      vat: 0.19, //TODO: ADD VAT
                      unitPrice: 5.99, //TODO: ADD price
                    ),
                  ];
                });

                // converts content of non-empty text fields for fees to ints
                // and adds them to fees list
                _feeControllers
                    .where((element) => element.text != '')
                    .forEach((element) async {
                  logger.v("FEES COUNTING...");
                  logger.v(int.parse(element.text));
                  fees.add(int.parse(element.text) + 1);

                  totalPaidAsInt = int.parse(this.totalPaid);
                  // sums up the fees expected to be paid TODO: Add validation when its in blank
                  totalExpected = fees.fold(
                      0, (previousValue, current) => previousValue! + current);
                  outstanding = totalExpected! - totalPaidAsInt!;

                  todayDate = Jiffy(DateTime.now()).format('do MMM yyyy');

                  if (totalPaidAsInt! > totalExpected!) {
                    showInSnackBar(context,
                        'Total Expected cannot be higher than Total Paid.');
                    logger.v(
                        "total totalpaid => ${totalPaidAsInt} - total expected => $totalExpected");
                  } else if (itemNames.length > fees.length) {
                    showInSnackBar(context, 'Please fill in the missing fee.');
                    logger.v(
                        " itemNames: ${itemNames.length} - FEES: ${fees.length}");

                   
                  } else if (itemNames.length < fees.length) {
                    showInSnackBar(
                        context, 'Please fill in the missing item name.');
                   
                  } else {
                    
                    PDFLogic pdf = PDFLogic(
                      customerName: customerName,
                      todayDate: todayDate,
                      itemNames: itemNames,
                      fees: fees,
                      totalExpected: totalExpected!,
                      totalPaid: _totalPaid.text,
                      outstanding: outstanding!,
                    );
                    logger.i("HERE GOES THE PDF");
                    logger.v("${pdf.customerName}");
                    logger.v("${pdf.fees}");
                    logger.v("${pdf.itemNames}");
                    logger.v("${pdf.todayDate}");
                    logger.v("PRUEBA");
                    // pdf.generateInvoice();
                    //send the data from here...

                    final invoice = Invoice(
                      supplier: Supplier(
                        name: 'Sarah Field',
                        address: 'Sarah Street 9, Beijing, China',
                        paymentInfo: 'https://paypal.me/sarahfieldzz',
                      ),
                      customer: Customer(
                        name: 'Apple Inc.',
                        address: 'Apple Street, Cupertino, CA 95014',
                      ),
                      info: InvoiceInfo(
                        date: DateTime.now(),
                        dueDate: DateTime.now(),
                        description: 'My description...',
                        number: '${DateTime.now().year}-9999',
                      ),
                      items: [
                        InvoiceItem(
                          description: 'Coffee',
                          date: DateTime.now(),
                          quantity: 3,
                          vat: 0.19,
                          unitPrice: 5.99,
                        ),
                        InvoiceItem(
                          description: 'Water',
                          date: DateTime.now(),
                          quantity: 8,
                          vat: 0.19,
                          unitPrice: 0.99,
                        ),
                        InvoiceItem(
                          description: 'Orange',
                          date: DateTime.now(),
                          quantity: 3,
                          vat: 0.19,
                          unitPrice: 2.99,
                        ),
                        InvoiceItem(
                          description: 'Apple',
                          date: DateTime.now(),
                          quantity: 8,
                          vat: 0.19,
                          unitPrice: 3.99,
                        ),
                        InvoiceItem(
                          description: 'Mango',
                          date: DateTime.now(),
                          quantity: 1,
                          vat: 0.19,
                          unitPrice: 1.59,
                        ),
                        InvoiceItem(
                          description: 'Blue Berries',
                          date: DateTime.now(),
                          quantity: 5,
                          vat: 0.19,
                          unitPrice: 0.99,
                        ),
                        InvoiceItem(
                          description: 'Lemon',
                          date: DateTime.now(),
                          quantity: 4,
                          vat: 0.19,
                          unitPrice: 1.29,
                        ),
                      ],
                    );
                    final pdfFile = await PdfInvoiceApi.generate(invoice);

                    PdfApi.openFile(pdfFile);
                  }
                });
              },
              minWidth: double.infinity,
              height: 70,
              elevation: 3,
              color: kred,
              child: const Text(
                'Generate Invoice',
                style: TextStyle(
                  fontSize: 25,
                  color: kwhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: FIND CONNECTION WHERE INFO IS SENT TO CONTROLLERS
// TODO: SEND DATA TO THE CONNECTION OF THE OTHER PDF LOGIC
// TODO FIND WHERE AND HOW FIELDS ARE ADDED
// TODO: CUSTOMIZE FIELDS, ADD AUTOMATIC TOTALS
