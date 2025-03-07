import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:translator_app/providers/translate_provider.dart';
import 'package:translator_app/screens/conversation_page.dart';
import 'package:translator_app/screens/record_page.dart';

import 'action_button.dart';

class TranslateText extends StatefulWidget {
  const TranslateText({
    Key? key,
    required this.onTextTouched,
  }) : super(key: key);

  final Function(bool) onTextTouched;

  @override
  _TranslateTextState createState() => _TranslateTextState();
}

class _TranslateTextState extends State<TranslateText> {
  late TranslateProvider _translateProvider;

  @override
  Widget build(BuildContext context) {
    _translateProvider = Provider.of<TranslateProvider>(context, listen: true);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(0.0),
      elevation: 2.0,
      child: SizedBox(
        height: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  widget.onTextTouched(true);
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Text(
                    "Enter text",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ActionButton(
                  icon: Icons.camera_rounded,
                  text: "Camera",
                  onClick: () {},
                  imageIcon: const AssetImage("assets/pen.png"),
                ),
                ActionButton(
                  imageIcon: const AssetImage("assets/pen.png"),
                  text: "Handwriting",
                  icon: Icons.edit_note_rounded,
                  onClick: () {},
                ),
                ActionButton(
                  imageIcon: const AssetImage("assets/conversation.png"),
                  text: "Conversation",
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConversationPage(),
                      ),
                    );
                  },
                  icon: Icons.speaker_phone_rounded,
                ),
                ActionButton(
                  onClick: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecordPage(),
                      ),
                    );

                    if (result != null && result != "") {
                      _translateProvider.setTextToTranslate(result);
                      _translateProvider.setIsTranslating(true);
                    }
                  },
                  icon: Icons.keyboard_voice,
                  text: "Voice",
                  imageIcon: const AssetImage("assets/conversation.png"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
