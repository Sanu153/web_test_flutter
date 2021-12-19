//
//Future<void> _onDownLoadPdf() async {
//  //Create a PDF document.
//  final PdfDocument document = PdfDocument();
//  //Add page to the PDF
//  final PdfPage page = document.pages.add();
//  //Get page client size
//  final Size pageSize = page.getClientSize();
//  //Draw rectangle
//  page.graphics.drawRectangle(
//      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
//      pen: PdfPen(PdfColor(40, 51, 68, 255)));
//  //Generate PDF grid.
//  final PdfGrid grid = getGrid();
//  //Draw the header section by creating text element
//  final PdfLayoutResult result = drawHeader(page, pageSize, grid);
//  //Draw grid
//  drawGrid(page, grid, result);
//  //Add invoice footer
//  drawFooter(page, pageSize);
//  //Save and launch the document
//  final List<int> bytes = document.save();
//  //Dispose the document.
//  document.dispose();
//  //Get the storage folder location using path_provider package.
//  final Directory directory = await getApplicationDocumentsDirectory();
//  final String path = directory.path;
//
//  final String filePath =
//      "$path/${CoreSettings.appName}_Schedule_Order_Number_${widget.orderDetail.id}.pdf";
//
//  final File file = File(filePath);
//  file.writeAsBytes(bytes);
//  //Launch the file (used open_file package)
//  OpenFile.open(filePath);
//}
//
////Draws the invoice header
//PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
//  //Draw rectangle
//  page.graphics.drawRectangle(
//      brush: PdfSolidBrush(PdfColor(23, 30, 50, 100)),
//      bounds: Rect.fromLTWH(0, 0, pageSize.width, 90));
//  //Draw string
//  page.graphics.drawString('${CoreSettings.appName} Order Schedule',
//      PdfStandardFont(PdfFontFamily.helvetica, 30),
//      brush: PdfBrushes.white,
//      bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
//      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
//
//  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
//
//  //Create data foramt and convert it to text.
//  final DateFormat format = DateFormat.yMMMMd();
//  final String invoiceNumber =
//      'Order Number: ${widget.orderDetail.id}\r\n\r\nDate: ' +
//          format
//              .format(DateTime.parse("${widget.lastNegotiation.createdAt}"));
//  final Size contentSize = contentFont.measureString(invoiceNumber);
//
//  final String buyer =
//      "${widget.buySell == 'Buy' ? _order.requestedUser : _order.respondedUser}";
//  final String seller =
//      "${widget.buySell == 'Sell' ? _order.requestedUser : _order.respondedUser}";
//  final String productName = "${_order.dispName}";
//  final String productSpecName = "${_order.productSpecName}";
//  final String status = "${_order.status}";
//  final String price = _order.pricePerUnit.toString();
//  final String delivery = _order.deliveryInDays.toString();
//  final String payment = _order.paymentsInDays.toString();
//  final String quantity = _order.quantity.toString();
//  final String tradeUnit = widget.tradeUnit.toString();
//
//  final String address =
//      'Order Details: \r\n\r\nBuyer: $buyer\r\n\r\nSeller: $seller\r\n\r\nProduct Name: $productName \r\n\r\nProduct Spec Name: $productSpecName \r\n\r\nStatus: $status ';
//
//  PdfTextElement(text: invoiceNumber, font: contentFont).draw(
//      page: page,
//      bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
//          contentSize.width + 30, pageSize.height - 120));
//
//  String order =
//      "Price Per Unit: $price\r\n\r\nPayment (in day): $payment \r\n\r\nDelivery (in day): $delivery \r\n\r\nQuantity (in $tradeUnit): $quantity";
//
//  PdfTextElement(text: address, font: contentFont).draw(
//      page: page,
//      bounds: Rect.fromLTWH(30, 120,
//          pageSize.width - (contentSize.width + 30), pageSize.height - 120));
//  return PdfTextElement(text: order, font: contentFont).draw(
//      page: page,
//      bounds: Rect.fromLTWH(30, 250,
//          pageSize.width - (contentSize.width + 30), pageSize.height - 120));
//}
//
////Draws the grid
//void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
//  Rect totalPriceCellBounds;
//  Rect quantityCellBounds;
//  //Invoke the beginCellLayout event.
//  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
//    final PdfGrid grid = sender as PdfGrid;
//    if (args.cellIndex == grid.columns.count - 1) {
//      totalPriceCellBounds = args.bounds;
//    } else if (args.cellIndex == grid.columns.count - 2) {
//      quantityCellBounds = args.bounds;
//    }
//  };
//  //Draw the PDF grid and get the result.
//  result = grid.draw(
//      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));
//
//  //Draw grand total.
////    page.graphics.drawString('Grand Total',
////        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
////        bounds: Rect.fromLTWH(
////            quantityCellBounds.left,
////            result.bounds.bottom + 10,
////            quantityCellBounds.width,
////            quantityCellBounds.height));
////    page.graphics.drawString(getTotalAmount(grid).toString(),
////        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
////        bounds: Rect.fromLTWH(
////            totalPriceCellBounds.left,
////            result.bounds.bottom + 10,
////            totalPriceCellBounds.width,
////            totalPriceCellBounds.height));
//}
//
////Draw the invoice footer data.
//void drawFooter(PdfPage page, Size pageSize) {
//  final PdfPen linePen =
//  PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
//  linePen.dashPattern = <double>[3, 3];
//  //Draw line
//  page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
//      Offset(pageSize.width, pageSize.height - 100));
//
//  const String footerContent =
//      'A-318 Saheed Nagar.\r\n\r\nAny Questions? info@evosolutions.com';
//
//  //Added 30 as a margin for the layout
//  page.graphics.drawString(
//      footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
//      format: PdfStringFormat(alignment: PdfTextAlignment.right),
//      bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
//}
//
////Create PDF grid and return
//PdfGrid getGrid() {
//  //Create a PDF grid
//  final PdfGrid grid = PdfGrid();
//  //Secify the columns count to the grid.
//  grid.columns.add(count: 5);
//  //Create the header row of the grid.
//  final PdfGridRow headerRow = grid.headers.add(1)[0];
//  //Set style
//  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(14, 44, 124));
//  headerRow.style.textBrush = PdfBrushes.white;
//  headerRow.cells[0].value = 'Schedule Id';
//  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
//  headerRow.cells[1].value = 'Day';
//  headerRow.cells[2].value = 'Date';
//  headerRow.cells[3].value = 'Payment';
//  headerRow.cells[4].value = 'Delivery';
//  //Add rows
//  int _index = 1;
//  _order.schedule.forEach((Schedule schedule) {
//    addProducts(
//        "${schedule.id}",
//        'Day $_index',
//        "${DateFormat.yMMMMd().format(DateTime.parse(schedule.date))}",
//        "${schedule.payment ?? '0'} (${schedule.paymentPercentage ?? '0'}%)",
//        "${schedule.delivery ?? '0'} (${schedule.deliveryPercentage ?? '0'}%)",
//        grid);
//    _index++;
//  });
//
//  //Apply the table built-in style
//  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
//  //Set gird columns width
//  for (int i = 0; i < headerRow.cells.count; i++) {
//    headerRow.cells[i].style.cellPadding =
//        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
//  }
//  for (int i = 0; i < grid.rows.count; i++) {
//    final PdfGridRow row = grid.rows[i];
//    for (int j = 0; j < row.cells.count; j++) {
//      final PdfGridCell cell = row.cells[j];
//      if (j == 0) {
//        cell.stringFormat.alignment = PdfTextAlignment.center;
//      }
//      cell.style.cellPadding =
//          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
//    }
//  }
//  return grid;
//}
//
////Create and row for the grid.
//void addProducts(String sId, String day, String date, String payment,
//    String quantity, PdfGrid grid) {
//  final PdfGridRow row = grid.rows.add();
//  row.cells[0].value = sId;
//  row.cells[1].value = day;
//  row.cells[2].value = date;
//  row.cells[3].value = payment;
//  row.cells[4].value = quantity;
//}
//
////Get the total amount.
//double getTotalAmount(PdfGrid grid) {
//  double total = 0;
//  for (int i = 0; i < grid.rows.count; i++) {
//    final String value = _order.schedule[i].payment;
//    total += double.parse(value);
//  }
//  return total;
//}
//}
