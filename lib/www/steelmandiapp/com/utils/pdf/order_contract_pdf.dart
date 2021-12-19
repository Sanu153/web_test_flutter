import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/order.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/schedule.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/directory/open_file.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/directory/path_provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/notification/notification_manager.dart';

class ContractPDF {
  pw.Document _document;
  final Order order;
  final NotificationManager notificationManager;

  List<List<String>> _scheduleDataSet;

  ContractPDF({this.order, this.notificationManager}) : assert(order != null) {
    _document = pw.Document();
    _scheduleDataSet = List<List<String>>();
    _buildSchedule();
  }

  void _buildSchedule() {
    int _count = 0;
    final header = <String>[
      'Day',
      'Date',
      'Quantity (in ${order.tradeUnit.shortName})',
      'Payment (in INR)'
    ];
    _scheduleDataSet.add(header);
    order.schedule.forEach((Schedule schedule) {
      final List<String> _row = List<String>();

      _row.add("Day ${_count + 1}");
      _row.add("${schedule.date}");
      _row.add("${schedule.delivery}");
      _row.add("${schedule.payment}");

      _scheduleDataSet.add(_row);

      _count++;
    });
  }

  pw.Widget _buildBuyerSellerInfo(
      pw.Context context, String type, UserModel tradeUser) {
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
                      pw.Row(children: <pw.Widget>[
                        pw.Text("Official Name: ",
                            style: pw.TextStyle(
                                fontSize: 12.0,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Flexible(child: pw.Text("${tradeUser.name ?? ''}"))
                      ]),
                      pw.Row(children: <pw.Widget>[
                        pw.Text("Address: ",
                            style: pw.TextStyle(
                                fontSize: 12.0,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Flexible(
                            child: pw.Text("${tradeUser.address ?? ''}"))
                      ]),
                      pw.Row(children: <pw.Widget>[
                        pw.Text("Email: ",
                            style: pw.TextStyle(
                                fontSize: 12.0,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Flexible(child: pw.Text("${tradeUser.email ?? ''}"))
                      ]),
                      pw.Row(children: <pw.Widget>[
                        pw.Text("Contact No.: ",
                            style: pw.TextStyle(
                                fontSize: 12.0,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Flexible(
                            child: pw.Text("${tradeUser.mobileNo ?? ''}"))
                      ])
                    ]),
              ),
              pw.SizedBox(height: 5)
            ]));
  }

  pw.Widget _buildOrderDetails(pw.Context context) {
    return pw.Container(
        margin: pw.EdgeInsets.only(left: 12.0),
        child: pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: <
                pw.Widget>[
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text("1."),
            pw.SizedBox(width: 8.0),
            pw.Flexible(
              child: pw.Text(
                  "Agreement to sale and purchase: The seller agrees to sell, and the buyer agrees to buy the product described as follows."),
            )
          ]),
          pw.Container(
              margin: pw.EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Text("a.	Product Name: ${order.productName}"),
                    pw.Text("b.	Product Spec Name: ${order.productSpecName}"),
                    pw.Text("c.	Market: ${order.marketName}"),
                    pw.Text("d.	Price (INR): ${order.pricePerUnit}"),
                    pw.Text(
                        "e.	Quantity (in ${order.tradeUnit.shortName}): ${order.quantity}"),
                    pw.Text("f.	Payment (in days): ${order.paymentsInDays}"),
                    pw.Text("g.	Delivery (in days): ${order.deliveryInDays}"),
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
                    cellAlignment: pw.Alignment.center,
                    context: context,
                    data: _scheduleDataSet),
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

  Future<String> createPdf() async {
    final _fileName = "${CoreSettings.appName}_Contract_No_${order.id}";
    final String _path =
        '${await PathProvider.getExternalDocumentPath()}/${_fileName}.pdf';

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
                        "This contract is being signed by and between ${order.buyer.name} (buyer) and ${order.seller.name} (seller)."),
                pw.Paragraph(
                    text:
                        "This contract has been made effective as on ${order.contract.effectiveDate} and shall remain into effect till ${order.contract.terminationDate}."),
                pw.SizedBox(height: 20.0),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: <pw.Widget>[
                      pw.Expanded(
                          child: _buildBuyerSellerInfo(
                              context, "Seller", order.seller)),
                      pw.Expanded(
                          child: _buildBuyerSellerInfo(
                              context, "Buyer", order.buyer))
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

      final file = File(_path);
      file.writeAsBytesSync(_document.save());

      notificationManager.localNotification.showNotificationWithDeafultSound(
          id: order.id,
          title: '$_fileName Downloaded',
          body: "File saved in $_path");
      SMOpenFile.open(_path);
    } catch (e) {
      print("Error Caught In Generating PDF: ${e.toString()}");
      return null;
    }
    return _path;
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
