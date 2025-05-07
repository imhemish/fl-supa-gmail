import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/user_provider.dart';
import '../../../data/providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/user_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.userProfile;
        
        return LoadingOverlay(
          isLoading: userProvider.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  
                  Center(
                    child: UserAvatar(
                      photoUrl: user?.photoUrl,
                      radius: 60,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    user?.displayName ?? 'User',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),

                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  
                  const Spacer(),

                  CustomButton(
                    text: 'Logout',
                    icon: Icons.logout,
                    onPressed: () => _logout(context),
                    isOutlined: true,
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    await authService.signOut();
  }
}