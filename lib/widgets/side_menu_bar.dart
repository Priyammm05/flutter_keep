import 'package:flutter/material.dart';
import 'package:flutter_keep/pages/archive_page.dart';
import 'package:flutter_keep/pages/home.dart';
import 'package:flutter_keep/pages/settings_page.dart';
import 'package:flutter_keep/theme/colors.dart';

class SideMenuBar extends StatefulWidget {
  const SideMenuBar({Key? key}) : super(key: key);

  @override
  _SideMenuBarState createState() => _SideMenuBarState();
}

class _SideMenuBarState extends State<SideMenuBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: cardColor),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                child: const Text(
                  'Flutter Keep',
                  style: TextStyle(
                    color: white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
              Divider(
                color: white.withOpacity(0.3),
              ),
              notes(),
              const SizedBox(height: 12),
              archive(),
              const SizedBox(height: 12),
              settings(),
            ],
          ),
        ),
      ),
    );
  }

  Widget notes() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.3)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
            ),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 25,
                color: white.withOpacity(0.8),
              ),
              const SizedBox(width: 16),
              Text(
                'Notes',
                style: TextStyle(
                  color: white.withOpacity(0.8),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget archive() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: TextButton(
        style: ButtonStyle(
          // backgroundColor:
          //     MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.3)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
            ),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ArchivePage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.cloud_download_outlined,
                size: 25,
                color: white.withOpacity(0.8),
              ),
              const SizedBox(width: 16),
              Text(
                'Archive',
                style: TextStyle(
                  color: white.withOpacity(0.8),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settings() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: TextButton(
        style: ButtonStyle(
          // backgroundColor:
          //     MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.3)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
            ),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SettingPage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                size: 25,
                color: white.withOpacity(0.8),
              ),
              const SizedBox(width: 16),
              Text(
                'Settings',
                style: TextStyle(
                  color: white.withOpacity(0.8),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
