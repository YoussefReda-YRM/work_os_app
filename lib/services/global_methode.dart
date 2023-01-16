import 'package:flutter/material.dart';
import 'package:work_os/constants/constants.dart';

class GlobalMethode
{
  static void showErrorDialog({
  required String error,
  required BuildContext context,
})
  {
    showDialog(
      context: context,
      builder:(context)
      {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9ym6W4NL97pMQGTvJC-QXrP9fqMXcqXdKSw&usqp=CAU',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:const Text(
                    'Error occured'
                ),
              ),
            ],
          ),
          content: Text(
            '$error',
            style: TextStyle(
              color: Constants.darkBlue,
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            TextButton(
              onPressed:()
              {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}