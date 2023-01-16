import 'package:flutter/material.dart';
import 'package:work_os/inner_screens/profile.dart';

class CommentWidget extends StatefulWidget {

  final String commentId ;
  final String commenterId ;
  final String commenterName ;
  final String commentBody ;
  final String commenterImageUrl ;

  const CommentWidget({
    required this.commentId,
    required this.commenterId,
    required this.commenterName,
    required this.commentBody,
    required this.commenterImageUrl
  });
  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  List<Color> _colors = [
    Colors.amber,
    Colors.blue,
    Colors.pink.shade200,
    Colors.orange,
    Colors.brown,
    Colors.cyan,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(
      onTap: ()
      {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context)=>ProfileScreen(userID:widget.commenterId),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                border:Border.all(
                    width: 2,
                    color: _colors[1],
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    widget.commenterImageUrl,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 6.0,
          ),
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                widget.commenterName,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                  ),
                ),
                Text(
                  widget.commentBody,
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
