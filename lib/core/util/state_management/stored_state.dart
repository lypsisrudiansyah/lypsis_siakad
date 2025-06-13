import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

extension ValueNotifierExtension on dynamic {
  // If you want to store a value in SharedPreferences
  // You must implement T as the type of the value you want to store
  ValueNotifier<T> watch<T>({
    String key = "",
  }) {
    var vn = ValueNotifier<T>(this as T);

    if (key.isNotEmpty) {
      // Load initial value
      SharedPreferences.getInstance().then((prefs) {
        if (prefs.containsKey(key)) {
          if (T == int) {
            vn.value = prefs.getInt(key) as T ?? this as T;
          } else if (T == double) {
            vn.value = prefs.getDouble(key) as T ?? this as T;
          } else if (T == bool) {
            vn.value = prefs.getBool(key) as T ?? this as T;
          } else if (T == String) {
            vn.value = prefs.getString(key) as T ?? this as T;
          }
        }
      });

      // Save on changes
      vn.addListener(() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (vn.value is int) {
          await prefs.setInt(key, vn.value as int);
        } else if (vn.value is double) {
          await prefs.setDouble(key, vn.value as double);
        } else if (vn.value is bool) {
          await prefs.setBool(key, vn.value as bool);
        } else if (vn.value is String) {
          await prefs.setString(key, vn.value as String);
        }
      });
    }

    return vn;
  }
}

//eg

class ValueNotifierExtensionWidgetExample extends StatefulWidget {
  const ValueNotifierExtensionWidgetExample({super.key});

  @override
  State<ValueNotifierExtensionWidgetExample> createState() =>
      _ValueNotifierExtensionWidgetExampleState();
}

class _ValueNotifierExtensionWidgetExampleState
    extends State<ValueNotifierExtensionWidgetExample> {
  var x = 0.watch<int>();
  var y = 0.watch<int>();
  var z = 0.watch<int>(
    key: "z",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Value Storage Demo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      "Persistent Storage Demo",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      "Values are automatically saved to SharedPreferences",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: x,
                        builder: (context, __, _) {
                          return InkWell(
                            onTap: () {
                              x.value++;
                            },
                            child: Text(
                              "X: ${x.value}",
                              style: const TextStyle(
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Watcher(
                        listen: y,
                        builder: (value) {
                          return InkWell(
                            onTap: () {
                              y.value += 2;
                            },
                            child: Text(
                              "Y: ${value}",
                              style: const TextStyle(
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Watcher(
                        listen: z,
                        builder: (value) {
                          return InkWell(
                            onTap: () {
                              z.value += 3;
                            },
                            child: Text(
                              "Z: ${value}",
                              style: const TextStyle(
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text(
                "Increment Value",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                x.value++;
                y.value += 2;
              },
            ),
          ],
        ),
      ),
    );
  }
}

//Shorter version of ValueListenableBuilder
Widget Watcher<T>({
  required ValueNotifier<T> listen,
  required Widget Function(T) builder,
}) {
  return ValueListenableBuilder<T>(
    valueListenable: listen,
    builder: (context, value, child) => builder(value),
  );
}
