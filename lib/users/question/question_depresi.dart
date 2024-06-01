import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mentalsehat/users/answer/user_answer.dart';
import 'package:mentalsehat/users/answer/user_question.dart';
import 'package:mentalsehat/users/results/depresiDiagnosis_results.dart';

class QuestionDepresi extends StatefulWidget {
  const QuestionDepresi({super.key});

  @override
  State<QuestionDepresi> createState() => _QuestionDepresiState();
}

class _QuestionDepresiState extends State<QuestionDepresi> {
 int _currentQuestion = 1;
  int _totalQuestions = 14;
  String? _currentQuestionText;
  Map<int, int?> _selectedAnswers = {};
  List<UserAnswer> userAnswers = [];

  AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();
  bool _audioPlayed = false;
  bool _audioPaused = false;

  List<YourQuestion> yourQuestionList = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
     _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        // Handle connectivity changes here if needed
        setState(() {}); // Trigger rebuild when connectivity changes
      },
    );
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Gejala')
          .doc('Depresi')
          .collection('Depresi')
          .orderBy('kode')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _totalQuestions = querySnapshot.docs.length;
          yourQuestionList = querySnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            String questionCode = doc.id;
            String question = data['nama'] ?? '';
            List<String> options = [
              'Tidak Pernah',
              'Kadang-kadang',
              'Cukup Sering',
              'Sangat Sering'
            ];
            return YourQuestion(
                questionCode: questionCode,
                question: question,
                options: options);
          }).toList();
        });

        _loadQuestion();
      } else {
        print('Tidak ada dokumen ditemukan dalam koleksi.');
      }
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  Future<void> _loadQuestion() async {
    var currentQuestion = yourQuestionList[_currentQuestion - 1];

    setState(() {
      _currentQuestionText = currentQuestion.question;
    });
  }

  void _playAudio() {
    _audioPlayer.open(
      Audio('assets/audios/relaksasi.mp3'),
      autoStart: true,
      showNotification: true,
    );
    _audioPlayed = true;
  }

  void _toggleAudio() {
    if (_audioPlayed && !_audioPaused) {
      _audioPlayer.pause();
      setState(() {
        _audioPaused = true;
      });
    } else {
      _audioPlayer.play();
      setState(() {
        _audioPaused = false;
      });
    }
  }

  void _selectAnswer(int answer) {
    var currentQuestion = yourQuestionList[_currentQuestion - 1];
    var selectedAnswer = currentQuestion.options[answer];

    setState(() {
      _selectedAnswers[_currentQuestion] = answer;
      saveUserAnswer(currentQuestion.questionCode, selectedAnswer);
    });
  }

  void saveUserAnswer(String questionCode, String selectedAnswer) {
    var existingAnswerIndex =
        userAnswers.indexWhere((answer) => answer.questionCode == questionCode);

    if (existingAnswerIndex != -1) {
      userAnswers[existingAnswerIndex] = UserAnswer(
          questionCode: questionCode,
          question: yourQuestionList
              .firstWhere((q) => q.questionCode == questionCode)
              .question,
          answer: selectedAnswer);
    } else {
      userAnswers.add(UserAnswer(
          questionCode: questionCode,
          question: yourQuestionList
              .firstWhere((q) => q.questionCode == questionCode)
              .question,
          answer: selectedAnswer));
    }
  }

  void _printSelectedAnswers() {
    userAnswers.forEach((userAnswer) {
      print('${userAnswer.question}: ${userAnswer.answer}');
    });
  }

  void _showResultPage() {
    if (_selectedAnswers[_currentQuestion] == null) {
      //
    } else {
      _audioPlayer.stop();
      int totalScore = 0;
      for (int i = 1; i <= _totalQuestions; i++) {
        totalScore += _selectedAnswers[i] ?? 0;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DepresiDiagnosisResults(
            totalScore: totalScore,
            userAnswers: userAnswers,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivity.onConnectivityChanged,
      initialData: ConnectivityResult.mobile,
      builder: (context, snapshot) {
        if (snapshot.data == ConnectivityResult.none) {
          // Tidak ada koneksi internet
          return _buildNoInternet();
        } else {
          // Terdapat koneksi internet
          return accessDiagnosis();
        }
      },
    );
  }

  Widget _buildNoInternet() {
    _audioPlayer.pause();
    _audioPlayed = false;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              color: Colors.orange,
              size: 60,
            ),
            SizedBox(height: 8),
            Image.asset(
              'images/noInternet.png',
              width: 200,
              height: 200,
            ),
            Text(
              "Oops!",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Sepertinya sambungan anda telah terputus",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Silahkan cek kembali koneksi internet anda",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget accessDiagnosis() {
    if (!_audioPlayed) {
      _playAudio();
      _audioPlayed = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diagnosa Depresi',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_audioPaused ? Icons.volume_off : Icons.volume_up),
            onPressed: _toggleAudio,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: _currentQuestion / _totalQuestions,
                color: Color(0xFF04558F),
                backgroundColor: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                '$_currentQuestion/$_totalQuestions',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '$_currentQuestionText',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _selectAnswer(0); // Jawaban "Tidak Pernah" dengan nilai 0
                  _printSelectedAnswers();
                },
                style: ElevatedButton.styleFrom(
                  primary: _selectedAnswers[_currentQuestion] == 0
                      ? Color(0xFF04558F)
                      : Colors.white70,
                       minimumSize: Size(double.infinity, 65),
                       side: BorderSide(color: Colors.black),
                ),
                child: Text(
                  'Tidak pernah',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: _selectedAnswers[_currentQuestion] == 0
                        ? Colors.white
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _selectAnswer(1); // Jawaban "Kadang-kadang" dengan nilai 1
                  _printSelectedAnswers();
                },
                style: ElevatedButton.styleFrom(
                  primary: _selectedAnswers[_currentQuestion] == 1
                      ? Color(0xFF04558F)
                     : Colors.white70,
                      minimumSize: Size(double.infinity, 65),
                      side: BorderSide(color: Colors.black),
                ),
                child: Text(
                  'Kadang-kadang',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: _selectedAnswers[_currentQuestion] == 1
                        ? Colors.white
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _selectAnswer(2); // Jawaban "Cukup sering" dengan nilai 2
                  _printSelectedAnswers();
                },
                style: ElevatedButton.styleFrom(
                  primary: _selectedAnswers[_currentQuestion] == 2
                      ? Color(0xFF04558F)
                      : Colors.white70,
                      minimumSize: Size(double.infinity, 65),
                  side: BorderSide(color: Colors.black),
                ),
                child: Text(
                  'Cukup sering',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: _selectedAnswers[_currentQuestion] == 2
                        ? Colors.white
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _selectAnswer(3); // Jawaban "Sangat sering" dengan nilai 3
                  _printSelectedAnswers();
                },
                style: ElevatedButton.styleFrom(
                  primary: _selectedAnswers[_currentQuestion] == 3
                      ? Color(0xFF04558F)
                      : Colors.white70,
                      minimumSize: Size(double.infinity, 65),
                  side: BorderSide(color: Colors.black),
                ),
                child: Text(
                  'Sangat sering',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: _selectedAnswers[_currentQuestion] == 3
                        ? Colors.white
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: _currentQuestion > 1
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        children: [
          if (_currentQuestion > 1)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 32.0),
              child: FloatingActionButton(
                heroTag: "backButton",
                onPressed: () {
                  setState(() {
                    _currentQuestion--;
                    _loadQuestion();
                  });
                },
                child: Icon(Icons.arrow_back),
                backgroundColor: Color(0xFF04558F),
                foregroundColor: Colors.white,
                shape: CircleBorder(),
              ),
            ),
          FloatingActionButton(
            heroTag: "nextButton",
            onPressed: _selectedAnswers[_currentQuestion] == null
                ? null // nonaktifkan tombol jika belum menjawab
                : () {
                    setState(() {
                      if (_currentQuestion < _totalQuestions) {
                        _currentQuestion++;
                        _loadQuestion();
                      } else {
                        _showResultPage();
                      }
                    });
                  },
            child: Icon(Icons.arrow_forward),
            backgroundColor: _selectedAnswers[_currentQuestion] == null
                ? Colors.grey // warna tombol abu-abu jika belum menjawab
                : Color(0xFF04558F), // warna tombol biru jika sudah menjawab
            foregroundColor: Colors.white,
            shape: CircleBorder(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
