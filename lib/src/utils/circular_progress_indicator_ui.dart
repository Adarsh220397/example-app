import 'package:flutter/material.dart';

class CircularIndicator extends StatefulWidget {
  const CircularIndicator({
    Key? key,
  }) : super(key: key);

  @override
  State<CircularIndicator> createState() => _CircularIndicatorState();
}

class _CircularIndicatorState extends State<CircularIndicator> {
  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return SizedBox(
      height: 50,
      width: 70,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: SizedBox(
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.amber,
                ),
                width: 10,
                height: 10,
              ),
            ),
            SizedBox(width: 5),
            Padding(
              padding: EdgeInsets.all(5),
              child: SizedBox(
                child: Text('Please wait...',
                    style: themeData.textTheme.subtitle1,
                    textAlign: TextAlign.center),
              ),
            ),
          ]),
    );
  }
}
