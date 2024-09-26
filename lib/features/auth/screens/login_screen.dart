import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:snapsync/core/exports.dart';
import 'package:snapsync/features/exports.dart';
import 'package:snapsync/widgets/exports.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:validation_pro/validate.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login';
  static const routePath = '/login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  AutovalidateMode? _autovalidateMode;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool submitClicked = false;
  bool createClicked = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  bool _allowSubmit() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      return Validate.isEmail(_emailController.text);
    }
    return false;
  }

  Future<void> _createAccount() async {
    if (_allowSubmit() && _usernameController.text.isNotEmpty) {
      try {
        setState(() {
          createClicked = true;
        });

        await ref.read(authControllerProvider.notifier).signUp(
              email: _emailController.text,
              password: _passwordController.text,
              username: _usernameController.text,
            );

        setState(() {
          createClicked = false;
        });

        if (mounted) {
          showSnackBar(context, 'Account Created');
          context.go(HomeScreen.routePath);
        }
      } on AuthException catch (e) {
        setState(() {
          createClicked = false;
        });
        if (mounted) {
          showSnackBar(context, e.message);
        }
      } catch (e) {
        setState(() {
          createClicked = false;
        });
        if (mounted) {
          showSnackBar(context, e.toString());
        }
      }
    } else {
      showSnackBar(context, 'Please enter valid email and password');
    }
  }

  Future<void> _loginWithPasscode() async {
    if (_allowSubmit()) {
      try {
        setState(() {
          submitClicked = true;
        });
        await ref.read(authControllerProvider.notifier).loginWithPasscode(
              email: _emailController.text,
              passcode: _passwordController.text,
            );

        setState(() {
          submitClicked = false;
        });

        if (mounted) {
          showSnackBar(context, 'Login Successful');
          context.go(HomeScreen.routePath);
        }
      } on AuthException catch (e) {
        setState(() {
          submitClicked = false;
        });
        if (mounted) {
          showSnackBar(context, e.message);
        }
      } catch (e) {
        setState(() {
          submitClicked = false;
        });
        throw Exception(e.toString());
      }
    } else {
      showSnackBar(context, 'Please enter valid email and password');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authControllerProvider);
    final isLoading = userState.isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            children: [
              SnapSyncLabelTextField(
                controller: _emailController,
                label: 'Email Address and Passcode',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                isReadOnly: isLoading,
                // Disable input when loading
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const Gap(20.0),
              Pinput(
                length: 6,
                obscureText: true,
                controller: _passwordController,
                onChanged: (String val) {},
                defaultPinTheme: defaultPinPutTheme,
                focusedPinTheme: focusedPinPutTheme,
                submittedPinTheme: focusedPinPutTheme,
              ),
              const Gap(24.0),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        36.0,
                      ),
                    ),
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: (isLoading)
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _loginWithPasscode();
                          } else {
                            setState(() {
                              _autovalidateMode = AutovalidateMode.always;
                            });
                          }
                        },
                  child: submitClicked
                      ? const CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 1.2,
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const Gap(20.0),
              const Divider(thickness: 1),
              const Gap(20.0),
              SnapSyncLabelTextField(
                maxLength: 12,
                controller: _usernameController,
                label: 'Username',
                hintText: 'Enter your username',
                isReadOnly: isLoading,
              ),
              const Gap(20.0),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        36.0,
                      ),
                    ),
                    side:
                        const BorderSide(color: Colors.deepPurple, width: 1.7),
                  ),
                  onPressed: (isLoading)
                      ? null
                      : () {
                          setState(() {
                            createClicked = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            _createAccount();
                          } else {
                            setState(() {
                              _autovalidateMode = AutovalidateMode.always;
                            });
                          }
                          setState(() {
                            createClicked = false;
                          });
                        },
                  child: createClicked
                      ? const CircularProgressIndicator.adaptive(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                          strokeWidth: 1.2,
                        )
                      : const Text(
                          'or Create an Account',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
