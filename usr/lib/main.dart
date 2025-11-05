import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'خرید بسته اینترنت',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F7F8),
        // Define the accent color and other theme properties to match the HTML prototype
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A859),
          primary: const Color(0xFF00A859),
          secondary: const Color(0xFF008A4F),
          background: const Color(0xFFF5F7F8),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Vazirmatn'),
          bodyMedium: TextStyle(fontFamily: 'Vazirmatn'),
          displayLarge: TextStyle(fontFamily: 'Vazirmatn'),
          displayMedium: TextStyle(fontFamily: 'Vazirmatn'),
          displaySmall: TextStyle(fontFamily: 'Vazirmatn'),
          headlineMedium: TextStyle(fontFamily: 'Vazirmatn'),
          headlineSmall: TextStyle(fontFamily: 'Vazirmatn'),
          titleLarge: TextStyle(fontFamily: 'Vazirmatn'),
          titleMedium: TextStyle(fontFamily: 'Vazirmatn'),
          titleSmall: TextStyle(fontFamily: 'Vazirmatn'),
          bodySmall: TextStyle(fontFamily: 'Vazirmatn'),
          labelLarge: TextStyle(fontFamily: 'Vazirmatn'),
          labelSmall: TextStyle(fontFamily: 'Vazirmatn'),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A859),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Vazirmatn'),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Data models
class InternetPackage {
  final int id;
  final String name;
  final String size;
  final int days;
  final int price;

  InternetPackage({
    required this.id,
    required this.name,
    required this.size,
    required this.days,
    required this.price,
  });
}

class Transaction {
  final String id;
  final String phone;
  final String packageName;
  final int amount;
  final String status;
  final DateTime date;

  Transaction({
    required this.id,
    required this.phone,
    required this.packageName,
    required this.amount,
    required this.status,
    required this.date,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _phoneController = TextEditingController();
  final List<Transaction> _transactions = [];

  final List<InternetPackage> packages = [
    InternetPackage(id:1, name:'بسته 500 مگابایت - یک روزه', size:'500MB', days:1, price:2000),
    InternetPackage(id:2, name:'بسته 2 گیگ - 3 روزه', size:'2GB', days:3, price:5000),
    InternetPackage(id:3, name:'بسته 5 گیگ - 7 روزه', size:'5GB', days:7, price:12000),
    InternetPackage(id:4, name:'بسته 10 گیگ - 30 روزه', size:'10GB', days:30, price:25000),
    InternetPackage(id:5, name:'شبانه 30 گیگ - 7 روزه', size:'30GB (شب)', days:7, price:10000),
    InternetPackage(id:6, name:'ویژه نامحدود تستی', size:'نامحدود (آزمایشی)', days:1, price:0),
  ];

  String _formatPrice(int price) {
    if (price == 0) return 'رایگان';
    final format = NumberFormat("#,###", "fa_IR");
    return '${format.format(price)} تومان';
  }

  void _showPurchaseConfirmation(InternetPackage package) {
    final phone = _phoneController.text.trim();
    if (!RegExp(r'^09\d{9}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً شماره موبایل معتبر وارد کن (مثال: 09121234567)')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('درخواست خرید'),
        content: Text('آیا از خرید «${package.name}» برای شماره $phone مطمئنی؟\nقیمت: ${_formatPrice(package.price)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showFakePaymentGateway(package, phone);
            },
            child: const Text('تایید خرید'),
          ),
        ],
      ),
    );
  }

  void _showFakePaymentGateway(InternetPackage package, String phone) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('درگاه پرداخت تستی'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('پرداخت برای: ${package.name}'),
            const SizedBox(height: 8),
            const Text('شماره کارت آزمایشی: ۴۱۰۱-xxxx-xxxx-۱۲۳۴'),
            const SizedBox(height: 8),
            Text('مبلغ: ${_formatPrice(package.price)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('بازگشت'),
          ),
          ElevatedButton(
            onPressed: () {
              // Simulate payment processing
              Future.delayed(const Duration(milliseconds: 1200), () {
                Navigator.of(context).pop();
                final tx = Transaction(
                  id: 'TX${DateTime.now().millisecondsSinceEpoch}',
                  phone: phone,
                  packageName: package.name,
                  amount: package.price,
                  status: 'موفق',
                  date: DateTime.now(),
                );
                setState(() {
                  _transactions.insert(0, tx);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('خرید بسته «${package.name}» با موفقیت انجام شد.'),
                    backgroundColor: Colors.green,
                  ),
                );
              });
            },
            child: const Text('پرداخت (تست)'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverPadding(
            padding: const EdgeInsets.all(14.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SectionTitle(title: 'بسته‌های پیشنهادی'),
                _buildPackagesGrid(),
                const SizedBox(height: 12),
                _buildPhoneInputCard(),
                const SizedBox(height: 14),
                const SectionTitle(title: 'تراکنش‌های اخیر'),
                _buildTransactionsList(),
              ]),
            ),
          ),
          SliverToBoxAdapter(child: _buildFooter()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.wifi, size: 40, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'فروشگاه بسته اینترنت',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              Text(
                'خرید سریع و امن — نسخه آزمایشی',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(package.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(
                      '${package.size} — ${package.days} روز',
                      style: const TextStyle(color: Color(0xFF67727A), fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(_formatPrice(package.price), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    ElevatedButton(
                      onPressed: () => _showPurchaseConfirmation(package),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12)
                      ),
                      child: const Text('خرید'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneInputCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('موبایل:', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '09xxxxxxxx',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE6EEF0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _phoneController.text = '09121234567';
                  },
                  child: const Text('نمونه'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'پس از خرید، بسته در همان شماره فعال‌سازی (شبیه‌سازی) می‌شود.',
              style: TextStyle(color: Color(0xFF67727A), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('تراکنشی ثبت نشده', style: TextStyle(color: Color(0xFF67727A))),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final tx = _transactions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tx.packageName, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(tx.status, style: const TextStyle(fontSize: 13, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${tx.phone} — ${DateFormat('yyyy/MM/dd HH:mm', 'fa_IR').format(tx.date)} — ${_formatPrice(tx.amount)}',
                  style: const TextStyle(color: Color(0xFF67727A), fontSize: 13),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        'نسخهٔ آزمایشی — هیچ پولی واقعی منتقل نمی‌شود. برای ساخت APK یا اتصال به درگاه واقعی باید backend و احراز هویت اضافه شود.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13, color: Color(0xFF67727A)),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF222222)),
      ),
    );
  }
}
