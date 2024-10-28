import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xbucks/helpper/function.dart';

class UpiPage extends StatefulWidget {
  const UpiPage({super.key});

  @override
  State<UpiPage> createState() => _UpiPageState();
}

class _UpiPageState extends State<UpiPage> {
  final String upiId = 'mk800927180@axl';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Balance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 20),
                        readOnly: true,
                        controller: TextEditingController(text: upiId),
                        decoration: InputDecoration(
                          labelText: 'UPI ID',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: upiId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('UPI ID copied to clipboard')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.0),
            Container(
              alignment: Alignment.center,
              width: getScreenWidth(context),
              child: Text(
                "or Pay with",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/upi.jpg', // Replace with your QR code image path
                  width: getScreenWidth(context),
                  height: 500,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          launchWhatsApp();
        },
        label: Text('Contact Support'),
        icon: Icon(Icons.message),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void launchWhatsApp() async {
    String url =
        "https://wa.me/whatsapp_number"; // Replace with your WhatsApp number
    await launch(url);
  }
}
