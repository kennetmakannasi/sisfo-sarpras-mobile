import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/item.dart';
import '../widgets/item_card.dart';
import 'package:flutter/services.dart';
import 'package:another_flushbar/flushbar.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> items = [];
  List categories = [];
  String? selectedCategory; 

  @override
  void initState() {
    super.initState();
     loadCategories();
    loadItems();
  }

  void loadCategories() async {
    final response = await ApiService.fetchCategories();
    setState(() {
      categories = response;
    });
  }

  void loadItems({String? category}) async {
  final response = await ApiService.fetchItems(category: category);
  setState(() {
    items = response.map<Item>((i) => Item.fromJson(i)).toList();
    selectedCategory = category;
  });
}


  void borrowDialog(Item item) {
  final imageUrl = item.imageUrl?.isNotEmpty == true
      ? item.imageUrl!
      : 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/800px-Placeholder_view_vector.svg.png';
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
                      Expanded(
                        child: Text(item.name,
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 320,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Jumlah stok: ${item.stock}',
                    style: GoogleFonts.inter(),
                  ),
                  SizedBox(height: 20),
                  Text('Kuantitas Peminjaman',
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
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12, horizontal: 14),
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
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ApiService.borrowItem(
                            item.sku, int.parse(qtyCtrl.text));
                        Navigator.pop(context);
                        loadItems();
                       Flushbar(
                        message: "Peminjaman berhasil dilakukan.",
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
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Kirim',
                        style: GoogleFonts.inter(),
                      ),
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
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      );
    },
  );
}

 

void logout(BuildContext context) async {
  final shouldLogout = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 150),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), 
            ),
            title: Text('Konfirmasi Logout'),
            content: Text('Apakah kamu yakin ingin keluar?'),
            actions: [
              SizedBox(
                width: 100,
                child:  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, 
                    foregroundColor: Colors.black, 
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Color(0xffd1d5db)), 
                    ),
                    elevation: 0, 
                  ),
                  child: Text('Tidak'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
            
            SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF60a5fa),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Ya, Logout'),
                onPressed: () => Navigator.of(context).pop(true),
              ), 
            )

             
            ],
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      );
    },
  );

  if (shouldLogout == true) {
    await ApiService.logout();
    context.go('/');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang',
        style: GoogleFonts.inter(),
        ),
        actions: [
          IconButton(onPressed: () => context.push('/history'), icon: Icon(Icons.history)),
          IconButton(onPressed:  () => logout(context), icon: Icon(Icons.logout)),
        ],
        backgroundColor: Colors.white,
        elevation: 0, 
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
  child: Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
        padding: const EdgeInsets.only(right: 8),
        child: TextButton(
          onPressed: () => loadItems(),
          style: TextButton.styleFrom(
            backgroundColor: selectedCategory == null ? Color(0xFF60a5fa) : Color(0xffebf2f7),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(
            'Semua',
            style:
            GoogleFonts.inter(
              textStyle: TextStyle(color: selectedCategory == null ? Colors.white : Colors.grey[500]),
          )),
        ),
      ),
              ...categories.map<Widget>((cat) {
                final isSelected = selectedCategory == cat['slug'];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: TextButton(
                    onPressed: () => loadItems(category: cat['slug']),
                    style: TextButton.styleFrom(
                      backgroundColor: isSelected ? Color(0xFF60a5fa) : Color(0xffebf2f7),
                    ),
                    child: Text(cat['name'], 
                    style: GoogleFonts.inter(
                    textStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey[500]))),
                  ),
                );
              }).toList(),
            ],  
          ),
        ),
        SizedBox(height: 10),
        Center(
  child: items.isEmpty
      ? 
      Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2, size: 80, color: Colors.grey[500]),
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
        ),
      )
      : Wrap(
          spacing: 5,
          runSpacing: 5,
          children: items
              .map((item) => ItemCard(
                    item: item,
                    onBorrow: () => borrowDialog(item),
                  ))
              .toList(),
        ),
),

      ],
    ),
  ),
)

      
    );
  }
}
