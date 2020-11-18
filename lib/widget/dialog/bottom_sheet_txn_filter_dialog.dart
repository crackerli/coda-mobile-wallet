import 'package:coda_wallet/widget/tab/customized_tab_indicator.dart';
import 'package:flutter/material.dart';

showBottomSheet(BuildContext context) {
  List<String> topList = ['All', 'Sent', 'Received', 'Staked'];
  showModalBottomSheet(
    enableDrag: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(7.0))),
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(31, 118, 118, 128),
          borderRadius: BorderRadius.all(
            Radius.circular(7.0),
          )
        ),
        margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(1.5),
            child: DefaultTabController(
              length: 4,
              child: TabBar(
                onTap: (i) => print('Tab $i clicked'),
                indicatorColor: Colors.blue,
                indicator: CustomizedUnderlineTabIndicator(),
                labelPadding: EdgeInsets.zero,
                unselectedLabelColor: Colors.black,
                tabs: topList.map((String name) => Container(child: Tab(text: name))).toList(),
              ),
            )
          )
        );
      }
  );
}