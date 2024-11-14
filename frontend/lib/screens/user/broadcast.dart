import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:campus_times/provider/broadcast_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../constants/constants.dart';

class BroadcastPage extends ConsumerStatefulWidget {
  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends ConsumerState<BroadcastPage> {
  @override
  Widget build(BuildContext context) {
    final broadcastState = ref.watch(broadcastProvider);
    final broadcastNotifier = ref.read(broadcastProvider.notifier);

    final selectedCategory =
        BroadcastConstants.headings[broadcastState.selectedProgramIndex];
    final broadcasts =
        broadcastState.categorizedBroadcasts[selectedCategory] ?? [];

    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        backgroundColor: Color(0xFF001219),
        appBar: AppBar(
          title: const Text('Broadcasts'),
          backgroundColor: Color(0xFF001219),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children:
                      BroadcastConstants.headings.asMap().entries.map((entry) {
                    int index = entry.key;
                    String heading = entry.value;
                    return GestureDetector(
                      onTap: () {
                        broadcastNotifier.selectProgram(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: broadcastState.selectedProgramIndex == index
                              ? Colors.blue.shade100
                              : Colors.yellow.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          heading,
                          style: TextStyle(
                            color: broadcastState.selectedProgramIndex == index
                                ? Colors.blue
                                : Colors.black,
                            fontSize: 20,
                            fontFamily: 'RobotoFlex',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: MasonryGridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 15.0,
                  itemCount: broadcasts.length,
                  itemBuilder: (context, index) {
                    final broadcast = broadcasts[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: Colors.greenAccent.shade400, width: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              broadcast.title,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              broadcast.body,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '${broadcast.date.day}/${broadcast.date.month}/${broadcast.date.year}',
                                style: TextStyle(
                                  color: Colors.tealAccent.shade700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
