import 'dart:async';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  final BuildContext context;
  // StreamController para manejar la repetición de los mensajes
  Stream<String> getLoadingMessages() {
    final messages = <String>[
      AppLocalizations.of(context)!.loadingData,
      AppLocalizations.of(context)!.buyingPopcorn,
      AppLocalizations.of(context)!.weAreAboutToStart,
      AppLocalizations.of(context)!.aFewMoreSeconds,
      AppLocalizations.of(context)!.almostReady,
      AppLocalizations.of(context)!.thisIsTakingLongerThanUsual,
      AppLocalizations.of(context)!.isTimeToHaveFun,
    ];

    // Creamos el StreamController
    final controller = StreamController<String>();

    // Función para generar los mensajes cíclicamente
    void sendMessages() {
      int index = 0;
      Timer.periodic(Duration(seconds: 2), (timer) {
        controller.add(messages[index]); // Enviar el mensaje actual
        index++;
        if (index >= messages.length) {
          index = 0; // Reinicia el índice después de llegar al final
        }
      });
    }

    sendMessages(); // Inicia la generación de mensajes

    return controller.stream; // Retorna el stream
  }

  const FullScreenLoader({required this.context, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 230,
            child: Center(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 37,
                    child: Image.asset(
                      'assets/images/1.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  Positioned(
                    bottom: 58,
                    right: 3,
                    child: Spin(
                      animate: true,
                      duration: Duration(seconds: 2),
                      infinite: true,
                      child: Image.asset(
                        'assets/images/+.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FadeIn(
                      animate: true,
                      duration: Duration(seconds: 3),
                      child: Image.asset('assets/images/cine.png', width: 80),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          StreamBuilder<String>(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text(AppLocalizations.of(context)!.starting);
              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}
