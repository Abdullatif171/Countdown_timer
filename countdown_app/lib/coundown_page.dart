
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pager_setup.dart';

class CountdownPage extends StatelessWidget {
  final int index;
  const CountdownPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CountdownProvider>();
    return Scaffold(
      backgroundColor: const Color(0xfff5fbff),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                    width: 300,
                    height: 300,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey.shade300,
                      value: provider.progress(index),
                      strokeWidth: 6,
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    if (!provider.isRunning(index)) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SizedBox(
                          height: 300,
                          child: CupertinoTimerPicker(
                            initialTimerDuration: provider.durations[index],
                            onTimerDurationChanged: (time) {
                              provider.setDuration(time, index);
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                      provider.countText(index),
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    var countdownProvider =
                        Provider.of<CountdownProvider>(context, listen: false);
                    if (countdownProvider.isRunning(index)) {
                      countdownProvider.stop(index);
                    } else {
                      countdownProvider.start(index);
                    }
                  },
                  child: Icon(
                      provider.isRunning(index)
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 40,
                    ),
                ),
                GestureDetector(
                  onTap: () {
                    var countdownProvider =
                        Provider.of<CountdownProvider>(context, listen: false);
                    countdownProvider.reset(index);
                  },
                  child: const Icon(
                    Icons.stop,
                    size: 40,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

