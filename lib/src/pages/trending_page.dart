import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_dope/src/localizations.dart';
import 'package:wallpaper_dope/src/pages/selected_page.dart';
import 'package:wallpaper_dope/src/providers/trending_provider.dart';

class TrendingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrendingProvider>(context);
    provider.searchTrendy();

    return StreamBuilder(
        stream: provider.pageStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final image = snapshot.data;
          final _gridController = new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.65);
          final _controller = new PageController(initialPage: 1);
          _controller.addListener(() {
            if (_controller.position.pixels >=
                  _controller.position.maxScrollExtent -200) {
                return provider.searchTrendy();
              }
           });

          return Padding(
            padding: const EdgeInsets.all(15),
            child: GridView.builder(
              controller: _controller,
              gridDelegate: _gridController,
              itemCount: provider.page.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectedWallpaper(
                          lowResImage: image[index].src.medium,
                          image: image[index].src.original,
                          isFromUploadsPage: false,
                        ),
                      ),
                      (Route<dynamic> route) => true,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(3, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return LiquidCircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                              valueColor:
                                  AlwaysStoppedAnimation(Color(0xFF6A040F)),
                              backgroundColor: Color(0xFF006E),
                              borderColor: Color(0xFB5607),
                              borderWidth: 5.0,
                              direction: Axis.vertical,
                              center: Text(
                                AppLocalizations.of(context).translate('loading'),
                                style: GoogleFonts.ptSans(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          },
                          image: NetworkImage(image[index].src.medium)),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
