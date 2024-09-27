import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileUploadField extends FormField<File?> {
  FileUploadField({
    FormFieldSetter<File>? onChanged,
    super.validator,
    super.initialValue,
    bool readOnly = false,
    super.key,
  }) : super(
          onSaved: onChanged,
          builder: (FormFieldState<File?> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: state.hasError
                            ? Colors.redAccent
                            : Colors.deepPurple,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onPressed: readOnly
                      ? null
                      : () async {
                          FilePickerResult? result;

                          if (Platform.isIOS) {
                            result = await FilePicker.platform.pickFiles(
                              type: FileType.image,
                            );
                          } else {
                            result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: [
                                'gif',
                                'jpg',
                                'jpeg',
                                'png',
                                'bmp'
                              ],
                            );
                          }

                          final filePath = result?.files.isNotEmpty == true
                              ? result?.files.first.path
                              : null;

                          state
                            ..didChange(
                                filePath != null ? File(filePath) : null)
                            ..save();
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                    ),
                    child: Text(
                      state.value != null
                          ? state.value!.path.split('/').last
                          : 'Select Image',
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (state.hasError && state.errorText != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    state.errorText!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                    ),
                  )
                ],
              ],
            );
          },
        );
}
