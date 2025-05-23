import 'package:bookstore_app/features/profile/change_password/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'change_password_cubit.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => ChangePasswordCubit(),
        child: Scaffold(
          backgroundColor: Color(0xFFF9F9F9),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Change Password',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            leading: BackButton(),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: BlocBuilder<ChangePasswordCubit,ChangePasswordState>(builder: (context, state) {
              final controller = BlocProvider.of<ChangePasswordCubit>(context);

              return Column(
                children: [
                  _buildLabel('Current Password'),
                  _buildInputFeild(
                      controller: controller.currentPasswordController),
                  _buildLabel('New Password'),
                  _buildInputFeild(
                      controller: controller.newPasswordController),
                  _buildLabel('Confirm New Password'),
                  _buildInputFeild(
                      controller: controller.confirmPasswordController),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {controller.confirmPassword(context);},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15)),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ))
                ],
              );
            }),
          ),
        ));
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 5),
        child: Text(
          label,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget _buildInputFeild({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
