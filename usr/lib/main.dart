import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // To make the app feel more native to Persian users, you can add a Persian font
        // like 'Vazir' or 'IranSans' to your assets and uncomment the following lines.
        // textTheme: const TextTheme(
        //   bodyLarge: TextStyle(fontFamily: 'Vazir'),
        //   bodyMedium: TextStyle(fontFamily: 'Vazir'),
        //   displayLarge: TextStyle(fontFamily: 'Vazir'),
        //   displayMedium: TextStyle(fontFamily: 'Vazir'),
        //   displaySmall: TextStyle(fontFamily: 'Vazir'),
        //   headlineMedium: TextStyle(fontFamily: 'Vazir'),
        //   headlineSmall: TextStyle(fontFamily: 'Vazir'),
        //   titleLarge: TextStyle(fontFamily: 'Vazir'),
        //   titleMedium: TextStyle(fontFamily: 'Vazir'),
        //   titleSmall: TextStyle(fontFamily: 'Vazir'),
        //   bodySmall: TextStyle(fontFamily: 'Vazir'),
        //   labelLarge: TextStyle(fontFamily: 'Vazir'),
        //   labelSmall: TextStyle(fontFamily: 'Vazir'),
        // ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// A simple data model for an internet package
class InternetPackage {
  final String title;
  final String price;
  final String duration;
  final String volume;

  InternetPackage({
    required this.title,
    required this.price,
    required this.duration,
    required this.volume,
  });
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample list of internet packages
    final List<InternetPackage> packages = [
      InternetPackage(title: 'بسته ماهانه', price: '۲۰٬۰۰۰ تومان', duration: '۳۰ روز', volume: '۵ گیگابایت'),
      InternetPackage(title: 'بسته هفتگی', price: '۱۰٬۰۰۰ تومان', duration: '۷ روز', volume: '۲ گیگابایت'),
      InternetPackage(title: 'بسته روزانه', price: '۵٬۰۰۰ تومان', duration: '۱ روز', volume: '۱ گیگابایت'),
      InternetPackage(title: 'بسته سه ماهه', price: '۵۰٬۰۰۰ تومان', duration: '۹۰ روز', volume: '۱۵ گیگابایت'),
      InternetPackage(title: 'بسته نامحدود شبانه', price: '۱۵٬۰۰۰ تومان', duration: '۳۰ روز', volume: 'نامحدود (۲ تا ۷ صبح)'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('انتخاب بسته اینترنت'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final package = packages[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.wifi_tethering, color: Colors.blue),
                ),
                title: Text(
                  package.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('${package.volume}  •  ${package.duration}'),
                ),
                trailing: Text(
                  package.price,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                onTap: () {
                  // In the next steps, we can navigate to a purchase confirmation page.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('بسته "${package.title}" انتخاب شد')),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
