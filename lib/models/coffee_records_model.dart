import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeRecordsModel {
int? id;
String? title;
String? des;
double? amount;
DateTime? date;
String? docId;

  CoffeeRecordsModel({
   this.id,
   this.title,
   this.des,
   this.amount,
   this.date,
   this.docId,
  });

  /// Factory constructor to create a CoffeeRecordsModel from a JSON map.
  factory CoffeeRecordsModel.fromJson(Map<String, dynamic> json) {
    // Parse id which might be stored as int or String
    int? parsedId;
    final idValue = json['id'];
    if (idValue is int) {
      parsedId = idValue;
    } else if (idValue is String) {
      parsedId = int.tryParse(idValue);
    }

    // Parse amount which might be int/double or String
    double parsedAmount = 0.0;
    final amountValue = json['amount'];
    if (amountValue is num) parsedAmount = amountValue.toDouble();
    else if (amountValue is String) parsedAmount = double.tryParse(amountValue) ?? 0.0;

    // Parse date from several possible representations
    DateTime parsedDate = DateTime.now();
    final dateValue = json['date'];
    if (dateValue == null) {
      parsedDate = DateTime.now();
    } else if (dateValue is Timestamp) {
      parsedDate = dateValue.toDate();
    } else if (dateValue is DateTime) {
      parsedDate = dateValue;
    } else if (dateValue is String) {
      parsedDate = DateTime.tryParse(dateValue) ?? DateTime.now();
    } else if (dateValue is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(dateValue);
    }

    // doc id might be saved under different keys
    final docIdValue = json['doc_id'] ?? json['docId'] ?? json['docId'];

    return CoffeeRecordsModel(
      id: parsedId ?? 0,
      title: json['title'] as String? ?? '',
      des: json['des'] as String? ?? '',
      amount: parsedAmount,
      date: parsedDate,
      docId: docIdValue as String? ?? '',
    );
  }

  /// Converts this instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'des': des,
      'amount': amount,
      'date': Timestamp.fromDate(date ?? DateTime.now()),
      'doc_id': docId,
    };
  }

  /// Helper method to parse a JSON array string into a List<CoffeeRecordsModel>.
  static List<CoffeeRecordsModel> listFromJson(String source) {
    final List<dynamic> list = json.decode(source) as List<dynamic>;
    return list
        .map((item) => CoffeeRecordsModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Helper method to encode a List<CoffeeRecordsModel> to a JSON array string.
  static String listToJson(List<CoffeeRecordsModel> list) {
    return json.encode(list.map((item) => item.toJson()).toList());
  }
}