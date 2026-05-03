import 'package:first_video/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Userpage extends ConsumerStatefulWidget {
  final User user;
  const Userpage({super.key, required this.user});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserpageState();
}

class _UserpageState extends ConsumerState<Userpage> {

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),

            const SizedBox(height: 20),

            _buildTile(
              icon: Icons.person,
              title: "Name",
              value: user.name,
            ),

            _buildTile(
              icon: Icons.email,
              title: "Email",
              value: user.email,
            ),

            _buildTile(
              icon: Icons.lock,
              title: "Password",
              value: showPassword ? user.password : "********",
              trailing: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
            ),

            _buildTile(
              icon: Icons.vpn_key,
              title: "Token",
              value: "${user.token.substring(0, 6)}...",
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
        trailing: trailing,
      ),
    );
  }
}