import 'dart:async';

import 'package:al_waleed/features/security_screens/presentation/cubit/secure_screen_cubit.dart';
import 'package:al_waleed/features/security_screens/presentation/widgets/secure_screen_guard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecureScreenScope extends StatefulWidget {
  final SecureScreenCubit cubit;
  final Widget child;

  const SecureScreenScope({
    super.key,
    required this.cubit,
    required this.child,
  });

  @override
  State<SecureScreenScope> createState() => _SecureScreenScopeState();
}

class _SecureScreenScopeState extends State<SecureScreenScope> {
  @override
  void initState() {
    super.initState();

    unawaited(widget.cubit.acquireProtection());
  }

  @override
  void didUpdateWidget(covariant SecureScreenScope oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cubit == widget.cubit) {
      return;
    }

    unawaited(oldWidget.cubit.releaseProtection());
    unawaited(widget.cubit.acquireProtection());
  }

  @override
  void dispose() {
    unawaited(widget.cubit.releaseProtection());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SecureScreenCubit>.value(
      value: widget.cubit,
      child: SecureScreenGuard(child: widget.child),
    );
  }
}
