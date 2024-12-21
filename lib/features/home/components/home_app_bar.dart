import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/navigation_service.dart';
import '../../auth/presention/auth_cubit.dart';
import '../../auth/presention/auth_state.dart';
import '../../profile/presention/pages/profile_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          const Text('Morening', style: TextStyle(fontWeight: FontWeight.w800)),
      centerTitle: true,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () {
          NavigationService.navigateTo(const ProfileScreen());
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.wifi),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          height: 110,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          )),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is Authenticated) {
                            return Text(
                              state.user.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          } else {
                            return Text(
                              "Unauthenticated",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
