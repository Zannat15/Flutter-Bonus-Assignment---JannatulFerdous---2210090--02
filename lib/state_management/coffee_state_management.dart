import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:summer_iub_app/models/coffee_records_model.dart';
import 'package:summer_iub_app/utility/constant.dart';


class CoffeeStateManagement with ChangeNotifier {
  List<CoffeeRecordsModel> items = [];

  final FirebaseFirestore _firestore= FirebaseFirestore.instance;

  void addData(){
    items.add(
      CoffeeRecordsModel(
        id: DateTime.now().microsecondsSinceEpoch,
        title: "Coffee Record ${items.length + 1}",
        des: "Details about Coffee Record ${items.length + 1}",
        amount: 10.0,
        date: DateTime.now(),
      )
    );

    notifyListeners();
  }


  void addCoffeeRecord(CoffeeRecordsModel coffeeRecord){
    items.add(
      CoffeeRecordsModel(
        id: DateTime.now().microsecondsSinceEpoch,
        title: coffeeRecord.title,
        des: coffeeRecord.des,
        amount: coffeeRecord.amount,
        date: coffeeRecord.date,
      )
      );
    notifyListeners();
  }

  Future<void> addCoffeeRecordToFirebase(CoffeeRecordsModel coffeeRecord) async {
    final dataModel = CoffeeRecordsModel(
        id: DateTime.now().microsecondsSinceEpoch,
        title: coffeeRecord.title,
        des: coffeeRecord.des,
        amount: coffeeRecord.amount,
        date: coffeeRecord.date,
      );

      final response = await _firestore.collection(FirebaseConstant.coffeeRecordsCollection).add(dataModel.toJson());
      final docId = response.id;

      await _firestore.collection(FirebaseConstant.coffeeRecordsCollection).doc(docId).update({'doc_id': docId});
  }
}


