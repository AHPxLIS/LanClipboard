import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';

class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Icon(
        appState.isConnected ? Icons.wifi : Icons.wifi_off,
        color: appState.isConnected ? Colors.green : Colors.red,
      ),
    );
  }
}
