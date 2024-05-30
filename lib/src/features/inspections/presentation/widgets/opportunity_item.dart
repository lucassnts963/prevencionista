import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/usecases/delete_opportunity_usecase.dart';
import 'package:prevencionista/src/features/inspections/presentation/pages/opportunity_screen.dart';
import 'package:prevencionista/src/shared/domain/usecases/share_image_usecase.dart';

class OpportunityItem extends StatelessWidget {
  const OpportunityItem(
      {super.key, required this.opportunity, required this.index});

  final Opportunity opportunity;
  final int index;

  @override
  Widget build(BuildContext context) {
    String beforePath = opportunity.imagePathBefore;

    return MaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OpportunityScreen(
                  opportunity: opportunity,
                  index: index,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          children: [
            Image.file(
              File(beforePath),
              width: 48.0,
              height: 48.0,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${index + 1} - ❌ ${opportunity.description}'),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        DeleteOpportunityUseCase.execute(opportunity.id);
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ShareImageUseCase.execute(opportunity.build(index), beforePath);
                      },
                      icon: const Icon(
                        Icons.share,
                        color: Colors.green,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
