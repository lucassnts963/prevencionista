import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class GeneratePDFUseCase {
  static execute(Inspection inspection) async {
    final pdf = Document();
    final emoji = await PdfGoogleFonts.notoColorEmoji();

    String message = await rootBundle.loadString('assets/report_model.txt');

    List<Opportunity> opportunities = inspection.opportunities;

    const quantityByPage = 4;

    final numPages = (opportunities.length / quantityByPage).round();
    print('numPages: $numPages');

    message = message.replaceAll("#date", inspection.date);
    message = message.replaceAll("#name", inspection.name);
    message = message.replaceAll("- ", "\n");

    var count = 0;

    for (int i = 0; i < numPages; i++) {
      List<Widget> body = [];

      if (count == 0) {
        body.add(Row(children: [
          Expanded(
            child: Text(message,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    fontFallback: [emoji])),
          ),
        ]));
        body.add(SizedBox(height: 8.0));
      }

      const length = quantityByPage;

      for (int i = 0; i < length; i++) {
        if (count < opportunities.length) {
          final path = opportunities[count].pictureReport ??
              opportunities[count].imagePathBefore;
          final description = opportunities[count].description;
          final local = opportunities[count].local;
          final status = opportunities[count].status;
          final action = opportunities[count].action;

          body.add(Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Image(
                  MemoryImage(File(path).readAsBytesSync()),
                  width: 130,
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                flex: 2,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${count + 1} - ❌ $description',
                        style: TextStyle(
                          fontFallback: [emoji],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 16.0),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Local:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                local,
                                style: TextStyle(
                                  fontFallback: [emoji],
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            )
                          ]),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontFallback: [emoji],
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            )
                          ]),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ação:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                action,
                                style: TextStyle(
                                  fontFallback: [emoji],
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            )
                          ]),
                    ]),
              ),
              SizedBox(
                height: 16.0,
              ),
            ],
          ));
          count++;
        }
      }

      pdf.addPage(
        Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: body,
              );
            }),
      );
    }

    final tempDirectory = await getTemporaryDirectory();
    final path =
        join(tempDirectory.path, '${inspection.date.replaceAll('/', '-')}.pdf');
    final file = File(path);
    file.writeAsBytesSync(await pdf.save());

    // Share.shareXFiles([XFile(path)]);
    
  }
}
