import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import 'package:translator_app/providers/translate_provider.dart';

class TranslateInput extends StatefulWidget {
  const TranslateInput({
    Key? key,
    required this.onCloseClicked,
    required this.focusNode,
  }) : super(key: key);

  final Function(bool) onCloseClicked;
  final FocusNode focusNode;

  @override
  _TranslateInputState createState() => _TranslateInputState();
}

class _TranslateInputState extends State<TranslateInput> {
  late TranslateProvider _translateProvider;
  final TextEditingController _textEditingController = TextEditingController();
  String _textTranslated = "";
  final GoogleTranslator _translator = GoogleTranslator();

  _onTextChanged(String text) {
    if (text.isNotEmpty) {
      _translateProvider.setTextToTranslate(text);
      _translatingText(text);
    } else {
      _translateProvider.setTextToTranslate("");
      setState(() {
        _textTranslated = "";
      });
    }
  }

  _translatingText(String text) {
    if (text.isNotEmpty) {
      _translator
          .translate(text,
              from: _translateProvider.firstLanguage.code,
              to: _translateProvider.secondLanguage.code)
          .then((translatedText) {
        if (translatedText != _textTranslated) {
          setState(() {
            _textTranslated = translatedText.toString();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _translateProvider = Provider.of<TranslateProvider>(context, listen: true);
    _textEditingController.text = _translateProvider.textToTranslate;
    _translatingText(_textEditingController.text);

    return Container(
      height: 300.0,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: TextField(
                focusNode: widget.focusNode,
                controller: _textEditingController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: _onTextChanged,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: SizedBox(
                    width: 30,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: RawMaterialButton(
                        onPressed: () {
                          if (_textEditingController.text != "") {
                            setState(() {
                              _translateProvider.setTextToTranslate("");
                              _textEditingController.clear();
                              _textTranslated = "";
                            });
                          } else {
                            widget.onCloseClicked(false);
                          }
                        },
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  _textTranslated,
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
