import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samadhyan/keys.dart';
//In total, you may not distribute more than 1,500,000 Tweet IDs to any entity
//(inclusive of multiple individuals associated with a single entity)
//within any 30 day period unless you have received written permission from Twitter.
// In addition, all developers may provide up to 50,000 public
//Tweets Objects and/or User Objects to each person who uses your service on a daily basis
// if this is done via non-automated means (e.g., download of spreadsheets or PDFs).

class TweetsPage extends StatefulWidget {
  @override
  _TweetsPageState createState() => _TweetsPageState();
}

class _TweetsPageState extends State<TweetsPage> {
  var tweets = [];

  @override
  void initState() {
    super.initState();
    _fetchTweets();
  }

  _fetchTweets() async {
    const token = twitterApiBearerToken;
    var response = await http.get(
        Uri.parse(
            'https://api.twitter.com/2/tweets/search/recent?query=rtu kota'),
        headers: {
          "Authorization": "Bearer $token",
          // "Content-type": "application/json",
          "mode": 'cors',
          // "credentials": 'include'
        });

    var data = jsonDecode(response.body);
    setState(() {
      tweets = data['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tweets with #rtu'),
      ),
      body: tweets.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.tag_rounded),
                          title: Text(tweets[index]['text']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
