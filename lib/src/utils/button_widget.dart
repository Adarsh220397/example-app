import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final String text;
  final VoidCallback? onClicked;
  final bool? bFullContainerButton;
  final bool? bprevNextButton;
  final IconData? preIcon;
  final IconData? postIcon;
  final bool? isSecondary;
  const ButtonWidget(
      {Key? key,
      required this.text,
      required this.onClicked,
      this.bFullContainerButton,
      this.bprevNextButton,
      this.preIcon,
      this.postIcon,
      this.isSecondary})
      : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    // if (widget.bFullContainerButton != null) {
    //   return buttonMaterial();
    // }
    // if (widget.bprevNextButton != null) {
    //   return prevNextButtonMaterial();
    // }
    if (widget.preIcon != null || widget.postIcon != null) {
      return buttonIconMaterial();
    }
    if (widget.isSecondary != null) {
      return buttonSecondary();
    }
    return buttonIconMaterial();
  }

  Widget buttonSecondary() {
    return MaterialButton(
        minWidth: 100,
        height: MediaQuery.of(context).size.height / 15,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            side: BorderSide(color: Colors.white)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.text,
                style: themeData.textTheme.titleMedium!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        onPressed: widget.onClicked);
  }

  // Widget buttonWidget() {
  //   return Align(
  //     child: ElevatedButton(
  //       onPressed: widget.onClicked,
  //       style: widget.onClicked != null
  //           ? elevatedButtonTheme()
  //           : disabledButtonTheme(),
  //       child: Text(
  //         widget.text,
  //         style: themeData.textTheme.button!.copyWith(
  //             color: widget.onClicked != null ? Colors.black : Colors.black),
  //       ),
  //     ),
  //   );
  // }

  // Widget buttonMaterial() {
  //   return MaterialButton(
  //     minWidth: SizeUtils.screenWidth,
  //     color: ColorConstants.appColor,
  //     disabledColor: ColorConstants.buttomDisabledColor,
  //     disabledTextColor: Colors.black,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(widget.text, style: themeData.textTheme.button),
  //       ],
  //     ),
  //     onPressed: widget.onClicked,
  //   );
  // }

  // Widget prevNextButtonMaterial() {
  //   return ElevatedButton(
  //     onPressed: widget.onClicked,
  //     style: widget.onClicked != null
  //         ? ElevatedButton.styleFrom(
  //             primary: ColorConstants.appColor,
  //             onSurface: ColorConstants.appColor,
  //             minimumSize: Size(SizeUtils.screenWidth / 3, SizeUtils.get(11)),
  //             maximumSize: Size(SizeUtils.screenWidth / 3, SizeUtils.get(11)),
  //             padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(3)),
  //             shape: RoundedRectangleBorder(
  //               borderRadius:
  //                   BorderRadius.all(Radius.circular(SizeUtils.get(2))),
  //             ),
  //           )
  //         : ButtonStyle(
  //             minimumSize: MaterialStateProperty.all(
  //                 Size(SizeUtils.screenWidth / 3, SizeUtils.get(11))),
  //             padding: MaterialStateProperty.all(
  //                 EdgeInsets.symmetric(horizontal: SizeUtils.get(3))),
  //             shape: MaterialStateProperty.all(RoundedRectangleBorder(
  //               borderRadius:
  //                   BorderRadius.all(Radius.circular(SizeUtils.get(2))),
  //             )),
  //             backgroundColor: MaterialStateProperty.resolveWith<Color>(
  //                 (Set<MaterialState> states) {
  //               if (states.contains(MaterialState.disabled)) {
  //                 return ColorConstants.buttomDisabledColor;
  //               }

  //               return ColorConstants.appColor;
  //             })),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         if (widget.preIcon != null)
  //           Expanded(child: Icon(widget.preIcon, color: Colors.black)),
  //         Text(widget.text, style: themeData.textTheme.button),
  //         if (widget.postIcon != null)
  //           Expanded(child: Icon(widget.postIcon, color: Colors.black)),
  //       ],
  //     ),
  //   );
  // }

  Widget buttonIconMaterial() {
    return MaterialButton(
        minWidth: 100,
        height: MediaQuery.of(context).size.height / 15,
        color: Color.fromARGB(38, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.text,
                style: themeData.textTheme.titleMedium!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        onPressed: widget.onClicked);
  }
}
