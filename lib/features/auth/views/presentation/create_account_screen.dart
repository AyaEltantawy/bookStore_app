import 'package:bookstore_app/core/widgets/navigation_bar.dart';
import 'package:bookstore_app/features/auth/views/view_model/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore_app/features/auth/views/view_model/auth_cubit.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(), // توفير الـ AuthCubit
      child: Scaffold(
          backgroundColor: Color(0xFFF7F7F7),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Create account',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: false,
          ),
          body: BlocConsumer<AuthCubit, AuthStates>(builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                          'Name', 'John Smith', false, _nameController),
                      SizedBox(height: 16),
                      _buildTextField('Email', 'Example@gmail.com', false,
                          _emailController),
                      SizedBox(height: 16),
                      _buildPasswordField('Password', true),
                      SizedBox(height: 16),
                      _buildPasswordField('Confirm password', false),
                      SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {

                              // نداء الـ SignUp
                              context.read<AuthCubit>().signUp(
                                    name: _nameController.text.toString(),
                                    email: _emailController.text.toString(),
                                    password_confirmation:
                                        _confirmPasswordController.text
                                            .toString(),
                                    password:
                                        _passwordController.text.toString(),
                                  );


                            }

                          ,child: state is SignUpLoadingState
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Create account',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                        ),
                      ),
                      // باقي العناصر زي الـ Social Media Buttons
                    ],
                  ),
                ),
              ),
            );
          }, listener: (context, state) {
            if (state is SignUpErrorState) {
              final allErrors = state.error.entries
                  .map((entry) => '${entry.key}: ${entry.value.join(', ')}')
                  .join('\n');

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(allErrors),
                backgroundColor: Colors.red,
              ));
            } else if (state is SignUpSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ));

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const NavigationBarScreen()));
            }
          })),
    );
  }

  Widget _buildTextField(String label, String hint, bool isPassword,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, bool isMainPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        TextFormField(
          controller:
              isMainPassword ? _passwordController : _confirmPasswordController,
          obscureText:
              isMainPassword ? _obscurePassword : _obscureConfirmPassword,
          decoration: InputDecoration(
            hintText: '',
            suffixIcon: IconButton(
              icon: Icon(
                (isMainPassword ? _obscurePassword : _obscureConfirmPassword)
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  if (isMainPassword) {
                    _obscurePassword = !_obscurePassword;
                  } else {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  }
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
