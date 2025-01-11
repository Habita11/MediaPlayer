import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MainButton extends StatefulWidget {
  IconData icon;
  var color;
 void Function()? onPressed;
  var iconColor;
  double height;
  double iconSize;
 MainButton({
   required this.icon,
   required  this.onPressed,
   this.color=Colors.white,
   this.iconColor=Colors.grey,
   this.height=40,
   this.iconSize=25,
 });

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  AudioPlayer player=AudioPlayer();

  String songPeriod="";

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height:widget.height,
      elevation: 5,
        shape: CircleBorder(),
        color: widget.color,
        onPressed:widget.onPressed,
        child: Icon(widget.icon,
        size: widget.iconSize,
        color: widget.iconColor,),




        );
  }

  void playSong(){
    player.play(AssetSource("song.mp3")).
    then((value) =>player.getDuration().then((value) => songPeriod="${value!.inMinutes}:${value.inSeconds%60}"));

  }
}
