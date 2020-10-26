import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ktop100/Music.dart';

import 'date.dart';

Future<List<Music>> fetchMusics(http.Client client) async {
  final response =
  await client.get('http://www.mtop100.net/real/2020102300');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseMusics, response.body);
}

Future<List<String>> fetchDates(http.Client client) async {
  final response =
  await client.get('http://www.mtop100.net/real/basetimes');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseDates, response.body);
}


List<Music> parseMusics(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Music>((json) => Music.fromJson(json)).toList();
}

List<String> parseDates(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<List<String>>();

  return parsed.map<String>((json) => Date.fromJson(json)).toList();
}


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'k-top100';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body:
          FutureBuilder<List<Music>>(
            future: fetchMusics(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? MusicList(musics: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),

    );
  }
}

class MusicTile extends StatelessWidget {
  MusicTile(this._music);

  final Music _music;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(_music.jacket,height: 40,),
      title: Row(
        children: [
          Expanded(child: Text(_music.ranking,),flex:1),
          Expanded(child: Text(_music.title),flex:7),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(child: SizedBox(),flex: 1,),
          Expanded(child: Text(_music.artist),flex: 7,),
        ],
      ),
      trailing: Icon(Icons.play_arrow),
    );
  }
}



class MusicList extends StatelessWidget {
  final List<Music> musics;

  MusicList({Key key, this.musics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context, index) {
      return MusicTile(musics[index]);
    }, separatorBuilder: (context, index) {
      return const Divider();
    }, itemCount: 100);
  }
}