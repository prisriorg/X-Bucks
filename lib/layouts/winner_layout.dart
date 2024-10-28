import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:xbucks/helpper/function.dart';
import 'package:xbucks/modal/winner_modal.dart';
import 'package:http/http.dart' as http;

class WinnerLayout extends StatefulWidget {
  const WinnerLayout({super.key});

  @override
  State<WinnerLayout> createState() => _WinnerLayoutState();
}

class _WinnerLayoutState extends State<WinnerLayout> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Winner> winnerData = [];
  Future<void> _refreshData() async {
    setState(() {
      winnerData = [];
    });
    fetchWinner();
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    fetchWinner();
  }

  Future<void> fetchWinner() async {
    String? token = await getData("isToken");
    final response = await http.post(
      Uri.parse('${getURL()}wins'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        winnerData = jsonData.map((data) => Winner.fromJson(data)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(UniconsLine.medal), title: const Text("Winners")),
      body: RefreshIndicator(
        // Set key to enable access to refresh indicator state
        key: _refreshIndicatorKey,
        // onRefresh callback triggers when the user pulls down to refresh
        onRefresh: _refreshData,
        child: Center(
          child: ListView.builder(
              itemCount: winnerData.length,
              itemBuilder: (context, index) {
                return _widget(
                    context: context,
                    coin:
                        "${winnerData[index].title}  ${winnerData[index].amount}",
                    name: winnerData[index].user);
              }),
        ),
      ),
    );
  }
}

Widget _widget(
    {required BuildContext context,
    required String coin,
    required String name}) {
  return Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Container(
      width: getScreenWidth(context) * 0.9,
      height: 150.0,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            UniconsLine.medal,
            size: 50.0,
            color: Colors.red,
          ),
          const SizedBox(height: 10.0),
          Text(
            coin,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
