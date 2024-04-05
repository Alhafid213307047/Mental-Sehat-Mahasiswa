import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class PlayMeditation extends StatefulWidget {
  final String title;
  final String imageAsset;
  final List<String> audioPaths;
  final List<String> trackTitles;
  final int selectedIndex;

  PlayMeditation({
    required this.title,
    required this.imageAsset,
    required this.audioPaths,
    required this.trackTitles,
    required this.selectedIndex,
  });

  @override
  _PlayMeditationState createState() => _PlayMeditationState();
}

class _PlayMeditationState extends State<PlayMeditation> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  bool isPlaying = false;
  int currentIndex = 0;
  bool isAutoPlayEnabled = false;
  late String currentTrackTitle;
  late String appBarTitle;
  late String backgroundImage;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.selectedIndex;
    currentTrackTitle = widget.trackTitles[currentIndex];
    appBarTitle = currentTrackTitle; 
    // Determine background image based on audioPath
    if (widget.audioPaths.any((path) => path.contains('mindfulness'))) {
      backgroundImage = 'images/weather_animation.gif';
    } else if (widget.audioPaths.any((path) => path.contains('suaraAlam')) &&
        widget.audioPaths.any((path) => path.contains('hujan'))) {
      backgroundImage = 'images/rain_animation.gif';
    } else if (widget.audioPaths.any((path) => path.contains('religius'))) {
      backgroundImage = 'images/islamic.jpeg';
    } else {
      // Default background image if no condition is met
      backgroundImage = 'images/default_background.gif';
    }


    audioPlayer.isPlaying.listen((event) {
      setState(() {
        isPlaying = event;
      });
    });

    audioPlayer.open(Audio(widget.audioPaths[currentIndex]), autoStart: true);
    audioPlayer.currentPosition.listen((event) {
      setState(() {
        currentTrackTitle = widget.trackTitles[currentIndex];
      });
    });

    audioPlayer.playlistFinished.listen((finished) {
      if (isAutoPlayEnabled && finished) {
        _continueAutomatically(); // Mulai pemutaran otomatis setelah trek saat ini selesai
        if (finished && currentIndex == widget.audioPaths.length - 1) {
          print("Last track finished: ${widget.trackTitles[currentIndex]}");
        }
      }
    });

    audioPlayer.playlistAudioFinished.listen((audio) {
      print(
          "Index trek: $currentIndex, Judul trek: ${widget.trackTitles[currentIndex]}");
      setState(() {
        if (audio.hasNext) {
          currentIndex++;
          currentTrackTitle = widget.trackTitles[currentIndex];
        }
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  void _updateAppBarTitle() {
    setState(() {
      // Mengubah judul AppBar sesuai dengan trek audio yang sedang diputar
      appBarTitle = currentTrackTitle;
    });
  }

  void _continueAutomatically() {
    if (currentIndex <= widget.audioPaths.length - 1) {
      if (!audioPlayer.isPlaying.value) {
        // Periksa apakah audio saat ini telah selesai
        currentIndex++;
        setState(() {
          currentTrackTitle = widget.trackTitles[currentIndex];
        });
        audioPlayer.open(Audio(widget.audioPaths[currentIndex]),
            autoStart: true);
            _updateAppBarTitle();
      }
    } else {
      audioPlayer.stop();
    }
  }

  void _skipNext() {
    if (currentIndex < widget.audioPaths.length - 1) {
      // Cek apakah masih ada trek berikutnya dalam daftar
      currentIndex++;
      setState(() {
        currentTrackTitle = widget.trackTitles[currentIndex];
      });
      audioPlayer.open(Audio(widget.audioPaths[currentIndex]), autoStart: true);
      _updateAppBarTitle();
    } else {
      // Jika tidak ada trek berikutnya, tampilkan snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ini adalah trek terakhir dalam daftar',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
        ),
      );
    }
  }

  void _skipPrevious() {
    if (currentIndex > 0) {
      // Cek apakah masih ada trek sebelumnya dalam daftar
      currentIndex--;
      setState(() {
        currentTrackTitle = widget.trackTitles[currentIndex];
      });
      audioPlayer.open(Audio(widget.audioPaths[currentIndex]), autoStart: true);
      _updateAppBarTitle();
    } else {
      // Jika tidak ada trek sebelumnya, tampilkan snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ini adalah trek pertama dalam daftar',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
        ),
      );
    }
  }

  void _toggleAutoPlay() {
    setState(() {
      isAutoPlayEnabled = !isAutoPlayEnabled;
    });
    // Tampilkan Snackbar sesuai kondisi
    final message = isAutoPlayEnabled
        ? 'Beralih ke putaran otomatis'
        : 'Beralih ke pemutaran manual';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      message,
      style: TextStyle(fontFamily: 'Poppins'),
    )));
    if (isAutoPlayEnabled && !audioPlayer.isPlaying.value) {
      _continueAutomatically(); // Mulai pemutaran otomatis jika audio saat ini telah selesai
    }
  }

  void _handleBackButton() {
    audioPlayer.stop(); // Menghentikan semua audio saat kembali
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackButton();
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      Image.asset(
                        widget.imageAsset,
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(height: 16),
                      Text(
                        appBarTitle,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              (backgroundImage == 'images/rain_animation.gif' ||
                                      backgroundImage == 'images/islamic.jpeg')
                                  ? Colors.white
                                  : null, 
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (audioPlayer.currentPosition.hasValue &&
                  audioPlayer.current.hasValue &&
                  audioPlayer.current.value != null)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LinearProgressIndicator(
                        value: audioPlayer.currentPosition.value.inMilliseconds /
                            (audioPlayer.current.value!.audio.duration
                                        .inMilliseconds ==
                                    0
                                ? 1
                                : audioPlayer.current.value!.audio.duration
                                    .inMilliseconds),
                        minHeight: 5,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${audioPlayer.currentPosition.value.inMinutes}:${(audioPlayer.currentPosition.value.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: (backgroundImage ==
                                          'images/rain_animation.gif' || 
                                          backgroundImage == 'images/islamic.jpeg')
                                  ? Colors.white 
                                  : null, 
                            ),
                          ),
                          Text(
                            '${audioPlayer.current.value!.audio.duration.inMinutes}:${(audioPlayer.current.value!.audio.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: (backgroundImage ==
                                          'images/rain_animation.gif' ||
                                      backgroundImage == 'images/islamic.jpeg')
                                  ? Colors.white
                                  : null,  
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PlayerBuilder.isPlaying(
                  player: audioPlayer,
                  builder: (context, isPlaying) {
                    this.isPlaying = isPlaying;
                    return _buildAudioControlButtons();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularIconButton(IconData icon, Function() onPressed,
      {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: CircleAvatar(
          radius: 30,
          backgroundColor: iconColor ??
              Color(
                  0xFF04558F), // Gunakan abu-abu jika iconColor tidak disediakan
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAudioControlButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildCircularIconButton(Icons.skip_previous, () {
        _skipPrevious();
      }),
      _buildCircularIconButton(
        isPlaying ? Icons.pause : Icons.play_arrow,
        _playPause,
      ),
      _buildCircularIconButton(Icons.skip_next, () {
        _skipNext();
      }),
      _buildCircularIconButton(Icons.refresh, _toggleAutoPlay,
          iconColor: isAutoPlayEnabled ? Color(0xFF04558F) : Colors.grey),
    ]);
  }
}
