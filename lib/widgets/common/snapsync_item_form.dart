import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:snapsync/widgets/exports.dart';

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
            const Gap(12.0),
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
            const Gap(12.0),
          ],
        ),
      ),
    );
  }
}
