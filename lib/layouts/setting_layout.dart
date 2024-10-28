import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:unicons/unicons.dart';
import 'package:xbucks/helpper/function.dart';
import 'package:xbucks/pages/about_page.dart';
import 'package:xbucks/pages/login_page.dart';
import 'package:xbucks/pages/privacy_policy_page.dart';
import 'package:xbucks/pages/profile_page.dart';
import 'package:xbucks/pages/support_page.dart';
import 'package:xbucks/pages/terms_conditions_page.dart';
import 'package:xbucks/pages/wallet_page.dart';
import 'package:xbucks/pages/withdraw_page.dart';

class SettingsLayout extends StatefulWidget {
  const SettingsLayout({super.key});

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(UniconsLine.setting),
          title: const Text("Settings")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _widget(
                context: context,
                icon: Icons.person_outline_rounded,
                name: "Profile",
                screen: const ProfilePage()),
            _widget(
                context: context,
                icon: Icons.account_balance_wallet_outlined,
                name: "Wallet",
                screen: WalletPage()),
            // _widget(
            //     context: context,
            //     icon: Icons.account_balance_outlined,
            //     name: "Withdraw",
            //     screen: WithdrawPage()),
            _widget(
                context: context,
                icon: Icons.support_agent_outlined,
                name: "Support",
                screen: SupportPage()),
            _widget(
                context: context,
                icon: Icons.privacy_tip_outlined,
                name: "Privacy Policy",
                screen: const PrivacyPolicyPage()),
            _widget(
                context: context,
                icon: Icons.offline_bolt_outlined,
                name: "Terms and Conditions",
                screen: TermsAndConditionsPage()),
            _widget(
                context: context,
                icon: Icons.account_balance_wallet_outlined,
                name: "About",
                screen: const AboutPage()),
            Card(
              margin: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 20),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: InkWell(
                onTap: () {
                  deleteData("auth");
                  deleteData("isToken");
                  Navigator.of(context).pop();
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: const LoginPage(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                },
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        size: 40.0,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _widget(
      {required BuildContext context,
      required Widget screen,
      required String name,
      required IconData icon}) {
    return Card(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () => {
          PersistentNavBarNavigator.pushNewScreen(context,
              screen: screen,
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino)
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.0,
                color: Colors.blue,
              ),
              addHorizontalSpace(30),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
