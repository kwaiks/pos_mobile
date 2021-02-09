import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_mobile/ui/layout/main_layout.dart';
import 'package:pos_mobile/ui/widgets/report_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return MainLayout(
        title: "Dashboard",
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Report",
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      Text(DateFormat("EEEE, d MMMM y").format(now))
                    ],
                  ),
                ),
                ReportCard(
                  icon: Icon(Icons.trending_up, size: 60, color: Colors.white),
                  title: "Selling",
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Column(
                          children: [
                            Text("Total Transaction",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                            Text("3000",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                          ],
                        )),
                        Container(
                            child: Column(
                          children: [
                            Text("Total Income",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                            Text("Rp 23.023.500",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                          ],
                        ))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ReportCard(
                    icon: Icon(Icons.local_offer_outlined,
                        size: 60, color: Colors.white),
                    title: "Top 5 Menu",
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              child: Column(
                            children: [
                              Text("Total Transaction",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                              Text("3000",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
                            ],
                          )),
                          Container(
                              child: Column(
                            children: [
                              Text("Total Income",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                              Text("Rp 23.023.500",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
                            ],
                          ))
                        ]),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
