import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:snapsync/features/exports.dart';
import 'package:snapsync/widgets/exports.dart';

import '../../core/functions/show_snackbar.dart';

class SnapSyncItemForm extends ConsumerStatefulWidget {
  const SnapSyncItemForm({super.key});

  @override
  ConsumerState<SnapSyncItemForm> createState() => _SnapSyncItemFormState();
}

class _SnapSyncItemFormState extends ConsumerState<SnapSyncItemForm> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode? _autovalidateMode;
  bool _isSubmitting = false;

  final _titleController = TextEditingController();
  File? file;

  void _popBottomSheet() {
    if (mounted) {
      context.pop();
    }
  }

  Future<void> _createSnap() async {
    if (file == null) {
      return;
    }
    try {
      setState(() {
        _isSubmitting = true;
      });

      await ref
          .read(snapControllerProvider.notifier)
          .createSnap(title: _titleController.text, file: file!);

      _popBottomSheet();

      setState(() {
        _isSubmitting = false;
      });
    } catch (e) {
      _popBottomSheet();
      if (mounted) {
        showSnackBar(context, e.toString());
      }
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: Column(
          children: [
            const Gap(12.0),
            const Text(
              'Add a new Snap',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(20.0),
            SnapSyncLabelTextField(
              controller: _titleController,
              isReadOnly: _isSubmitting,
              label: 'Title',
              hintText: 'Add image title',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const Gap(16.0),
            FileUploadField(
              validator: (value) {
                if (value == null) {
                  return 'Please select an image';
                }
                return null;
              },
              readOnly: _isSubmitting,
              onChanged: (file) {
                setState(() {
                  this.file = file;
                });
              },
            ),
            const Gap(24.0),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate() == false) {
                    setState(() {
                      _autovalidateMode = AutovalidateMode.always;
                    });
                    return;
                  } else {
                    _createSnap();
                  }
                },
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.2,
                      )
                    : const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const Gap(10.0),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  side: const BorderSide(
                    color: Colors.red,
                    width: 1.7,
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
