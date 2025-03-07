import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:translator_app/providers/translate_provider.dart';

import '../screens/language_page.dart';

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({Key? key}) : super(key: key);

  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  late TranslateProvider _translateProvider;

  // Switch the first and the second language
  void _switchLanguage() {
    _translateProvider.changeLanguages(
        _translateProvider.secondLanguage, _translateProvider.firstLanguage);
  }

  // Choose a new first language
  void _chooseFirstLanguage(String title, bool isAutomaticEnabled) async {
    final language = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LanguagePage(
          title: title,
          isAutomaticEnabled: isAutomaticEnabled,
        ),
      ),
    );

    if (language != null) {
      _translateProvider.changeLanguages(
          language, _translateProvider.secondLanguage);
    }
  }

  // Choose a new second language
  void _chooseSecondLanguage(String title, bool isAutomaticEnabled) async {
    final language = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LanguagePage(
          title: title,
          isAutomaticEnabled: isAutomaticEnabled,
        ),
      ),
    );

    if (language != null) {
      if (language != null) {
        _translateProvider.changeLanguages(
            _translateProvider.firstLanguage, language);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _translateProvider = Provider.of<TranslateProvider>(context, listen: true);

    return Container(
      height: 55.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.grey,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  _chooseFirstLanguage("Translate from", true);
                },
                child: Center(
                  child: Text(
                    _translateProvider.firstLanguage.name,
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: IconButton(
              icon: Icon(
                Icons.compare_arrows,
                color: Colors.grey[700],
              ),
              onPressed: _switchLanguage,
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  _chooseSecondLanguage("Translate to", false);
                },
                child: Center(
                  child: Text(
                    _translateProvider.secondLanguage.name,
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
