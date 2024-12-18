import 'package:flutter/material.dart';

void main() {
  runApp(const DeliveryOptionApp());
}

class DeliveryOptionApp extends StatelessWidget {
  const DeliveryOptionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DeliveryOptionPage(),
    );
  }
}

class DeliveryOptionPage extends StatefulWidget {
  const DeliveryOptionPage({Key? key}) : super(key: key);

  @override
  _DeliveryOptionPageState createState() => _DeliveryOptionPageState();
}

class _DeliveryOptionPageState extends State<DeliveryOptionPage> {
  String selectedOption = 'Reguler';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Opsi Pengiriman',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Jasa Pengiriman',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildDeliveryOption(
              title: 'Express',
              description: '25 Menit',
              price: 'Rp 18.000',
              isSelected: selectedOption == 'Express',
              onTap: () {
                setState(() {
                  selectedOption = 'Express';
                });
              },
            ),
            const SizedBox(height: 8),
            _buildDeliveryOption(
              title: 'Reguler',
              description: '30 - 40 Menit',
              price: 'Rp 15.000',
              isSelected: selectedOption == 'Reguler',
              onTap: () {
                setState(() {
                  selectedOption = 'Reguler';
                });
              },
            ),
            const SizedBox(height: 8),
            _buildDeliveryOption(
              title: 'Ekonomis',
              description: '50 - 60 Menit',
              price: 'Rp 8.000',
              isSelected: selectedOption == 'Ekonomis',
              onTap: () {
                setState(() {
                  selectedOption = 'Ekonomis';
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade100,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                // Handle confirmation logic
              },
              child: const Text(
                'Konfirmasi',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryOption({
    required String title,
    required String description,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.pink : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.pink.shade50 : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? Colors.pink : Colors.grey,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}