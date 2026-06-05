import 'dart:io';
import 'package:ag_broker/domain/entities/constitution_type.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/lp_client_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddLpClientPage extends ConsumerStatefulWidget {
  const AddLpClientPage({super.key});

  @override
  _AddLpClientPageState createState() => _AddLpClientPageState();
}

class _AddLpClientPageState extends ConsumerState<AddLpClientPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  ConstitutionType? _selectedConstitution;

  bool _bidStatus = false;

  File? _aadharFrontImage;
  File? _aadharBackImage;
  File? _pancardImage;
  File? _gstImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, String imageType) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          switch (imageType) {
            case 'aadhar_front':
              _aadharFrontImage = File(pickedFile.path);
              break;
            case 'aadhar_back':
              _aadharBackImage = File(pickedFile.path);
              break;
            case 'pancard':
              _pancardImage = File(pickedFile.path);
              break;
            case 'gst':
              _gstImage = File(pickedFile.path);
              break;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${localizations.errorOccurred}: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog(String imageType, String title) {
    final localizations = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(localizations.camera),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, imageType);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(localizations.gallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, imageType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final locale = Localizations.localeOf(context);
    final localizations = AppLocalizations.of(context)!;

    try {
      final success = await ref
          .read(lpClientStateProvider(locale).notifier)
          .addLpClient(
            constitution: _selectedConstitution?.type.toString() ?? '',
            name: _nameController.text,
            phone: _phoneController.text,
            bidStatus: _bidStatus ? '1' : '0',
            aadharFrontImage: _aadharFrontImage,
            aadharBackImage: _aadharBackImage,
            pancardImage: _pancardImage,
            gstImage: _gstImage,
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.clientAddedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        final error = ref.read(lpClientStateProvider(locale)).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? localizations.errorOccurred),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final error = ref.read(lpClientStateProvider(locale)).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? localizations.errorOccurred),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localizations = AppLocalizations.of(context)!;
    final clientState = ref.watch(lpClientStateProvider(locale));

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          localizations.addLpClient,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: clientState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Constitution Field
                    DropdownButtonFormField<ConstitutionType>(
                      value: _selectedConstitution,
                      decoration: InputDecoration(
                        labelText: '${localizations.constitution} *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      hint: Text(localizations.selectConstitution),
                      items: ConstitutionType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.label),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedConstitution = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return localizations.constitutionRequired;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: '${localizations.name} *',
                        hintText: localizations.enterClientName,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.nameRequired;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Phone Field
                    TextFormField(
                      controller: _phoneController,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: '${localizations.phone} *',
                        hintText: localizations.enterPhoneNumber,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.phoneRequired;
                        }
                        if (value.length != 10) {
                          return localizations.phoneMustBe10Digits;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Bid Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            localizations.bidStatus,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _bidStatus ? localizations.yes : localizations.no,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Switch(
                            value: _bidStatus,
                            onChanged: (value) {
                              setState(() {
                                _bidStatus = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Images Section
                    Text(
                      localizations.documentsOptional,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Aadhar Front
                    _buildImagePicker(
                      localizations.aadharFront,
                      _aadharFrontImage,
                      'aadhar_front',
                      localizations,
                    ),
                    const SizedBox(height: 8),

                    // Aadhar Back
                    _buildImagePicker(
                      localizations.aadharBack,
                      _aadharBackImage,
                      'aadhar_back',
                      localizations,
                    ),
                    const SizedBox(height: 8),

                    // PAN Card
                    _buildImagePicker(
                      localizations.panCard,
                      _pancardImage,
                      'pancard',
                      localizations,
                    ),
                    const SizedBox(height: 8),

                    // GST
                    _buildImagePicker(
                      localizations.gstCertificate,
                      _gstImage,
                      'gst',
                      localizations,
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        localizations.addClient,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImagePicker(
    String label,
    File? image,
    String imageType,
    AppLocalizations localizations,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _showImageSourceDialog(imageType, label),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      image != null
                          ? localizations.imageSelected
                          : localizations.tapToSelect,
                      style: TextStyle(
                        fontSize: 12,
                        color: image != null
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (image != null)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.grey.shade400,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
