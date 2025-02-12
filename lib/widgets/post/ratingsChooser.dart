import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knocky/controllers/authController.dart';
import 'package:knocky/helpers/api.dart';
import 'package:knocky/helpers/icons.dart';
import 'package:knocky/models/usergroup.dart';

class RatingsChooser extends StatelessWidget {
  final int postId;
  final Function onRatingClicked;
  final Function onRatingDone;
  final AuthController authController = Get.put(AuthController());

  RatingsChooser(
      {@required this.postId, this.onRatingClicked, this.onRatingDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      height: 48,
      child: ratingsList(),
    );
  }

  Widget ratingsList() {
    var ratings = ratingsMapForContext(
            Usergroup.values[authController.usergroup?.value], 1)
        .entries;
    return ListView.builder(
        padding: EdgeInsets.only(left: 8, right: 8),
        scrollDirection: Axis.horizontal,
        itemCount: ratings.length,
        itemBuilder: (context, index) {
          var rating = ratings.elementAt(index);
          return ratingButton(
              rating.value, postId, onRatingClicked, onRatingDone, true);
        });
  }

  static Widget ratingIcon(RatingItem ratingItem, {double size = 16}) {
    return ExtendedImage.network(ratingItem.url, width: size, height: size);
  }

  static Widget ratingButton(RatingItem ratingItem, int postId,
      Function onRatingClicked, Function onRatingDone, bool canRate) {
    return Container(
      child: IconButton(
        color: Colors.green,
        padding: EdgeInsets.all(4),
        splashRadius: 16,
        visualDensity: VisualDensity.compact,
        onPressed: () => canRate
            ? {
                onRatingClicked(),
                onRatingPressed(
                    postId, ratingItem.id, onRatingClicked, onRatingDone)
              }
            : {},
        icon: ExtendedImage.network(ratingItem.url),
      ),
    );
  }

  static Future<void> onRatingPressed(int postId, String ratingId,
      Function onRatingClicked, Function onRatingDone) async {
    onRatingClicked();
    await KnockoutAPI().ratePost(postId, ratingId);
    onRatingDone();
  }
}
