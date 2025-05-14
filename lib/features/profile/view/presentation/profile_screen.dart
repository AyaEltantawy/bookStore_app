import 'package:bookstore_app/features/orders/view/presentation/order_history_screen.dart';
import 'package:bookstore_app/features/profile/change_passowrd_screen.dart';
import 'package:bookstore_app/features/profile/view/presentation/edit_profile_screen.dart';
import 'package:bookstore_app/features/profile/help_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon_color': Colors.black,
        'icon': Icons.person_2_outlined,
        'title': 'Edit Profile',
      },
      {
        'icon_color': Colors.orange,
        'icon': Icons.history,
        'title': 'Order History',
      },
      {
        'icon_color': Colors.blue,
        'icon': Icons.lock_open,
        'title': 'Change Password',
      },
      {
        'icon_color': Colors.blueAccent,
        'icon': Icons.help_outline,
        'title': 'Help',
      },
      {
        'icon_color': Colors.red,
        'icon': Icons.logout,
        'title': 'Log Out',
      },
      {
        'icon_color': Colors.pink,
        'icon': Icons.delete,
        'title': 'Delete Account',
      },
    ];

    Future<SharedPreferences> getUser() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs;
    }

    return Scaffold(
      backgroundColor: Color(0xF9F9F9F9),
      body: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final imageUrl = snapshot.data!.getString('user_image');

                  return Image.network(
                    imageUrl!,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/image/profile.jpg'),
                      );
                    },
                  );

                  // );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          // Center(
          //   child: CircleAvatar(
          //     radius: 50,
          //     backgroundImage: AssetImage('assets/profile.jpg'),
          //   ),
          // ),
          SizedBox(
            height: 30,
          ),
          ...items.map((item) => ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['icon_color'] as Color,
                  ),
                ),
                title: Text(
                  item['title']?.toString() ?? '',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                onTap: () => {
                  if (item['title'] == 'Edit Profile')
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PersonalDataPage(),
                          ))
                    }
                  else if (item['title'] == 'Change Password')
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ChangePasswordPage()),
                      )
                    }
                  else if (item['title'] == 'Help')
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HelpPage()),
                      )
                    }
                  else if (item['title'] == 'Order History')
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => OrderHistoryPage()),
                      )
                    }
                },
              )),
        ],
      ),
    );
  }
}
