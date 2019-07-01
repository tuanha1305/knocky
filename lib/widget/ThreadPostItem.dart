import 'package:flutter/material.dart';
import 'package:knocky/models/thread.dart';
import 'package:knocky/widget/SlateDocumentParser/SlateDocumentParser.dart';
import 'package:knocky/helpers/icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:knocky/widget/PostHeader.dart';

class ThreadPostItem extends StatelessWidget {
  final ThreadPost postDetails;

  ThreadPostItem({this.postDetails});

  List<Widget> buildRatings(List<ThreadPostRatings> ratings) {
    List<Widget> items = List();

    if (ratings != null) {
      ratings.sort((a,b) => b.count.compareTo(a.count));
      ratings.forEach((rating) {
        RatingistItem icon =
            ratingsIconList.where((icon) => icon.id == rating.rating).first;

        items.add(
          Container(
            margin: EdgeInsets.only(right: 5.0),
            child: Column(children: <Widget>[
              CachedNetworkImage(
                imageUrl: icon.url,
              ),
              Text(rating.count.toString())
            ]),
          ),
        );
      });
    }

    return items;
  }

  void onPressSpoiler (BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                PostHeader(username: postDetails.user.username, avatarUrl: postDetails.user.avatarUrl, backgroundUrl: postDetails.user.backgroundUrl,),
              ],
            ),
            SlateDocumentParser(
              slateObject: postDetails.content,
              onPressSpoiler: (text) {
                onPressSpoiler(context, text);
                },
            ),
            Row(
              children: buildRatings(postDetails.ratings),
            )
          ],
        ),
      ),
    );
  }
}
