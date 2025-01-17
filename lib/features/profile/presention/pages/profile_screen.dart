import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../porfile_cubit.dart';
import '../../../auth/presention/auth_cubit.dart';
import '../../../auth/presention/auth_state.dart';

import '/services/navigation_service.dart';
import '/features/profile/domain/models/settings.dart';
import '/features/profile/presention/pages/qa_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool notifictionnEnable;
  void openWhatsApp() async {
    final url = 'https://wa.me/+972543359697';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> checkNotificationPermission() async {
    return await Permission.notification.isGranted;
  }

  @override
  initState() {
    super.initState();
    checkNotificationPermission().then((value) {
      setState(() {
        notifictionnEnable = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
          ),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            state.user.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            state.user.email,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildRow(
                context: context,
                title: "Dark Mode",
                child: Switch(
                  value: context.watch<ProfileCubit>().state.darkMode,
                  onChanged: (value) {
                    context
                        .read<ProfileCubit>()
                        .saveSettings(Settings().copyWith(darkMode: value));
                  },
                ),
              ),
              _buildRow(
                context: context,
                title: "Language",
                child: Text("English"),
              ),
              _buildRow(
                context: context,
                title: "Notifications",
                child: TextButton(
                  onPressed: () async {
                    Permission.notification.request();
                  },
                  child: Text(notifictionnEnable ? "Disabled" : "Enabled"),
                ),
              ),
              _buildRow(
                context: context,
                child: TextButton(
                  onPressed: () => NavigationService.navigateTo(QaScreen()),
                  child: Text(
                    "Q&A",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              _buildRow(
                context: context,
                child: TextButton(
                  onPressed: openWhatsApp,
                  child: Text(
                    "Contect us",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              _buildRow(
                context: context,
                child: TextButton(
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                  },
                  child: Text(
                    "Logout",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(
      {required BuildContext context, String? title, required Widget child}) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: title != null
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title),
                const Spacer(),
                child,
              ],
            )
          : Center(child: child),
    );
  }
}
