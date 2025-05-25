import 'package:bookstore_app/features/profile/view/view_model/profile_cubit.dart';
import 'package:bookstore_app/features/profile/view/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/views/presentation/create_account_screen.dart';

class DeleteAccountPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final controller = BlocProvider.of<ProfileCubit>(context);
          return Scaffold(
            backgroundColor: Color(0xFFF9F9F9),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title:
                  Text('Delete Account', style: TextStyle(color: Colors.black)),
              iconTheme: IconThemeData(color: Colors.black),
              leading: BackButton(),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildLabel('Enter your Password'),
                    _buildInputField(
                      controller: controller.passwordController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.deleteAccount(context);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CreateAccountPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: Text('Delete',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 5),
      child: Text(label, style: TextStyle(color: Colors.grey[700])),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
