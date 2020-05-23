import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guitar_tabs/colors.dart';
import 'package:guitar_tabs/forms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:guitar_tabs/strings.dart' as strings;
import 'package:guitar_tabs/dashboard.dart' as tabs;

class CommentPage extends StatefulWidget {
  tabs.Tab tab;
  CommentPage({this.tab});
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = new TextEditingController();
  Future<List<Comment>> _futureCommentsList;
  List<Comment> _commentsList;
  int _quantity;

  @override
  void initState() {
    super.initState();
    _futureCommentsList = fetchComments();
  }

  Future<List<Comment>> fetchComments() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString('token');
      List<Comment> comments = List<Comment>();
      var response = await http.get(
        "${strings.url}api/comments/${widget.tab.id}",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        String jsonDataString = response.body.toString();
        var jsonData = json.decode(jsonDataString);
        for (var c in jsonData) {
          Comment comment = Comment(c["user"]["nick"], c["message"]);
          comments.add(comment);
        }
        setState(() {
          _commentsList = comments;
        });
        return comments;
      }
      return comments;
    } catch (e) {
      return List<Comment>();
    }
  }

  postComment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    Map data = {
      "tab": widget.tab.id,
      "message": commentController.text,
    };
    var response = await http.post(
      "${strings.url}api/comments/new/",
      body: JsonEncoder().convert(data),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Comments",
            style: TextStyle(fontWeight: FontWeight.w100),
            textAlign: TextAlign.center),
      ),
      body: Column(children: <Widget>[
        FutureBuilder(
            future: _futureCommentsList,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: _commentsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Card(
                            child: ListTile(
                              title: Text(snapshot.data[index].user, style: TextStyle(color: kSecondaryLight)),
                              subtitle: Text(snapshot.data[index].text),
                              dense: true,
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return Container(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            }),
        Container(
          padding: EdgeInsets.all(40),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: tabField("Comment", commentController),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () async {
                    await postComment();
                    commentController.text = "";
                    FocusScope.of(context).requestFocus(FocusNode());
                  }),
            ],
          ),
        )
      ]),
    );
  }
}

class Comment {
  final String user;
  final String text;

  Comment(this.user, this.text);
}
