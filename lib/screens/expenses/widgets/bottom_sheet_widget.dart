import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../models/transactions.dart';

class BottomSheetWidget extends StatefulWidget {
  final Transactions? trans;
  final Function(Transactions) onClicked;

  const BottomSheetWidget({
    Key? key,
    this.trans,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final formKey = GlobalKey<FormState>();
  String type = 'Income';
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  bool isIncome = true;
  String? selectedCategory;

  List<Map<String, dynamic>> categoryData = [];

  Future<void> fetchCategoryData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    categoryData =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {});
  }

  @override
  void initState() {
    fetchCategoryData();

    if (widget.trans != null) {
      priceController.text = widget.trans!.amount.toString();
      descController.text = widget.trans!.desc;
      type = widget.trans!.type;
      isIncome = type == 'Income' ? true : false;
      selectedCategory = widget.trans!.category;
    } else {
      selectedCategory = null;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List categoryNames = categoryData.map((data) => data['name']).toList();
    categoryNames.remove('All');

    List<DropdownMenuItem> dropdownItems = categoryNames.map((category) {
      return DropdownMenuItem(
        value: category,
        child: Text(category),
      );
    }).toList();

    return Padding(
        padding: EdgeInsets.only(
            right: 20,
            left: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 40),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "cancel-text".i18n(),
                            style: const TextStyle(color: Colors.teal),
                          )),
                      Text(
                        widget.trans == null
                            ? "add-text".i18n()
                            : "edit-text".i18n(),
                        style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      TextButton(
                          child: Text(
                            "done-text".i18n(),
                            style: const TextStyle(color: Colors.teal),
                          ),
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            } else {
                              final newTransaction = Transactions(
                                desc: descController.text,
                                amount: double.parse(priceController.text),
                                type: type,
                                category:
                                    selectedCategory ?? categoryNames.first,
                              );
                              if (widget.trans != null) {
                                newTransaction.uniqueId =
                                    widget.trans!.uniqueId;
                              }
                              widget.onClicked(newTransaction);
                            }

                            Navigator.pop(context);
                          }),
                    ],
                  ),
                  const Divider(),
                  DropdownButton(
                    value: selectedCategory,
                    items: dropdownItems,
                    hint: Text("select-text".i18n()),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                  ),
                  TextFormField(
                    controller: priceController,
                    validator: (value) {
                      if ((value?.isEmpty ?? true) ||
                          double.parse(value!) <= 0.0) {
                        return "price-not-number-message-text".i18n();
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "price-text".i18n(),
                        prefixIcon: const Icon(Icons.price_check),
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    validator: (value) {
                      if (value!.isNotEmpty && value.length > 2) {
                        return null;
                      } else {
                        return "desc-empty-message-text".i18n();
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "desc-text".i18n(),
                        prefixIcon: const Icon(Icons.money),
                        border: const OutlineInputBorder()),
                    controller: descController,
                  ),
                  RadioListTile(
                    activeColor: Colors.teal,
                    title: Text("income-text".i18n()),
                    value: true,
                    groupValue: isIncome,
                    onChanged: (context) {
                      setState(() {
                        isIncome = true;
                        type = 'Income';
                      });
                    },
                  ),
                  RadioListTile(
                    activeColor: Colors.teal,
                    title: Text("outcome-text".i18n()),
                    value: false,
                    groupValue: isIncome,
                    onChanged: (context) {
                      setState(() {
                        isIncome = false;
                        type = 'Outcome';
                      });
                    },
                  ),
                ]),
              ),
            )
          ],
        ));
  }
}
