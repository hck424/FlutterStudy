import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PlatformView());
}

class PlatformView extends StatelessWidget {
  const PlatformView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform Sheet View',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int _counter = 0;
class _HomePageState extends State<HomePage> {
  static const MethodChannel platform = MethodChannel('dev.flutter.flutter-study/platform_sheet_view');

  Future<void> _launchPlatformCount() async {
    final platformCounter = await platform.invokeMethod<int>(
      'switchView',
      _counter,
    );
    setState(() => _counter = platformCounter ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page')
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  "Button tapped $_counter time${_counter == 1 ? '' : 's'}.",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _launchPlatformCount,
                  child: const Text('Continue in iOS View'),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 15, left: 5),
            child: Row(
              children: [
                const FlutterLogo(),
                Text(
                  'Flutter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _counter++;
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}