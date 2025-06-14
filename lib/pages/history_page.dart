import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/borrow_history.dart';
import 'package:another_flushbar/flushbar.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<BorrowHistory> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() async {
    final response = await ApiService.fetchBorrowHistory();
    setState(() {
      history = response.map<BorrowHistory>((h) => BorrowHistory.fromJson(h)).toList();
    });
  }

  void returnDialog(BorrowHistory item) {
  final qtyCtrl = TextEditingController();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Return ${item.item.name}',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Returning Quantity',
                    style: GoogleFonts.inter(),
                  ),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: qtyCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Quantity',
                      filled: true,
                      fillColor: Color(0xffebf2f7),
                      hintStyle: GoogleFonts.inter(
                        textStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () async {
                        await ApiService.returnItem(item.id, int.parse(qtyCtrl.text));
                        Navigator.pop(context);
                        loadHistory();

                         Flushbar(
                        message: "Returning Request Sended",
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.white,
                        flushbarPosition: FlushbarPosition.TOP,
                        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        borderRadius: BorderRadius.circular(12),
                        padding: EdgeInsets.all(16),
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        messageColor: Colors.black,
                        forwardAnimationCurve: Curves.easeOut,
                        reverseAnimationCurve: Curves.easeIn,
                        boxShadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                        animationDuration: Duration(milliseconds: 300),
                      ).show(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF60a5fa),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Return'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        ),
      );
    },
  );
}



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Borrowing History',
        style: GoogleFonts.inter(),
      ),
      backgroundColor: Colors.white,
    ),
    body: history.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inventory_2, size: 80, color: Colors.grey[400]),
                SizedBox(height: 20),
                Text(
                  'No items',
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: history.length,
            itemBuilder: (_, index) {
              final item = history[index];
              final imageUrl = item.item.imageUrl?.isNotEmpty == true
                  ? item.item.imageUrl!
                  : 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/800px-Placeholder_view_vector.svg.png';

              return Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              item.item.name.length <= 15
                                  ? Text(
                                      item.item.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      '${item.item.name.substring(0, 12)}...',
                                      style: GoogleFonts.inter(),
                                    ),
                              SizedBox(height: 8),
                              Text(
                                'Quantity: ${item.quantity}',
                                style: GoogleFonts.inter(),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: getStatusColor(item.status).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    item.status == 'approved'? 'Approved' :
                                    item.status == 'rejected'? 'Rejected':
                                    item.status == 'returned'? 'Returned':
                                    'Pending',
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        color: getStatusColor(item.status),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              if (item.status.toLowerCase() == 'approved')
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xFF60a5fa),
                                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () => returnDialog(item),
                                  child: Text(
                                    'Return',
                                    style: GoogleFonts.inter(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
  );
}


Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return const Color(0xFFeab308);
    case 'approved':
      return Color(0xFF22c55e);
    case 'rejected':
      return Color(0xFFef4444);
    case 'returned':
      return Color(0xFF1d4ed8);
    default:
      return Colors.black;
  }
}

}
