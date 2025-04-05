import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:flutter/material.dart';

class CupcakeRainbowDetailPopup {
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
                  "Cupcake ini adalah pilihan terbaik untuk membawa kebahagiaan dan rasa yang lembut pada setiap gigitan. Cocok untuk momen spesial!",
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
