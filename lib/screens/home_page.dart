import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:translator_app/providers/translate_provider.dart';

import '../components/choose_language.dart';
import '../components/translate_text.dart';
import '../components/list_translate.dart';
import '../components/translate_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TranslateProvider _translateProvider;
  final FocusNode _textFocusNode = FocusNode();
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  // Generate animations to enter the text to translate
  _onTextTouched(bool isTouched) {
    Tween tween = SizeTween(
      begin: const Size(0.0, kToolbarHeight),
      end: const Size(0.0, 0.0),
    );

    _animation = tween.animate(_controller);

    if (isTouched) {
      FocusScope.of(context).requestFocus(_textFocusNode);
      _controller.forward();
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      _controller.reverse();
    }

    _translateProvider.setIsTranslating(isTouched);
  }

  Widget _displaySuggestions() {
    if (_translateProvider.isTranslating) {
      return Container(
        color: Colors.black.withOpacity(0.4),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    _translateProvider = Provider.of<TranslateProvider>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text(widget.title),
          elevation: 0.0,
          centerTitle: true,
        ),
      ),
      body: Column(
        children: <Widget>[
          const ChooseLanguage(),
          Stack(
            children: <Widget>[
              Offstage(
                offstage: _translateProvider.isTranslating,
                child: TranslateText(
                  onTextTouched: _onTextTouched,
                ),
              ),
              Offstage(
                offstage: !_translateProvider.isTranslating,
                child: TranslateInput(
                  onCloseClicked: _onTextTouched,
                  focusNode: _textFocusNode,
                ),
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  // child: const ListTranslate(),
                ),
                _displaySuggestions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
