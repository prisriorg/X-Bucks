import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:unicons/unicons.dart';
import 'package:xbucks/helpper/function.dart';
import 'package:xbucks/pages/game_page.dart';
import 'package:http/http.dart' as http;
import 'package:xbucks/pages/wallet_page.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    fetchWalletBalance();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchData();
    }
    if (state == AppLifecycleState.paused) {
      fetchData();
    }
    if (state == AppLifecycleState.inactive) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(UniconsLine.home_alt), // Icon on the left side
        title: const Text("Home"), // Title in the center
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    navigateToPush(context, WalletPage());
                  },
                  child: Row(
                    children: [
                      const Icon(UniconsLine.wallet), // Wallet icon
                      const SizedBox(width: 4), // Spacer
                      _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              _walletBalance.toStringAsFixed(2),
                              style: const TextStyle(fontSize: 18),
                            ),
                    ],
                  ),
                )
                // Wallet balance
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Connection error'));
            } else {
              List<Map<String, dynamic>> data =
                  (snapshot.data as List<dynamic>).cast<Map<String, dynamic>>();
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return _widget(
                    context: context,
                    modeName: item['name'],
                    time: item['time'],
                    fee: '${item['feet']}  ${item['fee']}',
                    win: '${item['wint']} ${item['win']}',
                    ball: item['balls'],
                    speed: item['speed'],
                    shake: item['shake'],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    String? token = await getData("isToken");
    final response = await http
        .post(Uri.parse('${getURL()}games'), headers: <String, String>{
      'Authorization': '$token',
    });
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }

  double _walletBalance = 0.00;
  bool _isLoading = false;

  Future<void> fetchWalletBalance() async {
    setState(() {
      _isLoading = true;
    });

    String? token = await getData("isToken");

    try {
      final response = await http
          .post(Uri.parse('${getURL()}balance'), headers: <String, String>{
        'Authorization': '$token',
      });
      final responseData = json.decode(response.body);

      setState(() {
        _walletBalance = double.parse(responseData['balance'].toString());
      });
    } catch (error) {
      print('Error fetching wallet balance: $error');
      // Handle error here, such as showing a snackbar or dialog
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _widget(
      {required BuildContext context,
      required String modeName,
      required int time,
      required String fee,
      required String win,
      required int ball,
      required int speed,
      required int shake}) {
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: GamePage(
              modeName: modeName,
              time: time,
              fee: fee,
              win: win,
              speed: speed,
              ball: ball,
              shake: shake,
            ),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        height: 160,
        child: Card(
          elevation: 12.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.games,
                              color: Colors.blue,
                              size: 25,
                            ),
                            addHorizontalSpace(10),
                            Text(
                              modeName,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.timelapse_outlined,
                            color: Colors.blue,
                            size: 25,
                          ),
                          addHorizontalSpace(10),
                          Text(
                            formatSeconds(time),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.lightBlue,
              ),
              // Entry 1
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    fee,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              // Entry 2
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(win,
                          style: const TextStyle(
                            fontSize: 20,
                          )),
                      const Expanded(child: SizedBox()),
                      const Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
