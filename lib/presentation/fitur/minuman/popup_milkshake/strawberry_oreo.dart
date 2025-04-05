import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:flutter/material.dart';

class StrawberryOreoDetailPopup {
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
                  "Strawberry Oreo adalah milkshake lezat dengan perpaduan stroberi segar dan remahan Oreo, menciptakan rasa manis dan creamy yang menggoda di setiap tegukan!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return const Icon(
                      Icons.star_border,
                      color: Color(0xFFA85100),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDE2E7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                  child: const Text("Masukkan Keranjang"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
