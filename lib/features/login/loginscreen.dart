import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widget/custom_alert_dialog.dart';
import 'package:flutter_application_1/common_widget/custom_button.dart';
import 'package:flutter_application_1/common_widget/custom_text_formfield.dart';
import 'package:flutter_application_1/features/home/home_screen.dart';
import 'package:flutter_application_1/features/login/login_bloc/login_bloc.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_application_1/util/value_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Loginscreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isObscure = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 200), () {
      final GoTrueClient auth = Supabase.instance.client.auth;
      if (auth.currentUser != null && auth.currentUser!.appMetadata['role'] == 'admin') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocProvider(
          create: (context) => LoginBloc(),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              } else if (state is LoginFailureState) {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: 'Failed',
                    description: state.message,
                    primaryButton: 'Ok',
                  ),
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1568792923760-d70635a89fdc?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Center(
                    child: Container(
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(50),
                        border: Border.all(color: primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Log in',
                                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                      color: Colors.white.withAlpha(220),
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Email',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextFormField(
                                  labelText: 'Enter email',
                                  controller: _emailController,
                                  validator: emailValidator,
                                  isLoading: false),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Password',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                  controller: _passwordController,
                                  obscureText: isObscure,
                                  decoration: InputDecoration(
                                    filled: true,
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          isObscure = !isObscure;
                                          setState(() {});
                                        },
                                        icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility)),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock),
                                  )),
                              const SizedBox(
                                height: 30,
                              ),
                              CustomButton(
                                inverse: true,
                                isLoading: state is LoginLoadingState,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<LoginBloc>(context).add(
                                      LoginEvent(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                      ),
                                    );
                                  }
                                },
                                label: 'Login',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}

// const Color.fromARGB(255, 199, 50, 225)
