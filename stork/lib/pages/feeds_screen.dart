import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nopcart_flutter/pages/more/barcode_scanner_screen.dart';
import 'package:nopcart_flutter/pages/more/contact_us_screen.dart';
import 'package:nopcart_flutter/pages/more/settings_screen.dart';
import 'package:nopcart_flutter/pages/more/topic_screen.dart';
import 'package:nopcart_flutter/pages/more/vendor_list_screen.dart';
import 'package:nopcart_flutter/service/GlobalService.dart';
import 'package:nopcart_flutter/utils/AppConstants.dart';
import 'package:nopcart_flutter/utils/Const.dart';
import 'package:nopcart_flutter/utils/shared_pref.dart';
import 'package:nopcart_flutter/utils/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedsScreen extends StatefulWidget {
  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  GlobalService _globalService = GlobalService();
  @override
  Widget build(BuildContext context) {
    var content = RefreshIndicator(
        child: FutureBuilder<List<String>>(
            future: SessionData().getFeeds(),
            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else {
                if (snapshot.data.isEmpty == true)
                  return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No feeds'),
                          SizedBox(
                            width: 112,
                            child: OutlinedButton(
                                onPressed: () {
                                  setState((){});
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Refresh'),
                                    Icon(Icons.refresh)
                                  ],
                                )
                            ),
                          )
                        ],
                      )
                  );
                else
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      LineSplitter ls = new LineSplitter();

                      List<String> stringList = ls.convert(snapshot.data.reversed.toList()[index]);

                      var title = stringList.first ?? '';
                      var content = stringList.sublist(1, stringList.length - 1).join('\n');
                      var dateTime = DateFormat('MM/dd/yyyy kk:mm').format(DateFormat('MM/dd/yyyy kk:mm').parse(stringList.last).toLocal()) ?? '';

                      return Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                              Container(height: 12,),
                              Text(
                                  content,
                                  style: TextStyle(
                                      fontSize: 14
                                  )
                              ),
                              Container(height: 12,),
                              Text(
                                dateTime,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
              }
            }),
        onRefresh: () async {
          setState((){});
        }
    );

    return Scaffold(
      body: _globalService.centerWidgets(content),
    );

    return RefreshIndicator(
        child: CustomScrollView(
          slivers: [
            // FutureBuilder<List<String>>(
            //   future: SessionData().getFeeds(),
            //   builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            //     // return Center(
            //     //   child: CircularProgressIndicator(),
            //     // );
            //
            //     if (!snapshot.hasData) {
            //       // while data is loading:
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     } else {
            //         return Center(
            //           child: SizedBox(
            //               height: 32,
            //               child: Center(
            //                 child: Text('No feeds'),
            //               )
            //           ),
            //         );
            //       }
            //     //
            //     //   return SliverList(
            //     //     delegate: SliverChildBuilderDelegate((context, index) {
            //     //       return Container(
            //     //         child: Text("${snapshot.data[index]}"),
            //     //       );
            //     //     })
            //     //   );
            //     }
            //   // }
            // ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(),
            )
          ],
        ),
        onRefresh: () async {
          setState(() {});
        }
    );

    return RefreshIndicator(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: FutureBuilder<List<String>>(
                future: SessionData().getFeeds(),
                builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                  if (!snapshot.hasData) {
                    // while data is loading:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data?.isEmpty == true)
                      return Center(
                        child: SizedBox(
                            height: 32,
                            child: Center(
                              child: Text('No feeds'),
                            )
                        ),
                      );

                    return Container();
                  }
                }
              ),
            )
          ],
        ),
        onRefresh: () async {
          setState(() {

          });
        }
    );

  }
}
