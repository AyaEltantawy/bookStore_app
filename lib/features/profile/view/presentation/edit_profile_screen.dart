import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../view_model/profile_cubit.dart';
import '../view_model/profile_state.dart';

class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage({super.key});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController cityController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    cityController = TextEditingController();
    addressController = TextEditingController();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..getProfile(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          } else if (state is ProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error['general']?.first ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final user = state.user ?? {};
          nameController.text = user['name'] ?? '';
          emailController.text = user['email'] ?? '';
          phoneController.text = user['phone'] ?? '';
          cityController.text = user['city'] ?? '';
          addressController.text = user['address'] ?? '';

          return Scaffold(
            backgroundColor: const Color(0xFFF9F9F9),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
              iconTheme: const IconThemeData(color: Colors.black),
              leading: const BackButton(),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : (user['image'] != null
                            ? NetworkImage(user['image'])
                            : const AssetImage('assets/image/profile.jpg')) as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.pink,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.add, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
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
                    onPressed: () {
                      final updatedData = {
                        'name': nameController.text.trim(),
                        'email': emailController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'city': cityController.text.trim(),
                        'address': addressController.text.trim(),
                        "image":_pickedImage
                      };

                      context.read<ProfileCubit>().updateProfile(updatedData);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
