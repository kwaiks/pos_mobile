import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Icon icon;
  ReportCard({@required this.title, this.child, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ]),
        child: Column(children: <Widget>[
          Row(
            children: [
              icon,
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 24))),
            ],
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10), child: child)
        ]));
  }
}
