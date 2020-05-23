import 'package:flutter/material.dart';
import 'package:guitar_tabs/colors.dart';
import 'package:guitar_tabs/main.dart';

class TermsPage extends StatefulWidget {
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Terms and conditions",
          style: TextStyle(fontWeight: FontWeight.w100),
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          new Container(
            height: 30.0,
            color: kPrimaryColor,
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: Center(
              child: Container(
                child: Text("Guitar Tabs© 2020",
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(30),
            width: 700,
            child: Column(
              children: <Widget>[
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sit amet viverra dui, quis feugiat risus. Suspendisse accumsan, eros at ornare hendrerit, massa velit semper erat, sit amet luctus leo erat in ligula. Aliquam erat volutpat. Quisque maximus nisi sed condimentum sagittis. In mattis ex aliquam leo scelerisque, nec auctor libero luctus. Nunc faucibus nibh non nulla iaculis, non volutpat mauris tincidunt. Suspendisse elit odio, ultricies in maximus non, ornare sed enim. Cras pharetra tincidunt gravida. Praesent congue commodo laoreet.\n\nAliquam et eros nibh. Quisque tempus, nibh consectetur dignissim laoreet, odio enim blandit velit, quis ornare nibh nunc nec ante. Cras a rhoncus orci, ac sagittis mi. Aenean erat mauris, facilisis consequat varius in, pulvinar non nisl. Integer auctor lorem ut libero sagittis, non suscipit dui rhoncus. Pellentesque egestas, elit sed blandit volutpat, nisi ligula efficitur velit, in dignissim sapien leo in sapien. Nullam bibendum metus sit amet est commodo malesuada. Aenean tincidunt felis urna, sed sagittis lectus commodo et. Quisque ac odio arcu. Aliquam finibus eget dui nec tristique. Vestibulum vitae ipsum a enim convallis fermentum sit amet volutpat dui. Donec id nunc sed est scelerisque iaculis. Mauris id fermentum metus. Etiam eget metus id purus bibendum varius.\n\nNullam auctor diam turpis, eget euismod ex congue id. Fusce ultricies vitae sem in vehicula. In aliquet ante sed nunc laoreet, eu blandit est hendrerit. Vestibulum eget leo sed nibh varius sagittis. Nulla nec magna id metus pretium hendrerit. In sed nibh et lectus volutpat pretium. Praesent suscipit sapien a urna ullamcorper, at venenatis massa euismod. Suspendisse nisl urna, hendrerit id tortor nec, hendrerit tristique eros. Sed pharetra urna eget ligula dapibus, a vestibulum nunc egestas. Curabitur eget ligula et lacus facilisis placerat sed a diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Praesent at ligula nec diam lobortis ullamcorper.\n\nProin et varius ipsum, commodo convallis odio. Mauris eget augue varius, imperdiet libero eget, vulputate leo. Ut eget interdum metus. Aenean vehicula ex id mi scelerisque, et dapibus metus pulvinar. Phasellus vestibulum nisi a ultricies eleifend. Nulla tellus arcu, scelerisque at mattis in, suscipit eu neque. Suspendisse tortor tellus, sollicitudin sit amet sapien vel, congue luctus mi. Phasellus sed dolor ultrices tellus pellentesque varius. Integer condimentum rhoncus metus eu rhoncus. Pellentesque interdum nisl ut ex volutpat rhoncus. Donec lectus massa, dignissim rutrum lobortis eu, gravida vel risus. Nulla eget tincidunt quam, sit amet cursus risus. Praesent sit amet nulla at eros placerat blandit eget sed tellus. Quisque sed leo nec eros maximus pellentesque. Ut elementum pretium ante quis hendrerit. Proin maximus sagittis odio, vel fermentum leo consectetur at.\n\nMaecenas fringilla diam mauris, eget rutrum sem ultrices id. Donec euismod, lacus eu finibus posuere, nisl lacus posuere nulla, a aliquam diam nisl ac lectus. Morbi eu pellentesque ex, quis sodales eros. In quis interdum libero. Morbi tristique ligula a arcu convallis, ac sollicitudin ante scelerisque. Duis vitae tellus diam. Ut a dictum augue. Suspendisse ligula arcu, aliquam non eros in, sollicitudin molestie metus. Maecenas mollis ante urna, ut ultricies augue malesuada et. Vivamus accumsan erat ut risus fringilla tempor.",
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w100, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
