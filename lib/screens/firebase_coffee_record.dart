import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summer_iub_app/models/coffee_records_model.dart';
import 'package:summer_iub_app/state_management/coffee_state_management.dart';
import 'package:summer_iub_app/utility/constant.dart';

import 'package:summer_iub_app/widgets/app_backgroud_design_widget.dart';

class FirebaseCoffeRecordsScreen extends StatefulWidget {
  const FirebaseCoffeRecordsScreen({super.key,});

  @override
  State<FirebaseCoffeRecordsScreen> createState() => _FirebaseCoffeRecordsScreenState();
}

class _FirebaseCoffeRecordsScreenState extends State<FirebaseCoffeRecordsScreen> {
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Coffee Records",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.00,
          ),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),

      body: AppBackgroudDesignWidget(
            child: StreamBuilder(
              stream: firestore.collection(FirebaseConstant.coffeeRecordsCollection).orderBy('date', descending: true).snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No coffee records found."));
                }
                else{
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder:(context, index){
                
                      final coffeeRecord = CoffeeRecordsModel.fromJson(snapshot.data!.docs[index].data());
                
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.coffee),
                          title: Text(coffeeRecord.title!),
                          subtitle: Text("${coffeeRecord.des} - Amount: ${coffeeRecord.amount} - ID: (${coffeeRecord.id})"),
                        ),
                      );
                    }
                  );
                }
              }
            ),
          
          ),

      floatingActionButton: Consumer<CoffeeStateManagement>(
        builder: (context,csm,_) {
          return FloatingActionButton(
            onPressed: () {
              csm.addCoffeeRecordToFirebase(CoffeeRecordsModel(
                id: DateTime.now().microsecondsSinceEpoch,
                title: "Coffee Record ${csm.items.length + 1}",
                des: "Details about test Coffee Record",
                amount: 10.0,
                date: DateTime.now(),
              ));
              setState(() {});
            },
            child: Icon(Icons.local_cafe),
          );
        }
      ),
    );
  }
}