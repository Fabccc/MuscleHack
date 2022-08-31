import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:musclatax/components/button.dart';
import 'package:musclatax/components/container.dart';
import 'package:musclatax/model/model.dart';
import 'package:musclatax/tools/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musclatax/components/utils.dart' as uu;

class SeanceIsolate {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,
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

  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('FLUTTER BACKGROUND FETCH');

    return true;
  }

  static void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    List<Exercice> exercices = [];
    int exerciceIndex = 0;
    int seriesIndex = 0;
    int currentRestTime = 0;
    int kgUsed = 0;
    bool started = false;

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
          title: "Musclatax", content: "En attente");
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    service.on("startSeance").listen((event) async {
      if (event != null && !started) {
        List<dynamic> exec = event["exercices"];
        exercices = exec
            .map((e) => e as String)
            .map((s) => Exercice.fromMap(json.decode(s)))
            .toList();
        exerciceIndex = 0;
        currentRestTime = 0;
        kgUsed = 0;
        started = true;
      }
    });

    service.on("startRepos").listen((event) {
      Exercice current = exercices[exerciceIndex];
      // Check si on doit augmenter le nombre de série
      seriesIndex++;
      if (seriesIndex <= (current.series ?? 4)) {
        // Index de série allat de 0 à series-1, si on est égal ça veut dire qu'on a fini l'exercice
        exerciceIndex++;
      }
    });

    // bring to foreground
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      /// you can see this log in logcat
      if (!started) {
        service.invoke(
          'update',
          {
            "started": false,
          },
        );
      } else {
        Exercice current = exercices[exerciceIndex];
        if (currentRestTime < (current.rest ?? 0)) {
          currentRestTime++;
          service
              .invoke("update", {"exercice": current, "rest": currentRestTime});
          if (service is AndroidServiceInstance) {
            service.setForegroundNotificationInfo(
                title: "Musclatax",
                content: uu.DateUtils.formatSecond(currentRestTime));
          }
          return;
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

  _State({required this.exercices});

  @override
  Widget build(BuildContext context) {
    int size = 40;
    return Scaffold(
      body: DefaultContainer(
          child: Column(
        children: [
          StreamBuilder<Map<String, dynamic>?>(
              stream: FlutterBackgroundService().on("update"),
              builder: ((context, snapshot) {
                dynamic strData = snapshot.data ?? "";
                debugPrint(strData.toString());
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
                      service.invoke("startSeance", {"exercices": exercices});
                    },
                  );
                }

                final data = snapshot.data!;
                Exercice currentExercice =
                    Exercice.fromMap(json.decode(data["exercice"]));
                int currentRestTime = data["rest"];
                bool ended = currentExercice.rest == currentRestTime;

                String from = uu.DateUtils.formatSecond(currentRestTime);
                String end =
                    uu.DateUtils.formatSecond(currentExercice.rest ?? 60);

                return Column(
                  children: [
                    WhiteNeumorphismButton(
                      content: "",
                      fontSize: 12,
                      color: UITools.mainTextColor,
                      backgroundColor: ended
                          ? UITools.mainBgSuccessColor
                          : UITools.mainBgErrorColor,
                      minWidth: 80,
                      horizontal: size + 80,
                      vertical: size + 80,
                      onPressed: () {
                        final service = FlutterBackgroundService();
                        service.invoke("startRepos");
                      },
                    ),
                    Text("$from / $end"),
                    LinearProgressIndicator(
                      value: uu.MathUtils.map(currentRestTime.toDouble(), 0,
                          (currentExercice.rest ?? 60).toDouble(), 0, 1),
                      semanticsLabel: 'Linear progress indicator',
                    )
                  ],
                );
              })),
          Container(
            margin: const EdgeInsets.only(top: 25, bottom: 25),
            child: Row(
              children: [Text("Exercice "), Text("Repos"), Text("Série")],
            ),
          ),
          Row(
            children: [Text("Choix poids")],
          )
        ],
      )),
    );
  }
}
