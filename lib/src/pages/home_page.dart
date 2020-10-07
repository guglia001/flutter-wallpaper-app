import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_dope/src/localizations.dart';
import 'package:wallpaper_dope/src/pages/selected_page.dart';
import 'package:wallpaper_dope/src/providers/home_providers.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final search = Provider.of<HomeProviderUnsplash>(context);
    search.searchHype();
    search.searchMoney();
    search.searchShoes();
    search.searchSnaps();

    return ListView(children: <Widget>[
      HomeBuilder(
          category: "Hype",
          provider: search.hypeStream,
          siguientePagina: search.searchHype),
      HomeBuilder(
          category: "Shoes",
          provider: search.shoesStream,
          siguientePagina: search.searchShoes),
      HomeBuilder(
          category: "Snaps",
          provider: search.snapStream,
          siguientePagina: search.searchSnaps),
      HomeBuilder(
          category: "Billionaire",
          provider: search.moneyStream,
          siguientePagina: search.searchMoney),
      SizedBox(height: 50)
    ]);
  }
}

class HomeBuilder extends StatelessWidget {
  const HomeBuilder({this.category, this.provider, this.siguientePagina});

  final String category;
  final Stream provider;
  final Function siguientePagina;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              category,
              style: GoogleFonts.ptSans(
                color: Colors.black.withOpacity(0.9),
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        StreamBuilder(
          stream: provider,
          builder: (context, snapshot) {
            final _pageController =
                new PageController(initialPage: 1, viewportFraction: 0.3);
            _pageController.addListener(() {
              if (_pageController.position.pixels >=
                  _pageController.position.maxScrollExtent) {
                print("cargando");
                return siguientePagina();
              }
            });
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ThemeData.dark().colorScheme.primary)));
            }
            final imagen = snapshot.data;
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 150,
                width: double.infinity,
                child: ListView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: imagen.length,
                    padding: EdgeInsets.all(10),
                    itemBuilder: (context, index) => Row(
                          children: <Widget>[
                            InkWell(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectedWallpaper(
                                              lowResImage:
                                                  imagen[index].urls.small,
                                              image: imagen[index].urls.full,
                                              isFromUploadsPage: false,
                                              // scans
                                              //     .results[index].urls.full,
                                            )),
                                    (Route<dynamic> route) => true,
                                  );
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return LiquidCircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                            valueColor: AlwaysStoppedAnimation(
                                                ThemeData.dark().colorScheme.primary),
                                            backgroundColor: Color(0xFF006E),
                                            borderColor: Color(0xFB5607),
                                            borderWidth: 5.0,
                                            direction: Axis.vertical,
                                            center: Text(
                                              AppLocalizations.of(context).translate('loading'),
                                              style: GoogleFonts.ptSans(
                                                color: Colors.white
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          );
                                        },
                                        image: CachedNetworkImageProvider(imagen[index].urls.small)))),
                            SizedBox(width: 10)
                          ],
                        )),
              ),
            );
          },
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }
}
