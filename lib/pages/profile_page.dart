import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xbucks/helpper/function.dart';
import 'package:http/http.dart' as http;
import 'package:xbucks/modal/profile_modal.dart';
import 'package:xbucks/pages/password_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Profile> itemList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async {
    String? token = await getData("isToken");
    final response = await http.post(
      Uri.parse('${getURL()}profile'),
      headers: <String, String>{
        'Authorization': '$token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        itemList = jsonData.map((data) => Profile.fromJson(data)).toList();
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 8, // Add elevation for a shadow effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: isLoading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/logo.jpg'),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              itemList[0].name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              itemList[0].email,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            addVerticalSpace(20),
                          ],
                        ),
                      ),
                      addVerticalSpace(50),
                      _buildInfoRow('Total Payout', '000'),
                      _buildInfoRow('Total Income', '000'),
                      _buildInfoRow('Total Added Balance', '000'),
                      addVerticalSpace(20),
                      addVerticalSpace(10),
                      ElevatedButton(
                        onPressed: () =>
                            navigateToPush(context, PasswordPage()),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black), // Button background color
                        ),
                        child: const Text(
                          'Change Password',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
