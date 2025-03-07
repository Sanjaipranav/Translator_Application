import 'package:flutter/material.dart';

import '../models/language.dart';

class LanguageListElement extends StatefulWidget {
  const LanguageListElement(
      {Key? key, required this.language, required this.onSelect})
      : super(key: key);

  final Language language;
  final Function(Language) onSelect;

  @override
  _LanguageListElementState createState() => _LanguageListElementState();
}

class _LanguageListElementState extends State<LanguageListElement> {
  Widget? _displayTrailingIcon() {
    if (widget.language.isDownloadable) {
      if (widget.language.isDownloaded) {
        return const Icon(Icons.check_circle);
      } else {
        return const Icon(Icons.file_download);
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.language.name),
      trailing: _displayTrailingIcon(),
      onTap: () {
        widget.onSelect(widget.language);
      },
    );
  }
}
