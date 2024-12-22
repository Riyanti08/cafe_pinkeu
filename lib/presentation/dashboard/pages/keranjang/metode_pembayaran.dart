import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/core/assets/assets.gen.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';

void main() {
  runApp(const PaymentMethodApp());
}

class PaymentMethodApp extends StatelessWidget {
  const PaymentMethodApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PaymentMethodPage(),
    );
  }
}

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({Key? key}) : super(key: key);

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String selectedPaymentMethod = 'Bank BNI';
  bool isExpanded = false;

  final Map<String, String> paymentDetails = {
    'Bank BNI': '1234-5678-9012-3456',
    'Bank BCA': '9876-5432-1098-7654',
    'Dana': '0812-3456-7890',
    'Cash On Delivery': 'Bayar di tempat',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFCA6D5B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Metode Pembayaran',
          style: TextStyle(
            color: Color(0xFFCA6D5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transfer Bank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFCA6D5B),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildPaymentOption(
                      title: 'Bank BNI',
                      imagePath: Assets.images.bni.path,
                      isSelected: selectedPaymentMethod == 'Bank BNI',
                      onTap: () {
                        _selectPayment('Bank BNI');
                      },
                    ),
                    _buildPaymentOption(
                      title: 'Bank BCA',
                      imagePath: Assets.images.bca.path,
                      isSelected: selectedPaymentMethod == 'Bank BCA',
                      onTap: () {
                        _selectPayment('Bank BCA');
                      },
                    ),
                    _buildPaymentOption(
                      title: 'Dana',
                      imagePath: Assets.images.dana.path,
                      isSelected: selectedPaymentMethod == 'Dana',
                      onTap: () {
                        _selectPayment('Dana');
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Metode Pembayaran Lainnya',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFCA6D5B),
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Color(0xFFCA6D5B),
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded) ...[
                      const SizedBox(height: 8),
                      _buildPaymentOption(
                        title: 'Cash On Delivery',
                        imagePath: Assets.images.cod.path,
                        isSelected: selectedPaymentMethod == 'Cash On Delivery',
                        onTap: () {
                          _selectPayment('Cash On Delivery');
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, <String, dynamic>{
                    'method': selectedPaymentMethod,
                    'details': paymentDetails[selectedPaymentMethod],
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCA6D5B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Pilih Metode Pembayaran',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1: // Search
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
              break;
            case 2: // Cart
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
              break;
            case 3: // Notifications
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotifikasiPage()),
              );
              break;
            case 4: // Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.black, // Ikon Notifications berwarna hitam
            ),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black, // Ikon Profile berwarna hitam
            ),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Color(0xFFCA6D5B), // Warna untuk item yang terpilih
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Return hasil pilihan hanya saat tombol diklik
              Navigator.pop(context, <String, dynamic>{
                'method': selectedPaymentMethod,
                'details': paymentDetails[selectedPaymentMethod],
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCA6D5B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectPayment(String method) {
    setState(() {
      selectedPaymentMethod = method;
      // Hapus auto return di sini
    });
  }

  Widget _buildPaymentOption({
    required String title,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 2 : 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Color(0xFFCA6D5B) : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _selectPayment(title), // Hanya mengubah selection
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 46,
                height: 36,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Color(0xFFCA6D5B) : Colors.black87,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFCA6D5B),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
