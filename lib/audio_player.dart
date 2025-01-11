
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'components.dart';

class AudioPlayerScreen extends StatefulWidget {
  String url;
 AudioPlayerScreen({
   required this.url
});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState(url: url);
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  String url;
  _AudioPlayerScreenState({required this.url});
  AudioPlayer player = AudioPlayer();
  double _value = 0;
  double maxValue = 20;
  String currentValue="00:00";
  String currentSong="song.mp3";
  String songPeriod = "00:00";
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          minimum: EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Row(
                children: [
                  MainButton(icon: Icons.arrow_back, onPressed: () {}),
                  const Spacer(),
                  const Text(
                    "PLAYING NOW",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  MainButton(icon: Icons.list, onPressed: () {})
                ],
              ),
              Container(
                height: 350,
                child: Stack(
                  children: const [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF8c74b1),
                        radius: 150,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                          radius: 135,
                          backgroundImage: AssetImage("assets/background.jpg")),
                    ),
                  ],
                ),
              ),
              Text(
                currentSong,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                currentSong,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Text(
                      currentValue,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    Text(
                      songPeriod,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  overlayColor: AppColors.mainColor,
                  activeTrackColor: AppColors.mainColor,
                  trackShape: RoundedRectSliderTrackShape(),
                  inactiveTrackColor: Color(0xffd8bbf5),
                  trackHeight: 10,
                  thumbColor: Colors.white,
                ),
                child: Slider(

                    max: maxValue,
                    min: 0,
                    value: _value,
                    onChanged: (value) {
                      seek(value.toInt());
                      setState(() {
                        _value = value;
                      });
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    MainButton(
                        iconSize: 40,
                        height: 70,
                        iconColor: AppColors.mainColor,
                        icon: Icons.fast_rewind,
                        onPressed: () {}),
                    const Spacer(),
                    MainButton(
                        height: 80,
                        iconSize: 40,
                        icon: isPlaying ? Icons.stop : Icons.play_arrow,
                        color: AppColors.mainColor,
                        iconColor: Colors.white,
                        onPressed: () {
                          if (isPlaying == false) {
                            playSong();
                          } else {
                            stopAudio();
                          }
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        }),
                    const Spacer(),
                    MainButton( height: 70,
                        iconSize: 40,
                        iconColor: AppColors.mainColor,
                        icon: Icons.fast_forward, onPressed: (){

                        })

                  ],
                ),
              ),
            ],
          )),
    );
  }

  void playSong() {
    print(url+"habita");
    player
        .play(DeviceFileSource(url))
        .then((value) {
          player.getDuration().then((value) {
              songPeriod = "${value!.inMinutes}:${value.inSeconds % 60}";
              maxValue = value.inSeconds.toDouble();
              getState();
              changeDuration();
            });});

  }

  void pauseAudio() {
    player.pause();
  }

  void resumeAudio() {
    player.resume();
  }

  void stopAudio() {
    player.stop();
    setState(() {
      currentValue="00:00";
      songPeriod="00:00";
      _value=0;
    });
  }

  void controlAudioSpeed() {
    player.setPlaybackRate(10);
  }

  void controlAudioVolume() {
    player.setVolume(.2);
  }

  void seek(int value) {
    player.seek(Duration(seconds: value));
  }
  void changeDuration()async{
    var duration =player.onPositionChanged.listen((event) {setState(() {
      currentValue="${event.inMinutes}:${event.inSeconds }";
      _value=event.inSeconds.toDouble();
    }); });

  }
  void getState() {
    player.onPlayerStateChanged.listen((event) {
    if(event==PlayerState.completed){
      setState(() {
        isPlaying=false;
        currentValue="00:00";
        songPeriod="00:00";
        _value=0;
      });
    }
    });
  }
}
