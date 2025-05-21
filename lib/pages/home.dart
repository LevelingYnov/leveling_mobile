import 'package:flutter/material.dart';
import '../widgets/conteneur.dart';
import 'package:provider/provider.dart';
import 'package:leveling_mobile/providers/user_provider.dart';
import 'package:leveling_mobile/services/auth_service.dart';
import 'package:leveling_mobile/services/mission_service.dart';
import 'package:leveling_mobile/pages/defi_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'mission_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  bool _isLoading = false;
  String? _missionMessage;
  DateTime? _nextMissionTime;
  Timer? _missionCheckTimer;

  @override
  void initState() {
    super.initState();
    _checkMissionStatus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
    });

    _missionCheckTimer = Timer.periodic(
        Duration(minutes: 1), (Timer t) => _checkMissionStatus());
  }

  @override
  void dispose() {
    _missionCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkMissionStatus() async {
    try {
      final response = await MissionService.triggerMissionEvent('MISSION');

      if (response.containsKey('message')) {
        setState(() {
          _missionMessage = response['message'];

          if (!_missionMessage!.contains('déjà en cours') &&
              !_missionMessage!.contains('assignée avec succès')) {
            // Extract start and end times from the message
            final startTimeStr =
                _missionMessage!.split('entre ')[1].split(' et ')[0];

            DateFormat format = DateFormat("HH:mm");
            DateTime now = DateTime.now();
            DateTime startTime = format.parse(startTimeStr);

            DateTime nextStartTime = DateTime(
                now.year, now.month, now.day, startTime.hour, startTime.minute);
            if (now.isAfter(nextStartTime)) {
              nextStartTime = nextStartTime.add(Duration(days: 1));
            }

            _nextMissionTime = nextStartTime;
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MissionPage()),
            ).then((_) {
              // Rafraîchir les données après le retour de MissionPage
              _refreshMissionData();
            });
          }
        });
      }
    } catch (e) {
      print('Erreur lors de la vérification de la mission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la vérification de la mission: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshMissionData() async {
    await _checkMissionStatus();
  }

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.logout(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la déconnexion'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05091C),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/leveling_fond1.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Color.fromRGBO(5, 9, 28, 0.85),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF242CA9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.logout, color: Colors.white),
                              onPressed: _logout,
                              tooltip: 'Déconnexion',
                            ),
                          ),
                        ),
                  SizedBox(height: 20),
                  buildUserHeader(),
                  SizedBox(height: 20),
                  if (_nextMissionTime != null) buildMissionHeader(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserHeader() {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF101633),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          buildUserAvatar(userProvider.avatar),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userProvider.username ?? '',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text('${userProvider.points} points',
                  style: TextStyle(color: Colors.white54)),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget buildMissionHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF101633),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quêtes journalières',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('La voie vers la puissance',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 20),

          // Bloc Timer + Progress
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFF1A1F3C), // Légèrement plus foncé
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Temps restants',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 8),
                CountdownTimer(endTime: _nextMissionTime!),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        minHeight: 6,
                        value: _calculateProgress(_nextMissionTime!),
                        backgroundColor: Colors.white10,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF242CA9)),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Attention : ',
                    style: TextStyle(
                      color: Color(0xFF242CA9),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Un échec entraînera une punition liée à cette quête',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => DefiPage()),
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Color(0xFF3A47F3),
          //       padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //       elevation: 4,
          //     ),
          //     child: Text(
          //       'Lancer un défi !',
          //       style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  double _calculateProgress(DateTime endTime) {
    final now = DateTime.now();
    final total = Duration(hours: 12, minutes: 32, seconds: 32).inSeconds;
    final remaining = endTime.difference(now).inSeconds;
    return (total - remaining).clamp(0, total) / total;
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime endTime;

  CountdownTimer({required this.endTime});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.endTime.difference(DateTime.now());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final diff = widget.endTime.difference(DateTime.now());
      if (diff.isNegative) {
        timer.cancel();
        setState(() => _remainingTime = Duration.zero);
      } else {
        setState(() => _remainingTime = diff);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(_remainingTime.inHours.remainder(24));
    final minutes = strDigits(_remainingTime.inMinutes.remainder(60));
    final seconds = strDigits(_remainingTime.inSeconds.remainder(60));

    return Text(
      '$hours:$minutes:$seconds',
      style: TextStyle(
          color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
    );
  }
}

Widget buildUserAvatar(String? imageUrl, {double radius = 30}) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[800],
      child: Icon(Icons.person, color: Colors.white, size: radius),
    );
  }

  final isSvg = imageUrl.toLowerCase().endsWith('.svg');

  if (isSvg) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: ClipOval(
        child: SvgPicture.network(
          imageUrl,
          fit: BoxFit.cover,
          placeholderBuilder: (context) => Container(
            color: Colors.grey[800],
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        ),
      ),
    );
  } else {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[800],
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}
