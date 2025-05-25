// profile_page.dart
import 'package:bookstore_app/features/profile/view/presentation/delete_account.dart';
import 'package:bookstore_app/features/profile/view/view_model/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../orders/view/presentation/order_history_screen.dart';
import '../../change_password/change_password_view.dart';
import '../../help_screen.dart';
import '../view_model/profile_state.dart';
import 'edit_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileCubit _profileCubit;

  final List<Map<String, dynamic>> items = [
    {'icon_color': Colors.black, 'icon': Icons.person_2_outlined, 'title': 'Edit Profile'},
    {'icon_color': Colors.orange, 'icon': Icons.history, 'title': 'Order History'},
    {'icon_color': Colors.blue, 'icon': Icons.lock_open, 'title': 'Change Password'},
    {'icon_color': Colors.blueAccent, 'icon': Icons.help_outline, 'title': 'Help'},
    {'icon_color': Colors.red, 'icon': Icons.logout, 'title': 'Log Out'},
    {'icon_color': Colors.pink, 'icon': Icons.delete, 'title': 'Delete Account'},
  ];

  @override
  void initState() {
    super.initState();
    _profileCubit = ProfileCubit();
    _profileCubit.getProfile();
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileCubit,
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileErrorState) {
            final msg = (state.error['general']?.first) ?? 'Something went wrong';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
          }
          if (state is UpdateProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            _profileCubit.getProfile();
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          body: SafeArea(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final user = (state is ProfileSuccessState) ? state.user : {};
                final imageUrl = (user?['image'] is String && (user!['image'] as String).isNotEmpty)
                    ? user['image']
                    : null;

                return Column(
                  children: [
                    const SizedBox(height: 80),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: imageUrl != null
                          ? NetworkImage(imageUrl)
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
                        child: Icon(item['icon'], color: item['icon_color']),
                      ),
                      title: Text(item['title'], style: const TextStyle(fontSize: 16)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        switch (item['title']) {
                          case 'Edit Profile':
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PersonalDataPage()),
                            );
                            _profileCubit.getProfile(); // Refresh after edit
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
                          case 'Log Out':
                            _profileCubit.logOut(context);
                            break;
                          case 'Delete Account':
                            Navigator.push(context, MaterialPageRoute(builder: (_) => DeleteAccountPage()));
                            break;
                        }
                      },
                    )),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
