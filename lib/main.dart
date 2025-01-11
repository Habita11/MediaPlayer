import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soundtracks/audio_player.dart';
import 'package:soundtracks/colors.dart';
void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override

  List<SongModel> songs=[];

 final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text("Sound tracks"),

      ),
      body:
      FutureBuilder(
        builder: (context,snapshot){
         if(snapshot.hasData){return ListView.separated(
             itemBuilder: (context,i)=>ListTile(
               onTap: (){
                 Navigator.push(context,MaterialPageRoute(builder:
                     (context)=>AudioPlayerScreen(url: snapshot.data![i].data,)));
               },
               title: Text(snapshot.data![i].title),
               subtitle:Text(snapshot.data![i].artist!) ,
               trailing: Column(
                 children: [
                   Text(snapshot.data![i].displayName),
                   Text("${(snapshot.data![i].duration!/3600000).toInt()}:"
                       "${(snapshot.data![i].duration! / 60000 ).toInt()}:"
                       "${(snapshot.data![i].duration! % 60000 /1000 ).toInt()}"),
                 ],
               ),
             ),
             separatorBuilder: (context,i)=>Divider(),
             itemCount: snapshot.data!.length); } else{
           return Center(child: CircularProgressIndicator());
         }
        },
       future: getAudio(),
      ),
    );

  }

  Future<List<SongModel>> getAudio() async{
    if(await Permission.storage.request().isGranted){
   songs= await _audioQuery.querySongs();
  return songs;
 }else{
      return [];
    }
  }



}
