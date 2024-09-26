import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:snapsync/features/exports.dart';
import 'package:snapsync/widgets/exports.dart';
import 'package:validation_pro/validate.dart';

import '../../../core/pin_put_theme.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login';
  static const routePath = '/login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isSubmitting = false;
  bool _submitAllowed = false;
  AutovalidateMode? _autovalidateMode;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  bool _allowSubmit() {
    if (_emailController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      if (Validate.isEmail(_emailController.text)) {
        return true;
      }
      return false;
    }
    return false;
  }

  Future<void> _createAccount() async {
    try {
      setState(() {
        _isSubmitting = true;
      });

      if (_allowSubmit()) {
        await ref.read(authControllerProvider.notifier).signUp(
              email: _emailController.text,
              password: _passwordController.text,
              username: _usernameController.text,
            );
        if (mounted) {}
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter valid email and password'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      throw Exception(e.toString());
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // Future<void> _verifyCode() async {
  //   try {
  //     setState(() {
  //       _isSubmitting = true;
  //     });
  //
  //     await ref.read(authControllerProvider.notifier).verifyCode(
  //       email: _emailController.text,
  //       code: _codeController.text,
  //     );
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   } finally {
  //     setState(() {
  //       _isSubmitting = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
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
                isReadOnly: _isSubmitting,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }

                  return null;
                },
              ),
              const Gap(20.0),
              // Pin-put OTP Code
              Pinput(
                length: 6,
                obscureText: true,
                obscuringCharacter: '*',
                controller: _passwordController,
                onChanged: (String val) {
                  setState(() {
                    if (val.length == 6) {
                      _submitAllowed = true;
                    } else {
                      _submitAllowed = false;
                    }
                  });
                },
                defaultPinTheme: defaultPinPutTheme,
                focusedPinTheme: focusedPinPutTheme,
                submittedPinTheme: focusedPinPutTheme,
              ),
              const Gap(32.0),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: _isSubmitting && !_submitAllowed
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            // TODO - login user
                          } else {
                            setState(() {
                              _autovalidateMode = AutovalidateMode.always;
                            });
                          }
                        },
                  child: const Text(
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
                isReadOnly: _isSubmitting,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    side: const BorderSide(
                      color: Colors.deepPurple,
                      width: 1.7,
                    ),
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _createAccount();
                          } else {
                            setState(() {
                              _autovalidateMode = AutovalidateMode.always;
                            });
                          }
                        },
                  child: _isSubmitting
                      ? const CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepPurple,
                          ),
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
