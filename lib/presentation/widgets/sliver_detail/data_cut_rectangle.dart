import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class DataCutRentangle extends StatelessWidget {
  const DataCutRentangle({
    super.key,
    required this.size,
    required this.percent,
    required this.data,
  });
  final Size size;
  final double percent;
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.34, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left:
                  percent > 0.13
                      ? size.width * pow(percent, 5.5).clamp(0.0, 0.2)
                      : 0,
              top:
                  size.height *
                  (percent > 0.48 ? pow(percent, 10.5).clamp(0.0, 0.06) : 0.0),
            ),
            child: Text(
              data.title,
              style: TextStyle(
                //color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (percent < 0.50) ...[
            const SizedBox(height: 2),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: 1 - pow(percent, 0.05).toDouble(),
              child: CustomBottomDescription(
                data: data,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
