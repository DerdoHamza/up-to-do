import 'package:flutter/material.dart';
import 'package:up_to_do/models/user_model.dart';

class ChangeEmail extends StatelessWidget {
  final UserModel user;
  const ChangeEmail({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Email'),
      ),
    );
  }
}
