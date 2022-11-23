import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


String url = 'https://flutter.dev/';

class DataWidget extends StatefulWidget {
  const DataWidget(this._controller, this.webViewReady, {Key? key})
      : super(key: key);

  final WebViewController? _controller;
  final bool webViewReady;
  @override
  State<DataWidget> createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  WebViewController? _controller;
  TextEditingController _controllerUrl = TextEditingController();
  final styleBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(40.0),
    borderSide: BorderSide(
      color: Colors.grey[300] ?? Colors.grey,
    ),
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      _controllerUrl.text = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller = widget._controller;
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          FutureBuilder(
            future: _goBackCheck(),
            builder: (BuildContext context, AsyncSnapshot snapshotAsync) {
              return IconButton(
                onPressed: !widget.webViewReady || !snapshotAsync.data
                    ? null
                    : _goBack,
                icon: Icon(Icons.arrow_back),
              );
            },
          ),
          FutureBuilder(
            future: _goForwardCheck(),
            builder: (BuildContext context, AsyncSnapshot snapshotAsync) {
              return IconButton(
                onPressed: !widget.webViewReady || !snapshotAsync.data
                    ? null
                    : _goForward,
                icon: Icon(Icons.arrow_forward),
              );
            },
          ),
          !widget.webViewReady
              ? IconButton(
                  onPressed: _stop,
                  icon: Icon(Icons.stop),
                )
              : IconButton(
                  onPressed: _loadUrl,
                  icon: Icon(Icons.refresh),
                ),
          Expanded(
            child: TextField(
              controller: _controllerUrl,
              obscureText: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Введите url',
                focusedBorder: styleBorder,
                enabledBorder: styleBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _goBackCheck() async {
    return await _controller!.canGoBack();
  }

  void _goBack() {
    _controller?.goBack();
  }

  void _goForward() {
    _controller?.goForward();
  }

  Future<bool> _goForwardCheck() async {
    return await _controller!.canGoForward();
  }

  void _loadUrl() {
    _controller?.loadUrl(_controllerUrl.text);
  }

  void _stop() {
    _controller?.reload();
  }
}