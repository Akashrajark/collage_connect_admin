import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_image_picker_button.dart';
import '../../common_widget/custom_text_formfield.dart';
import '../../util/value_validator.dart';
import 'collages_bloc/collages_bloc.dart';

class AddCollage extends StatefulWidget {
  final Map? collageDetails;
  const AddCollage({
    super.key,
    this.collageDetails,
  });

  @override
  State<AddCollage> createState() => _AddCollageState();
}

class _AddCollageState extends State<AddCollage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PlatformFile? coverImage;

  @override
  void initState() {
    if (widget.collageDetails != null) {
      _nameController.text = widget.collageDetails!['name'] ?? '';
      _emailController.text = widget.collageDetails!['email'] ?? '';
      _phoneController.text = widget.collageDetails!['phone'] ?? '';
      _descriptionController.text = widget.collageDetails!['description'] ?? '';
      _addressController.text = widget.collageDetails!['address'] ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CollagesBloc, CollagesState>(
      listener: (context, state) {
        if (state is CollagesSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomAlertDialog(
          title: widget.collageDetails != null ? 'Edit Collage' : 'Add Collage',
          isLoading: state is CollagesLoadingState,
          content: Flexible(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  CustomImagePickerButton(
                    width: double.infinity,
                    height: 200,
                    selectedImage: widget.collageDetails?['image_url'],
                    onPick: (pick) {
                      coverImage = pick;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Collage Name'),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    labelText: 'Enter collage name',
                    controller: _nameController,
                    validator: notEmptyValidator,
                    isLoading: false,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Description'),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    labelText: 'Enter collage description',
                    controller: _descriptionController,
                    validator: notEmptyValidator,
                    isLoading: false,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('Address'),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    labelText: 'Enter collage address',
                    controller: _addressController,
                    validator: notEmptyValidator,
                    isLoading: false,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  if (widget.collageDetails == null) ...[
                    _buildLabel('Collage Email ID'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      labelText: 'Enter collage email id',
                      controller: _emailController,
                      validator: notEmptyValidator,
                      isLoading: false,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Password'),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      labelText: 'Enter password',
                      controller: _passwordController,
                      validator: passwordValidator,
                      isLoading: false,
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildLabel('Phone Number'),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    labelText: 'Enter phone number',
                    controller: _phoneController,
                    validator: notEmptyValidator,
                    isLoading: false,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          primaryButton: 'Save',
          onPrimaryPressed: () {
            if (_formKey.currentState!.validate() && ((coverImage != null) || widget.collageDetails != null)) {
              Map<String, dynamic> details = {
                'name': _nameController.text.trim(),
                'description': _descriptionController.text.trim(),
                'address': _addressController.text.trim(),
                'email': _emailController.text.trim(),
                'password': _passwordController.text.trim(),
                'phone': _phoneController.text.trim(),
              };
              if (coverImage != null) {
                details['image'] = coverImage!.bytes;
                details['image_name'] = coverImage!.name;
              }

              if (widget.collageDetails != null) {
                BlocProvider.of<CollagesBloc>(context).add(
                  EditCollageEvent(
                    collageId: widget.collageDetails!['id'],
                    collageDetails: details,
                  ),
                );
              } else {
                BlocProvider.of<CollagesBloc>(context).add(
                  AddCollageEvent(
                    collageDetails: details,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        fontSize: 14.0,
      ),
    );
  }
}
