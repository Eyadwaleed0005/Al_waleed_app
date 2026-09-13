import 'dart:async';

import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/connection/cubit/network_status_state.dart';
import 'package:al_waleed/features/exams/presentation/cubit/pending_exam_submissions_sync_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingExamSubmissionsSyncHandler extends StatefulWidget {
  const PendingExamSubmissionsSyncHandler({super.key, required this.child});

  final Widget child;

  @override
  State<PendingExamSubmissionsSyncHandler> createState() {
    return _PendingExamSubmissionsSyncHandlerState();
  }
}

class _PendingExamSubmissionsSyncHandlerState
    extends State<PendingExamSubmissionsSyncHandler>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !mounted) {
      return;
    }

    unawaited(context.read<PendingExamSubmissionsSyncCubit>().retryNow());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkStatusCubit, NetworkStatusState>(
      listenWhen: (NetworkStatusState previous, NetworkStatusState current) {
        return current is NetworkStatusConnected &&
            previous is! NetworkStatusConnected;
      },
      listener: (BuildContext context, NetworkStatusState state) {
        unawaited(context.read<PendingExamSubmissionsSyncCubit>().retryNow());
      },
      child: widget.child,
    );
  }
}
