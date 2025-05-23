import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../orders/view/presentation/order_history_screen.dart';
import '../../change_password/change_password_view.dart';
import '../../help_screen.dart';
import 'edit_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final img = prefs.getString('user_image');
    setState(() {
      imageUrl = img;
      print('Loaded image URL: $imageUrl');
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon_color': Colors.black, 'icon': Icons.person_2_outlined, 'title': 'Edit Profile'},
      {'icon_color': Colors.orange, 'icon': Icons.history, 'title': 'Order History'},
      {'icon_color': Colors.blue, 'icon': Icons.lock_open, 'title': 'Change Password'},
      {'icon_color': Colors.blueAccent, 'icon': Icons.help_outline, 'title': 'Help'},
      {'icon_color': Colors.red, 'icon': Icons.logout, 'title': 'Log Out'},
      {'icon_color': Colors.pink, 'icon': Icons.delete, 'title': 'Delete Account'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xF9F9F9F9),
      body: Column(
        children: [
          const SizedBox(height: 80),
          CircleAvatar(
            radius: 50,
            backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                ? NetworkImage(imageUrl!)
                : const AssetImage('assets/image/profile.jpg') as ImageProvider,
          ),
          const SizedBox(height: 30),
          ...items.map((item) => ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: item['icon_color'] as Color,
              ),
            ),
            title: Text(item['title']?.toString() ?? '', style: const TextStyle(fontSize: 16)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              switch (item['title']) {
                case 'Edit Profile':
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PersonalDataPage()),
                  );
                  _loadProfileImage(); // Reload after returning
                  break;
                case 'Change Password':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ChangePasswordPage()));
                  break;
                case 'Help':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => HelpPage()));
                  break;
                case 'Order History':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => OrderHistoryPage()));
                  break;
              }
            },
          )),
        ],
      ),
    );
  }
}
