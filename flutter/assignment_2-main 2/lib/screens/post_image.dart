import 'package:flutter/material.dart';
import 'package:assignment_2/network/getPostImage.dart';
import 'package:assignment_2/utils/request_states.dart';
import 'package:assignment_2/utils/image_io.dart';
import 'package:assignment_2/post/post_provider.dart';
import 'package:provider/provider.dart';

class PostImage extends StatefulWidget {
  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {

  GetPostImage getPostImageHandle;

  @override
  void initState() {
    super.initState();
    getPostImageHandle = GetPostImage((Status requestState) => {});
  }

  @override
  Widget build(BuildContext context) {

    final postProvider = Provider.of<PostModel>(context, listen: false);
    final int imageId = postProvider.imageId;

    var placeHolderImage = (IconData icon, [Color color = Colors.blue]) {
      return new FittedBox(
        fit: BoxFit.fitHeight,
        child: Icon(
          icon,
          color: color,
          size: 60,
        ),
      );
    };

    var getImageFromResponse = (response) {
      if(response['status']) {
        try {
          final base64EncodedImage = response['body']['image'];
          return Image.memory(
            base64Decode(base64EncodedImage),
            fit: BoxFit.fitHeight,
          );
        }
        catch(e) {
          return placeHolderImage(Icons.broken_image, Colors.red);
        }
      }
      return placeHolderImage(Icons.broken_image, Colors.red);
    };

    if(imageId == -1) {
      return placeHolderImage(Icons.image);
    }

    Future<Map<String, dynamic>> _fetchPostImage = getPostImageHandle.getInstaPostImage(imageId);
    return FutureBuilder<Map<String, dynamic>>(
        future: _fetchPostImage,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          Widget image;
          if(snapshot.hasData) {
            image = getImageFromResponse(snapshot.data);
          }
          else if(snapshot.hasError) {
            print(snapshot.data);
            image = placeHolderImage(Icons.broken_image, Colors.red);
          }
          else {
            image = SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            );
          }
          return image;
        }
    );
  }
}