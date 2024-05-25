import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

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
    _setBackgroundImage();

    audioPlayer.currentPosition.listen((event) {
      setState(() {
        currentTrackTitle =
            widget.trackTitles[currentIndex]; // Perbarui currentTrackTitle
      });
    });

    audioPlayer.isPlaying.listen((event) {
      setState(() {
        isPlaying = event;
      });
    });

    _openAudio(currentIndex);

    audioPlayer.playlistAudioFinished.listen((audio) {
      print(
          "Index trek: $currentIndex, Judul trek: ${widget.trackTitles[currentIndex]}");
      setState(() {
        if (audio.hasNext) {
          currentIndex++;
          currentTrackTitle = widget.trackTitles[currentIndex];
          appBarTitle = currentTrackTitle; // Perbarui appBarTitle
        }
      });
    });
  }

  void _setBackgroundImage() {
    if (widget.audioPaths.any((path) => path.contains('mindfulness')) &&
        widget.audioPaths.any((path) => path.contains('stres'))) {
      backgroundImage = 'images/kunang_animation.gif';
    } else if (widget.audioPaths.any((path) => path.contains('mindfulness')) &&
        widget.audioPaths.any((path) => path.contains('afirmasi'))) {
      backgroundImage = 'images/park_animation.gif';
    } else if (widget.audioPaths.any((path) => path.contains('mindfulness')) &&
        widget.audioPaths.any((path) => path.contains('kecemasan'))) {
      backgroundImage = 'images/sakura2_animation.gif';
    } else if (widget.audioPaths.any((path) => path.contains('mindfulness')) &&
        widget.audioPaths.any((path) => path.contains('tidur'))) {
      backgroundImage = 'images/night_animation.gif';
    } else if (widget.audioPaths.any((path) => path.contains('mindfulness')) &&
        widget.audioPaths.any((path) => path.contains('motivasi'))) {
      backgroundImage = 'images/motivasi_animation.gif';
    } else if (widget.audioPaths.any((path) => path.contains('suaraAlam')) &&
        widget.audioPaths.any((path) => path.contains('hujan'))) {
      backgroundImage = 'images/rain6_animation.gif';
    } else if (widget.audioPaths.any((path) => path.contains('suaraAlam')) &&
        widget.audioPaths.any((path) => path.contains('burung'))) {
      backgroundImage = 'images/kicauan_burung6.gif';
    } else if (widget.audioPaths.any((path) => path.contains('suaraAlam')) &&
        widget.audioPaths.any((path) => path.contains('ombak'))) {
      backgroundImage = 'images/ombak_animation.gif';
    } else if (widget.audioPaths.any((path) => path.contains('suaraAlam')) &&
        widget.audioPaths.any((path) => path.contains('sungai'))) {
      backgroundImage = 'images/waterflow2_animation.gif';
    } else if (widget.audioPaths.any((path) => path.contains('suaraAlam')) &&
        widget.audioPaths.any((path) => path.contains('malam'))) {
      backgroundImage = 'images/night4_animation.gif';
    } else if (widget.audioPaths.any((path) => path.contains('religius'))) {
      backgroundImage = 'images/islamic.jpeg';
    } else {
      backgroundImage = 'images/weather_background.gif';
    }
  }

  void _openAudio(int index) {
    audioPlayer.open(
      Audio.network(widget.audioPaths[index]),
      autoStart: true,
      showNotification: true,
    );
  }

  @override
  void dispose() {
    audioPlayer.stop();
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
      appBarTitle = currentTrackTitle;
    });
  }

  void _skipNext() {
    if (currentIndex < widget.audioPaths.length - 1) {
      currentIndex++;
      setState(() {
        currentTrackTitle = widget.trackTitles[currentIndex];
      });
      _openAudio(currentIndex);
      _updateAppBarTitle();
    } else {
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
      currentIndex--;
      setState(() {
        currentTrackTitle = widget.trackTitles[currentIndex];
      });
      _openAudio(currentIndex);
      _updateAppBarTitle();
    } else {
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

  Future<void> _toggleAutoPlay() async {
    setState(() {
      isAutoPlayEnabled = !isAutoPlayEnabled;
    });

    final message = isAutoPlayEnabled
        ? 'Beralih ke putaran otomatis'
        : 'Beralih ke pemutaran manual';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
    );

    if (isAutoPlayEnabled) {
      await _playNextIfAvailableAfterCurrent();
    }
  }

  Future<void> _playNextIfAvailableAfterCurrent() async {
    final isPlaying = await audioPlayer.isPlaying.first;
    if (!isPlaying) {
      // Jika tidak ada audio yang sedang diputar, lanjutkan ke audio berikutnya
      _playNextIfAvailable();
    } else {
      // Jika audio sedang diputar, tunggu hingga selesai, kemudian lanjutkan ke audio berikutnya
      await audioPlayer.playlistAudioFinished.first;
      _playNextIfAvailable();
    }
  }

  void _playNextIfAvailable() {
    if (currentIndex < widget.audioPaths.length - 1) {
      currentIndex++;
      setState(() {
        currentTrackTitle = widget.trackTitles[currentIndex];
        appBarTitle = currentTrackTitle;
      });
      _openAudio(currentIndex);
    } else {
      audioPlayer.stop();
    }
  }

  void _handleBackButton() {
    if (isAutoPlayEnabled) {
      isAutoPlayEnabled = false;
      audioPlayer.stop();
      Navigator.pop(context);
    } else {
      audioPlayer.stop();
      Navigator.pop(context);
    }
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
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              (backgroundImage == 'images/rain6_animation.gif' ||
                                      backgroundImage ==
                                          'images/islamic.jpeg' ||
                                      backgroundImage ==
                                          'images/kunang_animation.gif' ||
                                      backgroundImage ==
                                          'images/sakura2_animation.gif' ||
                                      backgroundImage ==
                                          'images/ombak_animation.gif' ||
                                      backgroundImage ==
                                          'images/night_animation.gif' ||
                                      backgroundImage ==
                                          'images/night4_animation.gif' ||
                                      backgroundImage ==
                                          'images/waterflow2_animation.gif' ||
                                      backgroundImage ==
                                          'images/motivasi_animation.gif' ||
                                      backgroundImage ==
                                          'images/park_animation.gif')
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
                        value:
                            audioPlayer.currentPosition.value.inMilliseconds /
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
                              color:
                                  (backgroundImage == 'images/rain6_animation.gif' ||
                                          backgroundImage ==
                                              'images/islamic.jpeg' ||
                                          backgroundImage ==
                                              'images/kunang_animation.gif' ||
                                          backgroundImage ==
                                              'images/sakura2_animation.gif' ||
                                          backgroundImage ==
                                              'images/ombak_animation.gif' ||
                                          backgroundImage ==
                                              'images/night_animation.gif' ||
                                          backgroundImage ==
                                              'images/night4_animation.gif' ||
                                          backgroundImage ==
                                              'images/waterflow2_animation.gif' ||
                                          backgroundImage ==
                                              'images/motivasi_animation.gif' ||
                                          backgroundImage ==
                                              'images/park_animation.gif')
                                      ? Colors.white
                                      : null,
                            ),
                          ),
                          Text(
                            '${audioPlayer.current.value!.audio.duration.inMinutes}:${(audioPlayer.current.value!.audio.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color:
                                  (backgroundImage == 'images/rain5_animation.gif' ||
                                          backgroundImage ==
                                              'images/islamic.jpeg' ||
                                          backgroundImage ==
                                              'images/kunang_animation.gif' ||
                                          backgroundImage ==
                                              'images/sakura_animation.gif' ||
                                          backgroundImage ==
                                              'images/ombak_animation.gif' ||
                                          backgroundImage ==
                                              'images/night_animation.gif' ||
                                          backgroundImage ==
                                              'images/night2_animation.gif' ||
                                          backgroundImage ==
                                              'images/waterflow2_animation.gif' ||
                                          backgroundImage ==
                                              'images/motivasi_animation.gif' ||
                                          backgroundImage ==
                                              'images/park_animation.gif')
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
          backgroundColor: iconColor ?? Color(0xFF04558F),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAudioControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircularIconButton(Icons.skip_previous, _skipPrevious),
        _buildCircularIconButton(
            isPlaying ? Icons.pause : Icons.play_arrow, _playPause),
        _buildCircularIconButton(Icons.skip_next, _skipNext),
        _buildCircularIconButton(
          Icons.refresh,
          _toggleAutoPlay,
          iconColor: isAutoPlayEnabled ? Color(0xFF04558F) : Colors.grey,
        ),
      ],
    );
  }
}
