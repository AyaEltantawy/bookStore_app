import 'package:bookstore_app/core/services/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view_model/profile_cubit.dart';
import '../view_model/profile_state.dart';

class PersonalDataPage extends StatelessWidget {
  const PersonalDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ProfileCubit()..getProfile(),
        child: Scaffold(
            body: SafeArea(
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              } else if (state is ProfileErrorState) {
                print("EEEEEEEEEEEEEEEEEEEEE");
                print(state.error);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error as String),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              // final user = state.user ?? {};
              // final user = context.read<ProfileCubit>().user;
              final user = state.user ?? {};

              final nameController =
                  TextEditingController(text: user['name'] ?? '');
              final emailController =
                  TextEditingController(text: user['email'] ?? '');
              final phoneController =
                  TextEditingController(text: user['phone'] ?? '');
              final cityController =
                  TextEditingController(text: user['city'] ?? '');
              final addressController =
                  TextEditingController(text: user['address'] ?? '');

              return Scaffold(
                backgroundColor: const Color(0xFFF9F9F9),
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: const Text('Edit Profile',
                      style: TextStyle(color: Colors.black)),
                  iconTheme: const IconThemeData(color: Colors.black),
                  leading: const BackButton(),
                ),
                body: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/image/profile.jpg'),
                      ),
                      const SizedBox(height: 30),
                      _buildLabel('Name'),
                      _buildInputField(controller: nameController),
                      _buildLabel('Email'),
                      _buildInputField(controller: emailController),
                      _buildLabel('Phone Number'),
                      _buildInputField(controller: phoneController),
                      _buildLabel('City'),
                      _buildInputField(controller: cityController),
                      _buildLabel('Address'),
                      _buildInputField(controller: addressController),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          final updatedData = {
                            'image': '',
                            'name': nameController.text,
                            'email': emailController.text,
                            'phone': phoneController.text,
                            'city': cityController.text,
                            'address': addressController.text,
                          };

                          await context
                              .read<ProfileCubit>()
                              .updateProfile(updatedData);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حفظ التعديلات')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: const Text('Save',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )));
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 5),
        child: Text(label, style: TextStyle(color: Colors.grey[700])),
      ),
    );
  }

  Widget _buildInputField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
