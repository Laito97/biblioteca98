import 'dart:ui';

import 'package:biblioteca97/views/user_views/librodetalleview/libro_detalle_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class NavegacionCarousel extends StatefulWidget {
  const NavegacionCarousel({super.key});

  @override
  State<NavegacionCarousel> createState() => _NavegacionCarouselState();
}

class _NavegacionCarouselState extends State<NavegacionCarousel> {
  List<String> images = [
    'https://images.cdn3.buscalibre.com/fit-in/360x360/79/54/795443e54c80323b110bd9ca910f5355.jpg',
    'https://everardocuriel.com/wp-content/uploads/2021/02/10200182-1.jpg',
    'https://www.crisol.com.pe/media/catalog/product/cache/f6d2c62455a42b0d712f6c919e880845/9/7/9786124262753_cacldgv9nlzbvcmx.jpg',
    'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1610549639i/56656500.jpg',
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 2, right: 2, top: 7, bottom: 17),
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity, // que ocupe todo el ancho posible
            child: Container(
              padding: EdgeInsets.only(left: 12, right: 10),
              child: Text(
                'Libros en Tendencias',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 255,
            child: CarouselSlider(
              items:
                  images
                      .map(
                        (item) => Material(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LibroDetalleView(libroUrl: item),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(item),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.19),
                                    blurRadius: 20,
                                    spreadRadius: 0,
                                    offset: Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.23),
                                    blurRadius: 6,
                                    spreadRadius: 0,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
              options: CarouselOptions(
                height: 205,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 4),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                enlargeCenterPage: true,
                aspectRatio: 1 / 2,
                viewportFraction: 0.35,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                images
                    .asMap()
                    .entries
                    .map(
                      (item) => Container(
                        height: 6,
                        width: 6,
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              currentIndex == item.key
                                  ? Colors.white
                                  : Colors.grey,
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
