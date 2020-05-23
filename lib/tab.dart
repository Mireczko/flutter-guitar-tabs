import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:guitar_tabs/comments.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:guitar_tabs/strings.dart' as strings;
import 'package:guitar_tabs/dashboard.dart' as tabs;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'colors.dart';
import 'package:http/http.dart' as http;

class TabPage extends StatefulWidget {
  tabs.Tab tab;
  TabPage({this.tab});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  Future<TabDetails> _futureTab;
  @override
  void initState() {
    super.initState();
    _futureTab = fetchTab();
  }

  Future<TabDetails> fetchTab() async {
    try {
      TabDetails tab;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString('token');
      var response = await http.get(
        "${strings.url}api/tabs/${widget.tab.id}/",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        String jsonDataString = response.body.toString();
        var jsonData = json.decode(jsonDataString);
        TabDetails tab = TabDetails(
            jsonData["song"],
            jsonData["band"],
            jsonData["user"]["nick"],
            jsonData["id"],
            jsonData["tab_text"],
            jsonData["tab_file"],
            jsonData["link"]);

        return tab;
      }
      return tab;
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w200);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.tab.song,
            style: TextStyle(fontWeight: FontWeight.w100),
            textAlign: TextAlign.center),
        actions: [
          IconButton(
            icon: Icon(Icons.comment),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => (CommentPage(tab: widget.tab)),
                ),
              );
            },
          )
        ],
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
        child: FutureBuilder(
            future: _futureTab,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                YoutubePlayerController _controller = YoutubePlayerController(
                  initialVideoId:
                      YoutubePlayer.convertUrlToId(snapshot.data.link),
                  flags: YoutubePlayerFlags(
                    autoPlay: true,
                    mute: true,
                  ),
                );
                return Container(
                    child: Column(children: <Widget>[
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    liveUIColor: kPrimaryColor,
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: 'Song: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 14)),
                                    TextSpan(
                                        text: '${snapshot.data.song}',
                                        style: TextStyle(
                                            color: kSecondaryColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14)),
                                  ]),
                                ),
                                SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: 'Band: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 14)),
                                    TextSpan(
                                        text: '${snapshot.data.band}',
                                        style: TextStyle(
                                            color: kSecondaryColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14)),
                                  ]),
                                ),
                                SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: 'Tab by: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w200,
                                            fontSize: 14)),
                                    TextSpan(
                                        text: '${snapshot.data.user}',
                                        style: TextStyle(
                                            color: kSecondaryColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14)),
                                  ]),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text("${snapshot.data.tab_text}"),
                                SizedBox(
                                  height: 50,
                                ),
                                Center(
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: "Download Tab",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: kSecondaryColor),
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            _launchURL(
                                                "http://192.168.0.101:8000${snapshot.data.tab_file}");
                                          })
                                  ])),
                                ),
                              ])
                        ],
                      )),
                ]));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

class TabDetails {
  final String song;
  final String band;
  final String user;
  final String tab_text;
  final String tab_file;
  final int id;
  final String link;

  TabDetails(this.song, this.band, this.user, this.id, this.tab_text,
      this.tab_file, this.link);
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
