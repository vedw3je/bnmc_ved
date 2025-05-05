import 'package:bncmc/bnmc_map/bnmc_map.dart';
import 'package:bncmc/customrouteanimation/fade_slide_route.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/update_profile/update_profile_screen.dart';
import 'package:bncmc/webview/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BNMCDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  UserDetails? userDetails;
  BNMCDrawer({super.key, required this.scaffoldKey, required this.userDetails});

  @override
  State<BNMCDrawer> createState() => _BNMCDrawerState();
}

class _BNMCDrawerState extends State<BNMCDrawer> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
  }

  Future<void> _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedIndex = prefs.getInt('selectedDrawerIndex') ?? -1;
    });
  }

  Future<void> _saveSelectedIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedDrawerIndex', index);
  }

  void _onItemTap(int index, VoidCallback onTap) {
    setState(() {
      selectedIndex = index;
    });
    _saveSelectedIndex(index);
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.teal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/drawable/bncmc_nav_head.png',
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                  width: 90,
                  height: 45,
                ),
                const Spacer(),
                Text(
                  widget.userDetails!.firstName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            index: 0,
            icon: Icons.info,
            title: 'About BNMC',
            onTap:
                () => _onItemTap(0, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WebViewScreen(
                            url:
                                "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmAboutMsg.aspx",
                            email: widget.userDetails!.email,
                            phoneNumber: widget.userDetails!.mobileNo,
                            method: "POST",
                          ),
                    ),
                  );
                }),
          ),
          _buildDrawerItem(
            index: 1,
            icon: Icons.map,
            title: 'BNMC Map',
            onTap:
                () => _onItemTap(1, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BnmcMapScreen(),
                    ),
                  );
                }),
          ),
          _buildDrawerItem(
            index: 2,
            icon: Icons.receipt_long,
            title: 'View Bill',
            onTap:
                () => _onItemTap(2, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WebViewScreen(
                            url:
                                "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/ViewBill.aspx",
                            email: widget.userDetails!.email,
                            phoneNumber: widget.userDetails!.mobileNo,
                            method: "POST",
                          ),
                    ),
                  );
                }),
          ),
          _buildDrawerItem(
            index: 3,
            icon: Icons.payment,
            title: 'Pay Bill',
            onTap: () => _onItemTap(3, () {}),
          ),
          _buildDrawerItem(
            index: 4,
            icon: Icons.download,
            title: 'Download Receipt',
            onTap: () => _onItemTap(4, () {}),
          ),
          _buildDrawerItem(
            index: 5,
            icon: Icons.person,
            title: 'Update Profile',
            onTap:
                () => _onItemTap(5, () {
                  Navigator.of(context).push(
                    FadeSlideRoute(
                      page: UpdateProfileScreen(
                        onUserDetailsUpdated: (updatedDetails) {
                          setState(() {
                            widget.userDetails = updatedDetails;
                          });
                          print("Updated details: ${updatedDetails.firstName}");
                        },
                        userDetails: widget.userDetails!,
                      ),
                    ),
                  );
                }),
          ),
          _buildDrawerItem(
            index: 6,
            icon: Icons.group,
            title: 'Officers List',
            onTap:
                () => _onItemTap(6, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WebViewScreen(
                            url:
                                "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmOfficerList.aspx?@=1",
                            email: widget.userDetails!.email,
                            phoneNumber: widget.userDetails!.mobileNo,
                            method: "POST",
                          ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required int index,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final bool isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.teal : null),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.teal : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }
}
