// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'coundown_page.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});

  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  late List<CountdownProvider> providers;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    providers = List.generate(5, (index) => CountdownProvider(5));
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageController()),
        ...providers
            .map((provider) => ChangeNotifierProvider.value(value: provider)),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Countdown App')),
        body: PageView.builder(
          controller: _pageController,
          itemCount: 5,
          itemBuilder: (context, index) {
            return CountdownPage(index: index);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          },
          items: List.generate(
              5,
              (index) => BottomNavigationBarItem(
                  backgroundColor: const Color.fromARGB(255, 43, 1, 157),
                  icon: const Icon(Icons.timer),
                  label: 'Page ${index + 1}')),
        ),
      ),
    );
  }
}

class CountdownProvider extends ChangeNotifier {
  late List<Timer> _timers;
  late List<Duration> _durations;
  late List<bool> _isRunningList;

  List<Duration> get durations => _durations;

  CountdownProvider(int pageCount) {
    _durations =
        List.generate(pageCount, (index) => const Duration(seconds: 60));
    _isRunningList = List.filled(pageCount, false);
    _timers = List.generate(pageCount, (index) => Timer(Duration.zero, () {}));
  }

  String countText(int index) {
    Duration duration = _durations[index];
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress(int index) {
    Duration duration = _durations[index];
    return duration.inSeconds / (60); // 60 saniyelik bir geri sayım
  }

  bool isRunning(int index) {
    return _isRunningList[index];
  }

  void start(int index) {
    if (!_isRunningList[index]) {
      _timers[index] = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_durations[index].inSeconds > 0) {
          _durations[index] = _durations[index] - const Duration(seconds: 1);
          notifyListeners();
        } else {
          _timers[index].cancel();
          _isRunningList[index] = false;
          FlutterRingtonePlayer().playNotification();
        }
      });
      _isRunningList[index] = true;
    }
    notifyListeners();
  }

  void stop(int index) {
    if (_isRunningList[index]) {
      _timers[index].cancel();
      _isRunningList[index] = false;
    }
    notifyListeners();
  }

  void reset(int index) {
    _durations[index] = const Duration(seconds: 60);
    if (_isRunningList[index]) {
      _timers[index].cancel();
      _isRunningList[index] = false;
    }
    notifyListeners();
  }

  void setDuration(Duration duration, int index) {
    _durations[index] = duration;
    notifyListeners();
  }
}
