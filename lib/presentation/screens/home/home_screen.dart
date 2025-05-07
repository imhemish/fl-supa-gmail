import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../config/constants.dart';
import '../../../config/routes.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/user_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  int? _selectedAge;
  
  bool _isFormDirty = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userProvider = Provider.of<UserProvider>(context);
    _loadUserData(userProvider);
}
  
  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }
  
  void _loadUserData(UserProvider userProvider) {
    print('updating form fields from user data');
    final userProfile = userProvider.userProfile;
    
    if (userProfile != null) {
      if (_addressController.text != (userProfile.address ?? '') ||
          _phoneController.text != (userProfile.phoneNumber ?? '') ||
          _additionalInfoController.text != (userProfile.additionalInfo ?? '') ||
          _selectedAge != userProfile.age) {
        
        setState(() {
          _addressController.text = userProfile.address ?? '';
          _phoneController.text = userProfile.phoneNumber ?? '';
          _additionalInfoController.text = userProfile.additionalInfo ?? '';
          _selectedAge = userProfile.age;
          _isFormDirty = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Navigator.pushNamed(context, RouteNames.profile);
                  break;
                case 'deletion':
                  Navigator.pushNamed(context, RouteNames.deletion);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem(
                value: 'deletion',
                child: Text('Deletion'),
              ),
            ],
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: userProvider.isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Card
                if (authProvider.user != null)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          UserAvatar(
                            photoUrl: userProvider.userProfile?.photoUrl,
                            radius: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProvider.userProfile?.displayName ?? 'User',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userProvider.userProfile?.email ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                
                Form(
                  key: _formKey,
                  onChanged: () {
                    if (!_isFormDirty) {
                      setState(() {
                        _isFormDirty = true;
                      });
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          hintText: 'Enter your address',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: RequiredValidator(
                          errorText: AppConstants.requiredField,
                        ).call,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter your phone number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: MultiValidator([
                          RequiredValidator(errorText: AppConstants.requiredField),
                          PatternValidator(
                            r'(^(?:[+0]9)?[0-9]{10,12}$)',
                            errorText: AppConstants.invalidPhone,
                          ),
                        ]).call,
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<int>(
                        value: _selectedAge,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          hintText: 'Select your age',
                          prefixIcon: Icon(Icons.cake),
                        ),
                        items: AppConstants.ageOptions.map((age) {
                          return DropdownMenuItem<int>(
                            value: age,
                            child: Text('$age years'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAge = value;
                            _isFormDirty = true;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return AppConstants.requiredField;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _additionalInfoController,
                        decoration: const InputDecoration(
                          labelText: 'Additional Information',
                          hintText: 'Any additional information',
                          prefixIcon: Icon(Icons.note),
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 24),
                      
                      CustomButton(
                        text: 'Save Information',
                        icon: Icons.save,
                        isLoading: userProvider.isLoading,
                        
                        onPressed: _isFormDirty ? _saveUserData : () {},
                      ),
                      
                      const SizedBox(height: 16),
                      
                      if (userProvider.error != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            userProvider.error!,
                            style: TextStyle(color: Colors.red.shade800),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      final success = await userProvider.updateUserProfile(
        address: _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        age: _selectedAge,
        additionalInfo: _additionalInfoController.text.trim(),
      );
      
      if (success && mounted) {
        setState(() {
          _isFormDirty = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Information saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}