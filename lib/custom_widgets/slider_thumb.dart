import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({Key key}) : super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  ui.Image customImage;
  double sliderValue = 0.0;

  Future<ui.Image> loadImage(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: 25, targetWidth: 25);
    ui.FrameInfo fi = await codec.getNextFrame();

    return fi.image;
  }

  final databaseReference = FirebaseDatabase.instance.reference();
  double lampBrightness = 0.0;
  void setData(String id, String cmd, String cmdValue) {
    databaseReference.child(id).update({cmd: cmdValue}).asStream();
    print("$cmd  $cmdValue");
  }

  Future<ui.Image> _loadImage;
  @override
  void initState() {
    super.initState();
    _loadImage = loadImage("assets/images/full_moon.png");
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              widthFactor: 4,
              child: Text(
                "${lampBrightness}%",
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
            FutureBuilder<ui.Image>(
                future: _loadImage,
                builder: (context, snapshot) {
                  if (snapshot.hasData || snapshot.data != null) {
                    return SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 8,
                        inactiveTrackColor: Colors.grey.shade300,
                        activeTrackColor: const Color(0xFFFFE900),
                        thumbShape: SliderThumbImage(snapshot.data),
                      ),
                      child: Slider(
                        value: sliderValue,
                        min: 0,
                        max: 100,
                        onChanged: (value) {
                          setState(() {
                            lampBrightness =
                                double.parse(value.toStringAsFixed(0));
                          });
                          setData("123", "lampBrightness", "${lampBrightness}");

                          setState(() {
                            sliderValue = value;
                            value < 25
                                ? _loadImage =
                                    loadImage("assets/images/full_moon.png")
                                : value < 50
                                    ? _loadImage =
                                        loadImage("assets/images/full_moon.png")
                                    : value < 75
                                        ? _loadImage = loadImage(
                                            "assets/images/half_sun.png")
                                        : _loadImage =
                                            loadImage("assets/images/sun.png");
                          });
                          print(value);
                        },
                      ),
                    );
                  }
                  // progress indicator while loading image,
                  // you can return and empty Container etc. if you like
                  return CircularProgressIndicator();
                }),
          ],
        ));
  }
}

class SliderThumbImage extends SliderComponentShape {
  final ui.Image image;

  SliderThumbImage(this.image);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(0, 0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {@required Animation<double> activationAnimation,
      @required Animation<double> enableAnimation,
      @required bool isDiscrete,
      @required TextPainter labelPainter,
      @required RenderBox parentBox,
      @required SliderThemeData sliderTheme,
      @required TextDirection textDirection,
      @required double value,
      @required double textScaleFactor,
      @required Size sizeWithOverflow}) {
    final canvas = context.canvas;
    final imageWidth = image.width;
    final imageHeight = image.height;

    Offset imageOffset = Offset(
      center.dx - (imageWidth / 2),
      center.dy - (imageHeight / 2),
    );

    Paint paint = Paint()..filterQuality = FilterQuality.high;

    canvas.drawImage(image, imageOffset, paint);
  }
}
