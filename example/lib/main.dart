import 'package:flutter/material.dart';
import 'dart:async';

import 'package:osenv/osenv.dart' as osenv;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _varName = "FL_TEST_VAR";
  static const _varValue = "Success! ☺";

  String varValue = "<unknown>";

  late int sumResult;
  late Future<int> sumAsyncResult;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 20, fontWeight: .bold);
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('OsEnv Example')),
          body: Container(
            width: double.infinity,
            padding: const .all(10),
            child: Column(
              spacing: 30,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                Text(
                  '$_varName = $varValue',
                  style: textStyle,
                  textAlign: .center,
                  overflow: .ellipsis,
                ),
                // vspace,
                FilledButton(
                  onPressed: () {
                    _setVar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Variable $_varName set'),
                        duration: Durations.long4,
                      ),
                    );
                    setState(() {
                      _getVar();
                    });
                  },
                  child: Text('Set variable'),
                ),
                // vspace,
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _getVar();
                    });
                  },
                  child: Text('Get variable'),
                ),
                // vspace,
                FilledButton(
                  onPressed: () {
                    _unsetVar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Variable $_varName removed from the process',
                        ),
                        duration: Durations.long4,
                      ),
                    );
                    setState(() {
                      _getVar();
                    });
                  },
                  child: Text('Unset variable'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setVar() {
    osenv.setEnv(_varName, _varValue);
  }

  void _getVar() {
    varValue = osenv.getEnv(_varName) ?? "<not set>";
  }

  void _unsetVar() {
    final r = osenv.unsetEnv(_varName);
    debugPrint("unset return code: $r");
  }
}
