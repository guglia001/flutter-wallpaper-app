import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_dope/src/providers/uploads_provider.dart';

class LikeBoton extends StatelessWidget {
  final likes;
  final documentId;

  const LikeBoton({Key key, this.likes, this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadsProvider>(context);
    provider.likes = likes;

    return LikeButton(
        size: 28,
        circleColor: CircleColor(start: Colors.white, end: Colors.redAccent),
        bubblesColor: BubblesColor(
          dotPrimaryColor: Color(0xFF03071E),
          dotSecondaryColor: Color(0xff9D0208),
        ),
        onTap: provider.like(documentId),
        likeBuilder: (bool isLiked) {
          return Icon(
            AntDesign.heart,
            color: isLiked ? Colors.red : Colors.white,
            size: 28,
          );
        },
        likeCount: likes,
        countBuilder: (int count, bool isLiked, String text) {
          var color = isLiked ? Colors.red : Colors.white;
          Widget result;
          if (count == 0) {
            result = Text("   0",
                style: GoogleFonts.roboto(
                    color: color, fontSize: 12, fontWeight: FontWeight.bold));
          } else
            result = Text("   $text",
                style: GoogleFonts.roboto(
                    color: color, fontSize: 12, fontWeight: FontWeight.bold));
          return result;
        });
  }
}
