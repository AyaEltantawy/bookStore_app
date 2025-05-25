import 'package:bookstore_app/features/profile/view/view_model/profile_cubit.dart';
import 'package:bookstore_app/features/profile/view/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpPage extends StatelessWidget {
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
              title: Text('Help', style: TextStyle(color: Colors.black)),
              iconTheme: IconThemeData(color: Colors.black),
              leading: BackButton(),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text(
                      'How can we help you?',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'If you have any questions or need assistance, please choose one of the options below.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 30),
                    _buildLabel('Enter your Name'),
                    _buildInputField(
                      controller: controller.nameController,
                      validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Name is required' : null,
                    ),
                    _buildLabel('Enter your Email'),
                    _buildInputField(
                      controller: controller.emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Email is required';
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    _buildLabel('Enter your Subject'),
                    _buildInputField(
                      controller: controller.subjectController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Subject is required';
                        if (value.length > 50) return 'Subject must be less than 50 characters';
                        return null;
                      },
                    ),
                    _buildLabel('Enter your Content'),
                    _buildInputField(
                      controller: controller.contentController,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Content is required';
                        if (value.length < 20) return 'Content must be at least 20 characters';
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.sendHelpRequest(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: Text('Send', style: TextStyle(fontSize: 16, color: Colors.white)),
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
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
