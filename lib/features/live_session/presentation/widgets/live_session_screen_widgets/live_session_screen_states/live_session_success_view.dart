import 'package:al_waleed/features/live_session/domain/entity/live_session_entity.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_card/live_session_card.dart';
import 'package:flutter/material.dart';

class LiveSessionSuccessView extends StatelessWidget {
  final LiveSessionEntity liveSession;

  const LiveSessionSuccessView({
    super.key,
    required this.liveSession,
  });

  @override
  Widget build(BuildContext context) {
    return LiveSessionCard(
      liveSession: liveSession,
    );
  }
}