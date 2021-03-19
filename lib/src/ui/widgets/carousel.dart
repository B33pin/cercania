import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  List<Image> images;

  Carousel(this.images);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> with SingleTickerProviderStateMixin {
  int _currentPage = 1;
  PageController _controller =  PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider());
  }

  void _animateSlider() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      if(this.mounted){
        int nextPage = _controller.page.round() + 1;

        if (nextPage == this.widget.images.length) {
          nextPage = 0;
        }
        _controller
            .animateToPage(nextPage, duration: Duration(seconds: 1), curve: Curves.easeIn)
            .then((_) => _animateSlider());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      child:
      Stack(children: [
        PageView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          itemCount: this.widget.images.length,

          onPageChanged: (page) => setState(() => this._currentPage = page +1),

          itemBuilder: (context, index) => ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: this.widget.images[index],
          ),
        ),

        Positioned(bottom: 10, right: 10, child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.45),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              child: Text(_currentPage.toString() + "  /  " + this.widget.images.length.toString(), style: TextStyle(
                color: Colors.white
              ),),
            )))
      ])
    );
  }
}
