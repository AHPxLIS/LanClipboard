import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'utils/fade_page_transitions_builder.dart';
import 'models/app_state.dart';
import 'screens/clipboard_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '剪贴板共享',
      theme: ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            // 手机
            TargetPlatform.android : CupertinoPageTransitionsBuilderCustom(),
            TargetPlatform.iOS     : CupertinoPageTransitionsBuilderCustom(),

            // 桌面
            TargetPlatform.windows : FadePageTransitionsBuilder(),
            TargetPlatform.macOS   : FadePageTransitionsBuilder(),
            TargetPlatform.linux   : FadePageTransitionsBuilder(),

            // 兜底
            TargetPlatform.fuchsia : FadePageTransitionsBuilder(),
          },
        ),
      ),
      home: const ClipboardScreen(),
      builder: EasyLoading.init(),
    );
  }
}
