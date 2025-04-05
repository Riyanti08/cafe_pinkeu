import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:flutter/material.dart';

class StrawberryRollCakeDetailPopup {
  static void show(BuildContext context, Map<String, dynamic> cupcake) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cupcake['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCA6D5B),
                  ),
                ),
                const SizedBox(height: 8),
                Image.asset(
                  cupcake['image'],
                  width: 53,
                  height: 69,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Strawberry Roll Cake adalah kue gulung lembut dengan krim manis dan potongan stroberi segar, memberikan perpaduan rasa yang segar dan menggugah selera!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
