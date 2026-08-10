
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:summer_iub_app/screens/coffe_records_screen.dart';
import 'package:summer_iub_app/screens/create_coffee_record_screen.dart';
import 'package:summer_iub_app/screens/firebase_coffee_record.dart';
import 'package:summer_iub_app/state_management/coffee_state_management.dart';
import 'package:summer_iub_app/widgets/app_backgroud_design_widget.dart';

// ACM

class HomePage extends StatefulWidget {
  final String pageTitle;

  const HomePage({super.key, required this.pageTitle});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _coffeeCount = 0;

  Future<void> incrememntCoffeeCount() async {
    _coffeeCount++;
    setState(() {});
    print("Coffee Count: $_coffeeCount");

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> data = {
      'coffee_count': _coffeeCount,
      'timestamp': Timestamp.now(),
    };

    final response = await firestore.collection('coffee_counts').add(data);

    print("Coffee count added to Firestore with ID: ${response.id}");

    final DocumentSnapshot dataCollected =
        await firestore.collection('coffee_counts').doc(response.id).get();
    print("Data collected from Firestore: ${dataCollected.data()}");
  }

  void navigateToCoffeeRecordsScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CoffeRecordsScreen()));
  }

  void navigateToCreateCoffeeRecordScreen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CreateCoffeeRecordScreen()));
  }

  void navigateToFirebaseCoffeRecordsScreen() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FirebaseCoffeRecordsScreen()));
  }

  // Reusable pill-style white button with icon + chevron (matches design)
  Widget _buildPillButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46.00,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.brown,
          padding: const EdgeInsets.symmetric(horizontal: 16.00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18.00),
                const SizedBox(width: 8.00),
                Text(
                  label,
                  style: const TextStyle(fontSize: 15.00, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Positioned(
              right: 0,
              child: Icon(Icons.chevron_right, size: 20.00, color: Colors.brown),
            ),
          ],
        ),
      ),
    );
  }

  // Methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pageTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.00,
          ),
        ),
        backgroundColor: Colors.brown,
      ),
      body: AppBackgroudDesignWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.brown.shade600,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20.00, horizontal: 20.00),
              margin: const EdgeInsets.symmetric(horizontal: 20.00),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Welcome To Coffe House",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.00,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18.00),

                  _buildPillButton(
                    icon: Icons.shopping_cart,
                    label: "Order Now",
                    onPressed: navigateToCreateCoffeeRecordScreen,
                  ),

                  const SizedBox(height: 10.00),

                  _buildPillButton(
                    icon: Icons.local_fire_department,
                    label: "Check Firebase",
                    onPressed: navigateToFirebaseCoffeRecordsScreen,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30.00),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "How many coffee cups did you drink today?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 18.00,
                ),
              ),
            ),

            Text(
              _coffeeCount.toString(),
              style: const TextStyle(
                color: Colors.brown,
                fontSize: 36.00,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          incrememntCoffeeCount();
        },
        child: const Icon(Icons.local_cafe),
      ),
    );
  }
}