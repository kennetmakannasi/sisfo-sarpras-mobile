import 'package:flutter/material.dart';
import '../models/item.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onBorrow;

  const ItemCard({super.key, required this.item, required this.onBorrow});

  @override
  Widget build(BuildContext context) {

  final imageUrl = item.imageUrl?.isNotEmpty == true
  ? item.imageUrl!
  : 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/800px-Placeholder_view_vector.svg.png';

 return SizedBox(
  width: 180, // atur lebar tetap agar Wrap bisa mengatur grid
  child: Card(
    color: Colors.white,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name.length <= 14
                    ? item.name
                    : '${item.name.substring(0, 11)}...',
                style: GoogleFonts.inter(
                 textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),  
                )
               
              ),
              Text('Stok: ${item.stock.toString()}',
                style: GoogleFonts.inter(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: onBorrow,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Pinjam',
                    style: GoogleFonts.inter(),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        )
      ],
    ),
  ),
);


  }
}
