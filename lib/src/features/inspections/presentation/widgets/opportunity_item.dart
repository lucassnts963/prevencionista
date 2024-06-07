import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/presentation/screens/opportunity/opportunity_screen.dart';
import 'package:prevencionista/src/shared/domain/usecases/share_image_usecase.dart';

class OpportunityItem extends StatelessWidget {
  const OpportunityItem({
    super.key,
    required this.opportunity,
    required this.index,
    required this.onClosed,
    required this.inspection,
  });

  final Opportunity opportunity;
  final int index;
  final Function onClosed;
  final Inspection inspection;

  @override
  Widget build(BuildContext context) {
    String? imagePathReport = opportunity.pictureReport;

    return MaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OpportunityScreen(
                      index: index,
                      opportunity: opportunity,
                    ))).then((value) => onClosed());
      },
      child: Column(
        children: [
          const SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              Image.file(
                File(opportunity.imagePathBefore),
                width: 48.0,
                height: 48.0,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1} - ❌ ${opportunity.description}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 24.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Local:',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(opportunity.local)
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Ação:',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(opportunity.action)
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Status:',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(opportunity.status)
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                    imagePathReport != null
                        ? IconButton(
                            onPressed: () {
                              ShareImageUseCase.execute(
                                  opportunity.build(index), imagePathReport);
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Colors.green,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 1.0,
            child: Container(
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
