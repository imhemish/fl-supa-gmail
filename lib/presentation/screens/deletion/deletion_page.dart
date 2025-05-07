import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/loading_overlay.dart';
import '../../../data/providers/user_provider.dart'; // adjust import path as needed

class DeletionPage extends StatefulWidget {
  const DeletionPage({super.key});

  @override
  State<DeletionPage> createState() => _DeletionPageState();
}

class _DeletionPageState extends State<DeletionPage> {
  bool _isLoading = false;

  Future<void> _handleDelete() async {
    setState(() => _isLoading = true);

    try {
      final userP = context.read<UserProvider>();

      await userP.deleteUserProfile();

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Information deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete information')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delete Information'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: CustomButton(
              text: 'Delete Information',
              icon: Icons.delete_forever,
              onPressed: _handleDelete,
              isLoading: _isLoading,
            ),
          ),
        ),
      ),
    );
  }
}
