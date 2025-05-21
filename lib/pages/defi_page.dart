import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leveling_mobile/services/api_service.dart';

class DefiPage extends StatefulWidget {
  const DefiPage({super.key});

  @override
  State<DefiPage> createState() => _DefiPageState();
}

class _DefiPageState extends State<DefiPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _codeController = TextEditingController();

  Map<String, dynamic>? defi;
  Map<String, dynamic>? mission;
  String? status;
  String? resultMessage;
  Timer? _pollingTimer;
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    // Vérifier si l'utilisateur a un défi actif au démarrage
    _fetchLastOrActiveDefi();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submitCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        error = "Veuillez entrer un code de défi valide.";
      });
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final response = await _apiService.request('POST', '/defis', body: {
        "code_defi": code,
      });

      final data = jsonDecode(response.body);
      print("Réponse de création/rejoindre défi: $data");

      if (response.statusCode == 201 && data['defi'] != null) {
        // Nouveau défi créé
        setState(() {
          defi = data['defi'];
          status = data['defi']['status'] ?? "PENDING";
          resultMessage = data['message'] ?? "Défi créé, en attente d'un adversaire";
        });
        _startPolling(defi!['id']);
      } else if (response.statusCode == 200) {
        // Plusieurs possibilités ici
        if (data['mission'] != null) {
          // Défi rejoint avec succès
          setState(() {
            status = "ACTIVE";
            mission = data['mission'];
            resultMessage = data['message'] ?? "Défi actif";

            // S'il y a un ID de défi dans la réponse
            if (data['defi'] != null && data['defi']['id'] != null) {
              defi = data['defi'];
            } else if (data['id'] != null) {
              defi = {'id': data['id']};
            }
          });
        } else if (data['message'] != null) {
          if (data['message'].contains("complet")) {
            setState(() {
              error = "Ce défi est déjà complet.";
            });
          } else if (data['message'].contains("inscrit")) {
            setState(() {
              error = "Vous êtes déjà inscrit à ce défi.";
              // Récupérer les infos du défi actuel
              _fetchLastOrActiveDefi();
            });
          } else {
            setState(() {
              error = data['message'];
            });
          }
        }
      } else {
        // Cas d'erreur
        setState(() {
          error = data['message'] ?? "Une erreur est survenue.";
        });
      }
    } catch (e) {
      setState(() {
        error = "Erreur: ${e.toString()}";
      });
    }

    setState(() => loading = false);
  }

  void _startPolling(int defiId) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final response = await _apiService.request('GET', '/defis/last-user-defi');
        if (response.statusCode != 200) return;

        final data = jsonDecode(response.body);
        print("Polling défi $defiId: $data");

        // Vérifier si le deuxième joueur a rejoint
        if (data['status'] == 'ACTIVE' && data['fk_user2'] != null) {
          _stopPolling();

          // Extraire les informations de mission si disponibles
          Map<String, dynamic>? missionData;
          if (data['mission'] != null) {
            missionData = data['mission'];
          }

          setState(() {
            status = 'ACTIVE';
            defi = data;
            if (missionData != null) {
              mission = missionData;
            }
          });
        }
      } catch (e) {
        print("Erreur de polling: $e");
      }
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _fetchLastOrActiveDefi() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final response = await _apiService.request('GET', '/defis/last-user-defi');
      print('Code de statut: ${response.statusCode}');
      print('Corps de la réponse: ${response.body}');

      if (response.statusCode == 404) {
        setState(() {
          status = null; // Pas de défi actif
        });
        return;
      }

      final data = jsonDecode(response.body);
      print('Réponse de l\'API dernier défi utilisateur: $data');

      setState(() {
        // Analyse de la structure de la réponse
        if (data['id'] != null) {
          // Si c'est un défi formaté directement
          defi = {'id': data['id']};
          status = data['status'] ?? 'UNKNOWN';
        } else if (data['defi'] != null) {
          // Si le défi est encapsulé
          defi = data['defi'];
          status = data['defi']['status'] ?? 'UNKNOWN';
        } else if (data['winner'] != null) {
          // C'est probablement un défi terminé
          defi = data; // Utiliser la réponse complète
          status = "FINISHED";
        }

        // Extraction des informations de mission
        if (data['mission'] != null) {
          mission = data['mission'];
        } else if (data['fk_mission'] != null) {
          // La mission est référencée par ID dans le défi
          // On pourrait faire un appel séparé pour la récupérer si nécessaire
        }

        // Gestion du message de résultat
        resultMessage = data['message'];

        if (status == "FINISHED") {
          if (data['message'] != null && data['message'].contains("gagné")) {
            resultMessage = "Succès : Vous avez gagné le défi !";
          } else if (data['message'] != null && data['message'].contains("perdu")) {
            resultMessage = "Échec : Vous avez perdu le défi.";
          }
        } else if (status == "ACTIVE") {
          resultMessage = "Défi en cours - Relevez le challenge !";
        } else if (status == "PENDING") {
          resultMessage = "En attente d'un adversaire";
        }
      });
    } catch (e) {
      print('Erreur lors de la récupération du défi : $e');
      setState(() {
        error = "Erreur: ${e.toString()}";
        status = null; // Réinitialiser pour permettre de créer un nouveau défi
      });
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> _validateDefi() async {
    if (defi == null) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final response = await _apiService.request('GET', '/defis/last-user-defi');
      final data = jsonDecode(response.body);

      print("Réponse de validation: $data");

      setState(() {
        status = data['status'] ?? "UNKNOWN";
        resultMessage = data['message'];

        if (data['status'] == 'PASSED' || (data['message'] != null && data['message'].contains("gagné"))) {
          status = "FINISHED";
          resultMessage = "Succès : Vous avez gagné le défi !";
        } else if (data['status'] == 'FAILED' || (data['message'] != null && data['message'].contains("perdu"))) {
          status = "FINISHED";
          resultMessage = "Échec : Vous avez perdu le défi.";
        }

        if (data['totalPoints'] != null) {
          resultMessage = (resultMessage ?? "") + "\nPoints totaux: ${data['totalPoints']}";
        }
      });
    } catch (e) {
      print("Erreur lors de la validation: $e");
      setState(() {
        error = "Erreur lors de la validation: ${e.toString()}";
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rejoindre un défi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchLastOrActiveDefi,
            tooltip: 'Rafraîchir',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (status == null) ...[
                    const Text("Code de défi", style: TextStyle(fontSize: 18)),
                    TextField(
                      controller: _codeController,
                      decoration: const InputDecoration(hintText: "Ex : test"),
                      onSubmitted: (_) => _submitCode(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _submitCode,
                          child: const Text("Rejoindre"),
                        ),
                        TextButton(
                          onPressed: _fetchLastOrActiveDefi,
                          child: const Text("Vérifier mes défis"),
                        ),
                      ],
                    ),
                  ],
                  if (status == "PENDING") ...[
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              "En attente d'un adversaire",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                                "Code du défi: ${defi?['code_defi'] ?? _codeController.text}"),
                            const SizedBox(height: 20),
                            const CircularProgressIndicator(),
                            const SizedBox(height: 10),
                            const Text(
                                "Partagez ce code avec un ami pour commencer le défi!"),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (status == "ACTIVE" && (mission != null || defi != null)) ...[
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mission: ${mission?['name'] ?? 'Défi actif'}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text(
                                "${mission?['description'] ?? 'Complète ce défi avant ton adversaire!'}"),
                            if (resultMessage != null) ...[
                              const SizedBox(height: 10),
                              Text(resultMessage!,
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic)),
                            ],
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: _validateDefi,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 16),
                                ),
                                child: const Text("Valider le défi",
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (status == "FINISHED" && resultMessage != null) ...[
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              resultMessage!.contains("gagné")
                                  ? Icons.emoji_events
                                  : Icons.sentiment_dissatisfied,
                              size: 60,
                              color: resultMessage!.contains("gagné")
                                  ? Colors.amber
                                  : Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              resultMessage!,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  status = null;
                                  defi = null;
                                  mission = null;
                                  resultMessage = null;
                                  _codeController.clear();
                                });
                              },
                              child: const Text("Nouveau défi"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            error = null;
                          });
                        },
                        child: const Text("Effacer l'erreur"),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Center(
                    child: Text(
                      "Statut: ${status ?? 'Aucun défi en cours'}",
                      style: TextStyle(
                          color: Colors.grey[600], fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}