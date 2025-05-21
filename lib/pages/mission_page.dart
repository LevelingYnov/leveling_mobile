import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leveling_mobile/providers/user_provider.dart';
import 'package:leveling_mobile/services/mission_service.dart';
import 'package:leveling_mobile/services/timer_service.dart';

class MissionPage extends StatefulWidget {
  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  late TimerService _timerService;
  bool _showCountdown = true;
  int _countdown = 10;
  Timer? _countdownTimer;

  Map<String, dynamic>? _currentMission;
  Map<String, dynamic>? _currentDifficulty;
  bool _isMissionCompleted = false;
  bool _isMissionFailed = false;

  @override
  void initState() {
    super.initState();
    _loadMission();
  }

  void _startInitialCountdown() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        setState(() {
          _showCountdown = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  Future<void> _loadMission() async {
    try {
      final response = await MissionService.triggerMissionEvent('MISSION');

      if (response == null ||
          response['status'] == 404 ||
          response['mission'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ 404 : Aucune mission en cours trouvée.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
        return;
      }

      final mission = response['mission'];
      final difficulty = response['difficulty'];

      // Vérifiez le statut de la mission
      if (mission['status'] == 'penality') {
        setState(() {
          _isMissionFailed = true;
        });
        // Si c'est une mission de pénalité, retirez les 10 secondes du timer
        _startPenaltyCountdown();
      } else {
        setState(() {
          _isMissionFailed = false;
        });
        _startInitialCountdown();
      }

      _timerService = TimerService(
        total: Duration(
            seconds: mission['limit_time'] - (_isMissionFailed ? 10 : 0)),
      );
      _timerService.start();

      setState(() {
        _currentMission = mission;
        _currentDifficulty = difficulty;
      });
    } catch (e) {
      print('Erreur de mission : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erreur de chargement de la mission'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startPenaltyCountdown() {
    _showCountdown = true;
    _countdown = 10;
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        setState(() {
          _showCountdown = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void _validateMission() async {
    final status = await MissionService.checkMissionStatus('quest');

    if (status['status'] == 'PASSED') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Mission réussie !")),
      );
      Navigator.pop(context, true);
    } else if (status['status'] == 'FAILED') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "❌ Mission échouer vous venez de perdre ${status["pointsLost"]} points !")),
      );
      Navigator.pop(context, false);
    } else if (status["mission"]["status"] == 'penality') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Mission échouée ! Mission de pénalité en cours..."),
          backgroundColor: Colors.red,
        ),
      );

      // Récupérer les informations de la mission de pénalité
      final penaltyResponse = status;
      if (penaltyResponse.containsKey('mission') &&
          penaltyResponse.containsKey('difficulty')) {
        final mission = penaltyResponse['mission'];
        final difficulty = penaltyResponse['difficulty'];

        // Mettre à jour l'interface utilisateur avec les informations de la mission de pénalité
        setState(() {
          _currentMission = mission;
          _currentDifficulty = difficulty;
          _isMissionFailed = true;
        });

        // Redémarrer le timer pour la mission de pénalité
        _timerService.stop();
        _timerService = TimerService(
          total: Duration(seconds: mission['limit_time']),
        );
        _timerService.start();

        // Redémarrer le compteur de 10 secondes avec un fond noir dégradé rouge
        _startPenaltyCountdown();
      }
    } else if (status['status'] == 404) {
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        // Image d'arrière-plan
        Positioned.fill(
          child: Image.asset(
            'lib/assets/leveling_fond1.png',
            fit: BoxFit.cover,
          ),
        ),
        // Dégradé avec opacité réduite
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isMissionFailed
                    ? [
                        Colors.red[900]!.withOpacity(0.9),
                        Colors.black.withOpacity(0.9)
                      ]
                    : [
                        Colors.black.withOpacity(0.9),
                        Color(0xFF1A1D4D).withOpacity(0.9)
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        // Contenu centré
        Center(
          child: _showCountdown
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_countdown',
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: 1 - (_countdown / 10),
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isMissionFailed
                            ? Color(0xFFA92424)
                            : Color(0xFF242CA9),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20), // 👈 marge à gauche/droite
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(30), // 👈 padding interne
                        decoration: BoxDecoration(
                          color: Color(0x8005091C),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_isMissionFailed)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  "⚠️ Mission de pénalité en cours",
                                  style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (_currentMission != null) ...[
                              Text(
                                'Mission : Effectuer ${_currentMission!['name']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Effectuer ${_currentMission!['name']} en moins de ${(_currentMission!['limit_time'] / 60).ceil()} minutes pour remporter ${_currentMission!['points']} points. Échouer vous fera perdre des points.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              ),
                              SizedBox(height: 10),
                              if (_currentDifficulty != null)
                                Text(
                                  'Difficulté : ${_currentDifficulty!['name']}',
                                  style: TextStyle(color: Colors.orangeAccent),
                                ),
                              SizedBox(height: 20),
                              Text(
                                'Temps restant pour valider',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              SizedBox(height: 10),
                              if (_timerService.stream != null)
                                StreamBuilder<Duration>(
                                  stream: _timerService.stream,
                                  builder: (context, snapshot) {
                                    final remaining =
                                        snapshot.data ?? _timerService.total;
                                    final total = _timerService.total.inSeconds;
                                    final remainingSeconds =
                                        remaining.inSeconds;
                                    final percent =
                                        1 - (remainingSeconds / total);
                                    return Column(
                                      children: [
                                        LinearProgressIndicator(
                                          value: 1 - percent,
                                          backgroundColor: Colors.grey,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            _isMissionFailed
                                                ? Color(0xFFA92424)
                                                : Color(0xFF242CA9),
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          '${remaining.inMinutes} min ${remaining.inSeconds % 60} sec',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              SizedBox(height: 40),
                              ElevatedButton(
                                onPressed: _validateMission,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  child: Text("Valider",
                                      style: TextStyle(fontSize: 16)),
                                ),
                              )
                            ] else
                              CircularProgressIndicator(color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _timerService.stop();
    super.dispose();
  }
}
