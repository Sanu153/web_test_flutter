import 'dart:io';
import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/directory/path_provider.dart';

class TestPDFTemplate {
  final pw.Document _document = pw.Document();

  Future<PdfImage> _getPdfImage() async {
    final PdfImage assetImage = await pdfImageFromImageProvider(
      pdf: _document.document,
      image: AssetImage('assets/image/SM_logo.png'),
    );
    return assetImage;
  }

  pw.Widget _getLogo(pw.Context context) {
    _getPdfImage().then((PdfImage image) {
      return pw.Container(
          margin: pw.EdgeInsets.symmetric(vertical: 12.0),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Image(image, width: 150.0, height: 80.0),
                pw.SizedBox(height: 25.0),
                pw.Text("${CoreSettings.appName}", textScaleFactor: 2)
              ]));
    });
  }

  List<pw.Widget> _buildPages(pw.Context context) {
    return <pw.Widget>[];
  }

  pw.Widget _buildBuyerSellerInfo(pw.Context context, String type) {
    return pw.Container(
        decoration: pw.BoxDecoration(
            border: pw.BoxBorder(
          width: 1.0,
          color: PdfColors.black,
          top: true,
          bottom: true,
          left: true,
          right: true,
        )),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Container(
                  alignment: pw.Alignment.center,
                  padding: pw.EdgeInsets.only(top: 5.0),
                  child: pw.Text("Details of $type",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 12.0, fontWeight: pw.FontWeight.bold))),
              pw.Divider(color: PdfColors.black, thickness: 1),
              pw.Container(
                padding: pw.EdgeInsets.symmetric(horizontal: 5),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Text("Official Name: ",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Address: ",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Email: ",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Contact No.: ",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold)),
                    ]),
              ),
              pw.SizedBox(height: 5)
            ]));
  }

  pw.Widget _buildOrderDetails(pw.Context context) {
    return pw.Container(
        margin: pw.EdgeInsets.only(left: 12.0),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("1."),
                    pw.SizedBox(width: 8.0),
                    pw.Flexible(
                      child: pw.Text(
                          "Agreement to sale and purchase: The seller agrees to sell, and the buyer agrees to buy the product described as follows."),
                    )
                  ]),
              pw.Container(
                  margin:
                      pw.EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: <pw.Widget>[
                        pw.Text("a.	Product Spec Name:"),
                        pw.Text("b.	Market:"),
                        pw.Text("c.	Price:"),
                        pw.Text("d.	Quantity:"),
                        pw.Text("e.	Payment (in days):"),
                        pw.Text("f.	Delivery (in days):"),
                      ])),
            ]));
  }

  pw.Widget _buildOrderSchedules(pw.Context context) {
    return pw.Container(
        margin: pw.EdgeInsets.only(left: 12.0),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("2."),
                    pw.SizedBox(width: 8.0),
                    pw.Text("The schedule is described as follows."),
                  ]),
              pw.Container(
                margin:
                    pw.EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: pw.Table.fromTextArray(
                    context: context,
                    data: const <List<String>>[
                      <String>[
                        'Day',
                        'Date',
                        'Quantity',
                        'Payment',
                        'Delivery'
                      ],
                      <String>['Day 1', '25-07-2020', '50T', '85300', '30T'],
                      <String>['Day 2', '26-07-2020', '40T', '45222', '60T'],
                      <String>['Day 3', '27-07-2020', '60T', '21221', '60T'],
                      <String>['Day 4', '28-07-2020', '20T', '10000', '20T'],
                      <String>['Day 5', '29-07-2020', '55T', '55662', '55T'],
                      <String>['Day 6', '30-07-2020', '70T', '70000', '70T'],
                    ]),
              ),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
            ]));
  }

  pw.Widget _buildBuyerSellerSignature(pw.Context context, String type) {
    return pw.Container(
        alignment: pw.Alignment.center,
        padding: pw.EdgeInsets.all(8.0),
        height: 70.0,
        decoration: pw.BoxDecoration(
            border: pw.BoxBorder(
          width: 1.0,
          color: PdfColors.black,
          top: true,
          bottom: true,
          left: true,
          right: true,
        )),
        child: pw.Container(
            width: 120.0,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: <pw.Widget>[
                  pw.Divider(color: PdfColors.grey, thickness: 1),
                  pw.SizedBox(height: 5),
                  pw.Text("$type",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 12.0, fontWeight: pw.FontWeight.normal)),
                ])));
  }

  void createPdf() async {
    try {
      final PdfImage assetImage = await pdfImageFromImageProvider(
        pdf: _document.document,
        image: AssetImage('assets/image/SM_logo.png'),
      );

      final pw.MultiPage _multiPage = pw.MultiPage(
          header: _getHeader,
          footer: _getFooter,
          build: (pw.Context context) => <pw.Widget>[
                pw.Header(
                    level: 0,
                    child: pw.Container(
                        alignment: pw.Alignment.center,
                        margin: pw.EdgeInsets.symmetric(
                            vertical: 1.0 * PdfPageFormat.cm),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: <pw.Widget>[
                              pw.Image(assetImage, width: 150.0, height: 80.0),
                              pw.SizedBox(height: 12.0),
                              pw.Text("${CoreSettings.appName}",
                                  style: pw.TextStyle(color: PdfColors.grey),
                                  textScaleFactor: 2)
                            ]))),
                pw.SizedBox(height: 12.0),
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text("Contract of Agreement",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 28.0, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 20.0),
                pw.Paragraph(
                    text:
                        "This contract is being signed by and between Mrutyunjaya Giri (buyer) and Debi Naik (seller)."),
                pw.Paragraph(
                    text:
                        "This contract has been made effective as on 25-07-2020 and shall remain into effect till 30-07-2020."),
                pw.SizedBox(height: 20.0),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: <pw.Widget>[
                      pw.Expanded(
                          child: _buildBuyerSellerInfo(context, "Seller")),
                      pw.Expanded(
                          child: _buildBuyerSellerInfo(context, "Buyer"))
                    ]),
                pw.SizedBox(height: 20.0),
                pw.Text("Terms and Conditions: ",
                    style: pw.TextStyle(
                        decoration: pw.TextDecoration.underline,
                        fontSize: 12.0,
                        fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 16.0),
                _buildOrderDetails(context),
                pw.SizedBox(height: 16.0),
                _buildOrderSchedules(context),
                pw.SizedBox(height: 50.0),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: <pw.Widget>[
                      pw.Expanded(
                          child: _buildBuyerSellerSignature(context, "Seller")),
                      pw.Expanded(
                          child: _buildBuyerSellerSignature(context, "Buyer"))
                    ]),
              ]);

      _document.addPage(_multiPage);

      final _fileName = "Steelmandi PDF Test_${Random().nextInt(15)}";
      final file = File(
          '${await PathProvider.getExternalDocumentPath()}/${_fileName}.pdf');
      file.writeAsBytesSync(_document.save());
    } catch (e) {
      print("Error Caught In Generating PDF: ${e.toString()}");
    }
  }

  pw.Widget _getHeader(pw.Context context) {
    if (context.pageNumber == 1) {
      return null;
    }
    return pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
        padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
        decoration: const pw.BoxDecoration(
            border:
                pw.BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
        child: pw.Text('${CoreSettings.appName} Contract ',
            style: pw.Theme.of(context)
                .defaultTextStyle
                .copyWith(color: PdfColors.grey)));
  }

  pw.Widget _getFooter(pw.Context context) {
    return pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
        child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.Theme.of(context)
                .defaultTextStyle
                .copyWith(color: PdfColors.grey)));
  }
}
