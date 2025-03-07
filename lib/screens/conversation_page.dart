import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:translator/translator.dart';

import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator_app/components/language_button.dart';
import 'package:translator_app/components/record_button.dart';
import 'package:translator_app/providers/translate_provider.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late TranslateProvider _translateProvider;
  final _speech = SpeechToText();
  late Timer _timer;
  String _talkNowTextLanguage1 = "";
  String _talkNowTextLanguage2 = "";
  String _textToTranslate = "";
  String _textTranslated = "";
  final GoogleTranslator _translator = GoogleTranslator();
  int _personTalkingIndex = 0;

  @override
  void initState() {
    super.initState();
    _initSpeechToText();
    _timer;
  }

  @override
  void deactivate() {
    _personTalkingIndex = -1;
    _timer.cancel();
    _speech.cancel();

    super.deactivate();
  }

  @override
  void dispose() {
    _personTalkingIndex = -1;
    _timer.cancel();
    _speech.cancel();

    super.dispose();
  }

  _startTimer() async {
    _timer.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      if (t.tick == 4 && t.isActive) {
        t.cancel();
        await _stopSpeech();

        if (_personTalkingIndex == 0) {
          setState(() {
            _personTalkingIndex = 1;
          });

          await _initSpeechToText();
        } else if (_personTalkingIndex == 1) {
          setState(() {
            _personTalkingIndex = 0;
          });

          await _initSpeechToText();
        }
      }

      if (t.isActive && _personTalkingIndex != -1 && !_speech.isListening) {
        await _initSpeechToText();
      }
    });
  }

  Future<void> _initSpeechToText() async {
    bool available = await _speech.initialize(
        onStatus: _statusListener, onError: _errorListener);

    if (available) {
      _startTimer();
      _speech.listen(
        onResult: _resultListener,
        localeId: _personTalkingIndex == 0
            ? _translateProvider.firstLanguage.code
            : _translateProvider.secondLanguage.code,
      );
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  _stopSpeech() async {
    // _timer.cancel();
    await _speech.stop();

    setState(() {
      _textToTranslate = "";
      _textTranslated = "";
    });
  }

  void _resultListener(SpeechRecognitionResult result) {
    if (!result.finalResult && _speech.lastStatus != "notListening") {
      _startTimer();
    }

    // Translate the text
    String firstLanguageCode = "";
    String secondLanguageCode = "";

    if (_personTalkingIndex == 0) {
      firstLanguageCode = _translateProvider.firstLanguage.code;
      secondLanguageCode = _translateProvider.secondLanguage.code;
    } else if (_personTalkingIndex == 1) {
      firstLanguageCode = _translateProvider.secondLanguage.code;
      secondLanguageCode = _translateProvider.firstLanguage.code;
    }

    _translator
        .translate(result.recognizedWords,
            from: firstLanguageCode, to: secondLanguageCode)
        .then((translatedText) {
      setState(() {
        _textTranslated = translatedText.toString();
      });
    });

    setState(() {
      _textToTranslate = result.recognizedWords;
    });
  }

  void _errorListener(SpeechRecognitionError error) {
    print("${error.errorMsg} - ${error.permanent}");
  }

  void _statusListener(String status) {
    print(status);
  }

  _initTalkNowText() {
    _translator
        .translate("Talk now...",
            from: 'en', to: _translateProvider.firstLanguage.code)
        .then((translatedText) {
      setState(() {
        _talkNowTextLanguage1 = translatedText.toString();
      });
    });

    _translator
        .translate("Talk now...",
            from: 'en', to: _translateProvider.secondLanguage.code)
        .then((translatedText) {
      setState(() {
        _talkNowTextLanguage2 = translatedText.toString();
      });
    });
  }

  String _displaysTextLanguage1() {
    if (_personTalkingIndex == 0) {
      if (_textToTranslate.isEmpty) {
        return _talkNowTextLanguage1;
      } else {
        return _textToTranslate;
      }
    } else if (_personTalkingIndex == 1) {
      if (_textTranslated.isEmpty) {
        return "";
      } else {
        return _textTranslated;
      }
    } else {
      return "";
    }
  }

  String _displaysTextLanguage2() {
    if (_personTalkingIndex == 0) {
      if (_textTranslated.isEmpty) {
        return "";
      } else {
        return _textTranslated;
      }
    } else if (_personTalkingIndex == 1) {
      if (_textToTranslate.isEmpty) {
        return _talkNowTextLanguage2;
      } else {
        return _textToTranslate;
      }
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    _translateProvider = Provider.of<TranslateProvider>(context, listen: true);

    if (_talkNowTextLanguage1.isEmpty || _talkNowTextLanguage2.isEmpty) {
      _initTalkNowText();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              margin:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Text(
                _displaysTextLanguage1(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          Expanded(
            child: Container(
              margin:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Text(
                _displaysTextLanguage2(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: SizedOverflowBox(
              size: const Size.fromHeight(70),
              child: RecordButton(
                isActive: _personTalkingIndex != -1,
                leftWidget: Expanded(
                  child: LanguageButton(
                    language: _translateProvider.firstLanguage.name,
                    direction: LanguageButtonDirection.left,
                    isSelected: _personTalkingIndex == 0,
                    onTap: () async {
                      await _stopSpeech();
                      setState(() {
                        _personTalkingIndex = 0;
                      });

                      await _initSpeechToText();
                    },
                  ),
                ),
                rightWidget: Expanded(
                  child: LanguageButton(
                    language: _translateProvider.secondLanguage.name,
                    direction: LanguageButtonDirection.right,
                    isSelected: _personTalkingIndex == 1,
                    onTap: () async {
                      await _stopSpeech();
                      setState(() {
                        _personTalkingIndex = 1;
                      });

                      await _initSpeechToText();
                    },
                  ),
                ),
                onClick: (bool isPressed) async {
                  if (isPressed) {
                    setState(() {
                      _personTalkingIndex = -1;
                    });

                    await _stopSpeech();
                  } else {
                    setState(() {
                      _personTalkingIndex = 0;
                    });

                    await _initSpeechToText();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
