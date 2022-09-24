import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musclatax/components/button.dart';
import 'package:musclatax/components/container.dart';
import 'package:musclatax/model/model.dart';
import 'package:musclatax/tools/helper.dart';
import 'package:musclatax/views/seance/weight_list.dart';
import 'package:musclatax/components/utils.dart' as uu;

/* Flutter background service */

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SeanceIsolate {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );
    service.startService();
  }

  @pragma('vm:entry-point')
  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();

    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
          title: "Musclatax", content: "En attente");
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
    List<Exercice> exercices = [];
    int exerciceIndex = 0;
    int seriesIndex = 0;
    int currentRestTime = 0;
    int kgUsed = 5;
    bool started = false;
    bool done = false;
    debugPrint("D => register startSeance");

    service.on("startSeance").listen((event) async {
      debugPrint("A => $event");
      debugPrint("B => $started");
      debugPrint("C => $exercices");
      if (event != null && !started) {
        List<dynamic> exec = event["exercices"];
        exercices = exec
            .map((e) => e as String)
            .map((s) => Exercice.fromMap(json.decode(s)))
            .toList();
        exerciceIndex = 0;
        currentRestTime = 0;
        started = true;
      }
    });

    service.on("setWeight").listen((event) {
      debugPrint(event.toString());
      int weight = event!["weight"];
      kgUsed = weight;
    });

    service.on("startRepos").listen((event) {
      Exercice current = exercices[exerciceIndex];
      // Check si on doit augmenter le nombre de série
      seriesIndex++;
      if (seriesIndex >= (current.series ?? 4)) {
        // Index de série allat de 0 à series-1, si on est égal ça veut dire qu'on a fini l'exercice
        exerciceIndex++;
        if (exerciceIndex >= exercices.length) {
          // On a dépassé le nombre d'exo, donc en gros on a fini la séance, doit dépop
          service.invoke("update", {
            "close": true,
          });
          return;
        }
        seriesIndex = 0;
        currentRestTime = 0;
      } else {
        currentRestTime = 0;
      }
      // TODO check si on est au dernier exo pour update l'UI en conséquence
      done = false;
    });

    // bring to foreground
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      /// you can see this log in logcat
      if (!started) {
      } else {
        if (exerciceIndex >= exercices.length) return;
        Exercice current = exercices[exerciceIndex];
        if (currentRestTime < (current.rest ?? 0)) {
          currentRestTime++;
          service.invoke("update", {
            "exercice": current,
            "rest": currentRestTime,
            "serie": seriesIndex,
            "exerciceIndex": exerciceIndex,
            "exerciceLength": exercices.length,
          });
          if (service is AndroidServiceInstance) {
            service.setForegroundNotificationInfo(
                title: "Musclatax",
                content: uu.DateUtils.formatSecond(currentRestTime));
          }
          return;
        } else if (!done) {
          // Performed.withFields(exercices[exerciceIndex].id, seriesIndex, kgUsed,
          //         DateTime.now())
          //     .save();
          debugPrint(
              "Exercice sauvegardé '${exercices[exerciceIndex].name}', series N°$seriesIndex"
              " <> kg $kgUsed, dateTime ${DateTime.now()}");
          done = true;
        }
      }
    });
  }

  static stop() {
    final service = FlutterBackgroundService();
    service.invoke("stopService");
  }
}

class SeanceRunning extends StatefulWidget {
  List<Exercice> exercices;

  SeanceRunning({super.key, required this.exercices});

  @override
  State<StatefulWidget> createState() => _State(exercices: exercices);
}

class _State extends State<SeanceRunning> {
  List<Exercice> exercices;
  int selectedWeight = 0;
  bool showWeight = true;

  _State({required this.exercices});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int size = 40;
    return Scaffold(
      body: DefaultContainer(
          topbottom: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<Map<String, dynamic>?>(
                  stream: FlutterBackgroundService().on("update"),
                  initialData: {
                    "exercice": exercices.first,
                    "rest": -1,
                    "serie": 0
                  },
                  builder: ((context, snapshot) {
                    dynamic strData = snapshot.data ?? "";
                    if (!snapshot.hasData ||
                        (snapshot.data != null &&
                            (snapshot.data!.containsKey("started")))) {
                      return WhiteNeumorphismButton(
                        content: "Appuyer pour commencer",
                        fontSize: 12,
                        color: UITools.mainTextColor,
                        backgroundColor: UITools.mainBgColor,
                        minWidth: 80,
                        horizontal: size,
                        vertical: size + 60,
                        onPressed: () {
                          final service = FlutterBackgroundService();
                          service
                              .invoke("startSeance", {"exercices": exercices});
                        },
                      );
                    }
                    if (!snapshot.hasData ||
                        (snapshot.data != null &&
                            (snapshot.data!.containsKey("close")))) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (mounted) {
                          setState(() {
                            Navigator.pop(context);
                          });
                        }
                      });
                      return Container();
                    }

                    final data = snapshot.data!;
                    Exercice currentExercice = data["exercice"] is Exercice
                        ? data["exercice"]
                        : Exercice.fromMap(jsonDecode(data["exercice"]));
                    int currentRestTime = data["rest"];
                    int currentSerie = data["serie"];
                    bool ended = currentExercice.rest == currentRestTime;
                    bool setupState = currentRestTime == -1;
                    if (setupState) {
                      ended = true;
                    }
                    int exIndex = data["exerciceIndex"] ?? 0;
                    int maxSeries = currentExercice.series ?? 0;
                    bool lastExerciceLastSerie =
                        exIndex == exercices.length - 1 &&
                            currentSerie == maxSeries - 1;

                    String from = uu.DateUtils.formatSecond(currentRestTime);
                    String end =
                        uu.DateUtils.formatSecond(currentExercice.rest ?? 60);

                    Color backgroundColor = ended
                        ? UITools.mainBgSuccessColor
                        : UITools.mainBgErrorColor;
                    int widthHeight = size + 80;
                    double fontSize = 12;
                    String text = "";

                    if (lastExerciceLastSerie && ended) {
                      backgroundColor = UITools.mainBgColorLighter;
                      widthHeight = size;
                      text = "Finir la séance";
                      fontSize = 18;
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (mounted) {
                          setState(() {
                            showWeight = false;
                          });
                        }
                      });
                    }
                    return Column(
                      children: [
                        WhiteNeumorphismButton(
                          content: text,
                          fontSize: fontSize,
                          color: UITools.mainTextColor,
                          backgroundColor: backgroundColor,
                          minWidth: 80,
                          horizontal: widthHeight,
                          vertical: widthHeight,
                          onPressed: () {
                            final service = FlutterBackgroundService();
                            if (setupState) {
                              service.invoke(
                                  "startSeance", {"exercices": exercices});
                            } else {
                              service.invoke("startRepos");
                            }
                          },
                        ),
                        ended ? const SizedBox.shrink() : Text("$from / $end"),
                        ended
                            ? const SizedBox.shrink()
                            : LinearProgressIndicator(
                                value: uu.MathUtils.map(
                                    currentRestTime.toDouble(),
                                    0,
                                    (currentExercice.rest ?? 60).toDouble(),
                                    0,
                                    1),
                                semanticsLabel: 'Linear progress indicator',
                              ),
                        Container(
                          margin: const EdgeInsets.only(top: 25, bottom: 25),
                          child: Column(
                            children: [
                              Text(
                                "${currentExercice.name}",
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                  "Série n°${currentSerie + 1}/${currentExercice.series}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic))
                            ],
                          ),
                        ),
                      ],
                    );
                  })),
              showWeight
                  ? WeightList(
                      selectedWeight: selectedWeight,
                      onUpdate: (int index) {
                        setState(() {
                          selectedWeight = index;
                        });
                        final service = FlutterBackgroundService();
                        service.invoke(
                            "setWeight", {"weight": (selectedWeight + 1) * 5});
                      },
                    )
                  : Container()
            ],
          )),
    );
  }
}
