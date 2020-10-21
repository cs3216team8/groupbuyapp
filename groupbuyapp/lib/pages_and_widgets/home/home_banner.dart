import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeCarouselBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      child: CarouselSlider(
          items: [
            Image.network("https://pbs.twimg.com/media/D-jnKUPU4AE3hVR?format=jpg&name=large"),
            Image.network("https://pbs.twimg.com/media/D-jnNTvUEAAGLvE?format=jpg&name=large"),
            Image.network("https://pbs.twimg.com/media/D-jnUF5UIAEA6Cl?format=jpg&name=large"),
            Image.network("https://pbs.twimg.com/media/D-jnXCiU0AASd7-?format=jpg&name=large"),
          ],
          options: CarouselOptions(
            height: 120,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            enlargeCenterPage: false,
          )
      ),
    );
  }
}
