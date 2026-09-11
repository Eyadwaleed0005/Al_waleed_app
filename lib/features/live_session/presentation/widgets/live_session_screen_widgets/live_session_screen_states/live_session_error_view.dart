import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:flutter/material.dart';

class LiveSessionErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const LiveSessionErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorState(message: errorMessage, onRetry: onRetry);
  }
}
