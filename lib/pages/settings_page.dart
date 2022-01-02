import 'package:flutter/material.dart';
import 'package:flutter_keep/services/login_info.dart';
import 'package:flutter_keep/widgets/side_menu_bar.dart';
import 'package:flutter_keep/theme/colors.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool value = true;

  getSync() async {
    LocalDataSaver.getSync().then((valueDB) {
      value = valueDB!;
    });
  }

  @override
  void initState() {
    getSync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: true,
      key: _drawerKey,
      drawer: const SideMenuBar(),
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text('Settings', style: TextStyle(color: white)),
        elevation: 0,
        leading: IconButton(
          splashRadius: 18,
          icon: const Icon(Icons.menu, color: white),
          onPressed: () {
            _drawerKey.currentState!.openDrawer();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Sync',
                    style: TextStyle(color: white, fontSize: 20),
                  ),
                  const Spacer(),
                  Transform.scale(
                    scale: 1.35,
                    child: Switch.adaptive(
                        value: value,
                        activeColor: white.withOpacity(0.7),
                        inactiveThumbColor: cardColor,
                        onChanged: (switchValue) {
                          setState(() {
                            value = switchValue;
                            LocalDataSaver.saveSync(switchValue);
                          });
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
