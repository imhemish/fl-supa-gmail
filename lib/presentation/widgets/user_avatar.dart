import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final double radius;
  
  const UserAvatar({
    super.key,
    this.photoUrl,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoUrl!),
      );
    }
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.deepPurple.shade100,
      child: Icon(
        Icons.person,
        size: radius * 1.2,
        color: Colors.deepPurple.shade700,
      ),
    );
  }
}