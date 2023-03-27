import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerBottomDialogWidget extends StatelessWidget {
  CustomerBottomDialogWidget(
    {Key? key,
    this.title,
    this.titleStyle,
    this.titleAlign,
    this.buttonText,
    this.buttonTextStyle,
    this.buttonTextAlign,
    this.isShowCloseButton,
    this.isShowTopIcon,
    this.actions,
    this.customView = const SizedBox(),
    this.color});

  // Widgets to display a row of buttons after the [msg] widget.
  final List<Widget>? actions;

  // a widget to display a custom widget instead of the animation view.
  final Widget? customView;

  // your dialog title
  final String? title;

  // your dialog button text
  final String? buttonText;

  // dialog title text style
  final TextStyle? titleStyle;

  // button text style
  final TextStyle? buttonTextStyle;

  // dialog title text alignment
  final TextAlign? titleAlign;

  // button text alignment
  final TextAlign? buttonTextAlign;

  // dialog's background color
  final Color? color;

  // show or hide the close button
  final bool? isShowCloseButton;

  // show or hide the top icon
  final bool? isShowTopIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 15.h),
        Container(
          height: 6.h,
          width: 40.w,
          decoration: BoxDecoration(border: Border.all(width: 1.w, color: Color(0xffbdbdbd)), color: Color(0xfff6f3f6), borderRadius: BorderRadius.circular(6.w))
        ),
        Container(height: 15.h),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                this.title ?? "",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))
              )
            ),
            Container(
              padding: EdgeInsets.only(right: 20.w),
              child: GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close, size: 16.w))
            )
          ]
        ),
        Divider(height: 28.h),
        SingleChildScrollView(
          child: customView ?? const SizedBox()
        ),
        Container(height: 10.h),
        Divider(height: 1.h),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            height: 50.h,
            child: Align(
              alignment: Alignment.center,
              child: Text(buttonText ?? "Cancel")
            )
          )
        )
      ]
    );
  }
}
