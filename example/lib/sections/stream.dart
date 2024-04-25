import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class SectionTextStreamInput extends StatefulWidget {
  const SectionTextStreamInput({super.key});

  @override
  State<SectionTextStreamInput> createState() => _SectionTextInputStreamState();
}

enum TtsState { playing, stopped, paused, continued }

// class SectionTextStreamInput extends StatefulWidget {
//   SectionTextStreamInput({required Key key, required this.title})
//       : super(key: key);
//   final String title;

//   @override
//   _SectionTextStreamInput createState() => _SectionTextStreamInput();
// }

class _SectionTextInputStreamState extends State<SectionTextStreamInput> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: Text(
                'Extract all text',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _extractAllText,
            ),
            TextButton(
              child: Text(
                'Extract text with predefined bounds',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _extractTextWithBounds,
            ),
            TextButton(
              child: Text(
                'Extract text from a specific page',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _extractTextFromSpecificPage,
            ),
            TextButton(
              child: Text(
                'Extract text from a range of pages',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _extractTextFromRangeOfPage,
            ),
            TextButton(
              child: Text(
                'Extract text with font and style information',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _extractTextWithFontAndStyleInformation,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _extractAllText() async {
    //Load the existing PDF document.
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData('pdf_succinctly.pdf'));

    //Create the new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract all the text from the document.
    String text = extractor.extractText();

    //Display the text.
    _showResult(text);
  }

  Future<void> _extractTextWithBounds() async {
    //Load the existing PDF document.
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData('invoice.pdf'));

    //Create the new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract all the text from the particular page.
    List<TextLine> result = extractor.extractTextLines(startPageIndex: 0);

    //Predefined bound.
    Rect textBounds = Rect.fromLTWH(474, 161, 50, 9);

    String invoiceNumber = '';

    for (int i = 0; i < result.length; i++) {
      List<TextWord> wordCollection = result[i].wordCollection;
      for (int j = 0; j < wordCollection.length; j++) {
        if (textBounds.overlaps(wordCollection[j].bounds)) {
          invoiceNumber = wordCollection[j].text;
          break;
        }
      }
      if (invoiceNumber != '') {
        break;
      }
    }

    //Display the text.
    _showResult(invoiceNumber);
  }

  Future<void> _extractTextFromSpecificPage() async {
    //Load the existing PDF document.
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData('pdf_succinctly.pdf'));

    //Create the new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract all the text from the first page of the PDF document.
    String text = extractor.extractText(startPageIndex: 2);

    //Display the text.
    _showResult(text);
  }

  Future<void> _extractTextFromRangeOfPage() async {
    //Load the existing PDF document.
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData('pdf_succinctly.pdf'));

    //Create the new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract all the text from the first page to 3rd page of the PDF document.
    String text = extractor.extractText(startPageIndex: 0, endPageIndex: 2);

    //Display the text.
    _showResult(text);
  }

  Future<void> _extractTextWithFontAndStyleInformation() async {
    //Load the existing PDF document.
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData('invoice.pdf'));

    //Create the new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract all the text from specific page.
    List<TextLine> result = extractor.extractTextLines(startPageIndex: 0);

    //Draw rectangle..
    for (int i = 0; i < result.length; i++) {
      List<TextWord> wordCollection = result[i].wordCollection;
      for (int j = 0; j < wordCollection.length; j++) {
        if ('2058557939' == wordCollection[j].text) {
          //Get the font name.
          String fontName = wordCollection[j].fontName;
          //Get the font size.
          double fontSize = wordCollection[j].fontSize;
          //Get the font style.
          List<PdfFontStyle> fontStyle = wordCollection[j].fontStyle;
          //Get the text.
          String text = wordCollection[j].text;
          String fontStyleText = '';
          for (int i = 0; i < fontStyle.length; i++) {
            fontStyleText += fontStyle[i].toString() + ' ';
          }
          fontStyleText = fontStyleText.replaceAll('PdfFontStyle.', '');
          _showResult(
              'Text : $text \r\n Font Name: $fontName \r\n Font Size: $fontSize \r\n Font Style: $fontStyleText');
          break;
        }
      }
    }
    //Dispose the document.
    document.dispose();
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  void _showResult(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Extracted text'),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Text(text),
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
              ),
            ),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:friday/widgets/chat_input_box.dart';
// import 'package:friday/widgets/item_image_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';

// class SectionTextStreamInput extends StatefulWidget {
//   const SectionTextStreamInput({super.key});

//   @override
//   State<SectionTextStreamInput> createState() => _SectionTextInputStreamState();
// }

// enum TtsState { playing, stopped, paused, continued }

// class _SectionTextInputStreamState extends State<SectionTextStreamInput> {
//   final ImagePicker picker = ImagePicker();
//   final controller = TextEditingController();
//   final gemini = Gemini.instance;
//   String? searchedText,
//       // result,
//       _finishReason;

//   List<Uint8List>? images;

//   String? get finishReason => _finishReason;

//   set finishReason(String? set) {
//     if (set != _finishReason) {
//       setState(() => _finishReason = set);
//     }
//   }

// //new code start

//   bool _loading = false;

//   bool get loading => _loading;

//   late FlutterTts flutterTts;
//   String? language;
//   String? engine;
//   double volume = 0.5;
//   double pitch = 1.0;
//   double rate = 0.5;
//   bool isCurrentLanguageInstalled = false;

//   String? _newVoiceText;
//   int? _inputLength;

//   TtsState ttsState = TtsState.stopped;

//   bool get isPlaying => ttsState == TtsState.playing;
//   bool get isStopped => ttsState == TtsState.stopped;
//   bool get isPaused => ttsState == TtsState.paused;
//   bool get isContinued => ttsState == TtsState.continued;

//   bool get isIOS => !kIsWeb && Platform.isIOS;
//   bool get isAndroid => !kIsWeb && Platform.isAndroid;
//   bool get isWindows => !kIsWeb && Platform.isWindows;
//   bool get isWeb => kIsWeb;

//   @override
//   initState() {
//     super.initState();
//     initTts();
//   }

//   dynamic initTts() {
//     flutterTts = FlutterTts();

//     _setAwaitOptions();

//     if (isAndroid) {
//       _getDefaultEngine();
//       _getDefaultVoice();
//     }

//     flutterTts.setStartHandler(() {
//       setState(() {
//         print("Playing");
//         ttsState = TtsState.playing;
//       });
//     });

//     flutterTts.setCompletionHandler(() {
//       setState(() {
//         print("Complete");
//         ttsState = TtsState.stopped;
//       });
//     });

//     flutterTts.setCancelHandler(() {
//       setState(() {
//         print("Cancel");
//         ttsState = TtsState.stopped;
//       });
//     });

//     flutterTts.setPauseHandler(() {
//       setState(() {
//         print("Paused");
//         ttsState = TtsState.paused;
//       });
//     });

//     flutterTts.setContinueHandler(() {
//       setState(() {
//         print("Continued");
//         ttsState = TtsState.continued;
//       });
//     });

//     flutterTts.setErrorHandler((msg) {
//       setState(() {
//         print("error: $msg");
//         ttsState = TtsState.stopped;
//       });
//     });
//   }

//   Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

//   Future<dynamic> _getEngines() async => await flutterTts.getEngines;

//   Future<void> _getDefaultEngine() async {
//     var engine = await flutterTts.getDefaultEngine;
//     if (engine != null) {
//       print(engine);
//     }
//   }

//   Future<void> _getDefaultVoice() async {
//     var voice = await flutterTts.getDefaultVoice;
//     if (voice != null) {
//       print(voice);
//     }
//   }

//   Future<void> _speak() async {
//     await flutterTts.setVolume(volume);
//     await flutterTts.setSpeechRate(rate);
//     await flutterTts.setPitch(pitch);

//     if (_newVoiceText != null) {
//       if (_newVoiceText!.isNotEmpty) {
//         await flutterTts.speak(_newVoiceText!);
//       }
//     }
//   }

//   Future<void> _setAwaitOptions() async {
//     await flutterTts.awaitSpeakCompletion(true);
//   }

//   Future<void> _stop() async {
//     var result = await flutterTts.stop();
//     if (result == 1) setState(() => ttsState = TtsState.stopped);
//   }

//   Future<void> _pause() async {
//     var result = await flutterTts.pause();
//     if (result == 1) setState(() => ttsState = TtsState.paused);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     flutterTts.stop();
//   }

//   List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(
//       List<dynamic> engines) {
//     var items = <DropdownMenuItem<String>>[];
//     for (dynamic type in engines) {
//       items.add(DropdownMenuItem(
//           value: type as String?, child: Text((type as String))));
//     }
//     return items;
//   }

//   void changedEnginesDropDownItem(String? selectedEngine) async {
//     await flutterTts.setEngine(selectedEngine!);
//     language = null;
//     setState(() {
//       engine = selectedEngine;
//     });
//   }

//   List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
//       List<dynamic> languages) {
//     var items = <DropdownMenuItem<String>>[];
//     for (dynamic type in languages) {
//       items.add(DropdownMenuItem(
//           value: type as String?, child: Text((type as String))));
//     }
//     return items;
//   }

//   void changedLanguageDropDownItem(String? selectedType) {
//     setState(() {
//       language = selectedType;
//       flutterTts.setLanguage(language!);
//       if (isAndroid) {
//         flutterTts
//             .isLanguageInstalled(language!)
//             .then((value) => isCurrentLanguageInstalled = (value as bool));
//       }
//     });
//   }

//   void _onChange(String text) {
//     setState(() {
//       // Set the searched text
//       searchedText = text;
//     });

//     // Clear previous response
//     setState(() {
//       _newVoiceText = null;
//     });

//     // Request AI to generate content
//     gemini.streamGenerateContent(text, images: images).listen((value) {
//       // Set the generated response to be spoken
//       setState(() {
//         _newVoiceText = value.output;
//       });

//       // Speak the new response
//       _speak();

//       // Handle finish reason if necessary
//       if (value.finishReason != 'STOP') {
//         setState(() {
//           finishReason = 'Finish reason is `RECITATION`';
//         });
//       }
//     }).onError((e) {
//       log('streamGenerateContent error', error: e);
//     });
//   }

//   set loading(bool set) => setState(() => _loading = set);
//   final List<Content> chats = [];

//   Widget _engineSection() {
//     if (isAndroid) {
//       return FutureBuilder<dynamic>(
//           future: _getEngines(),
//           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//             if (snapshot.hasData) {
//               return _enginesDropDownSection(snapshot.data as List<dynamic>);
//             } else if (snapshot.hasError) {
//               return Text('Error loading engines...');
//             } else
//               return Text('Loading engines...');
//           });
//     } else
//       return Container(width: 0, height: 0);
//   }

//   Widget _futureBuilder() => FutureBuilder<dynamic>(
//       future: _getLanguages(),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         if (snapshot.hasData) {
//           return _languageDropDownSection(snapshot.data as List<dynamic>);
//         } else if (snapshot.hasError) {
//           return Text('Error loading languages...');
//         } else
//           return Text('Loading Languages...');
//       });

//   Widget _inputSection() => Container(
//       alignment: Alignment.topCenter,
//       padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
//       child: TextField(
//         maxLines: 11,
//         minLines: 6,
//         onChanged: (String value) {
//           _onChange(value);
//         },
//       ));

//   Widget _btnSection() {
//     return Container(
//       padding: EdgeInsets.only(top: 50.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildButtonColumn(Colors.green, Colors.greenAccent, Icons.play_arrow,
//               'PLAY', _speak),
//           _buildButtonColumn(
//               Colors.red, Colors.redAccent, Icons.stop, 'STOP', _stop),
//           _buildButtonColumn(
//               Colors.blue, Colors.blueAccent, Icons.pause, 'PAUSE', _pause),
//         ],
//       ),
//     );
//   }

//   Widget _enginesDropDownSection(List<dynamic> engines) => Container(
//         padding: EdgeInsets.only(top: 50.0),
//         child: DropdownButton(
//           value: engine,
//           items: getEnginesDropDownMenuItems(engines),
//           onChanged: changedEnginesDropDownItem,
//         ),
//       );

//   Widget _languageDropDownSection(List<dynamic> languages) => Container(
//       padding: EdgeInsets.only(top: 10.0),
//       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         DropdownButton(
//           value: language,
//           items: getLanguageDropDownMenuItems(languages),
//           onChanged: changedLanguageDropDownItem,
//         ),
//         Visibility(
//           visible: isAndroid,
//           child: Text("Is installed: $isCurrentLanguageInstalled"),
//         ),
//       ]));

//   Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
//       String label, Function func) {
//     return Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//               icon: Icon(icon),
//               color: color,
//               splashColor: splashColor,
//               onPressed: () => func()),
//           Container(
//               margin: const EdgeInsets.only(top: 8.0),
//               child: Text(label,
//                   style: TextStyle(
//                       fontSize: 12.0,
//                       fontWeight: FontWeight.w400,
//                       color: color)))
//         ]);
//   }

//   Widget _getMaxSpeechInputLengthSection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//           child: Text('Get max speech input length'),
//           onPressed: () async {
//             _inputLength = await flutterTts.getMaxSpeechInputLength;
//             setState(() {});
//           },
//         ),
//         Text("$_inputLength characters"),
//       ],
//     );
//   }

//   Widget _buildSliders() {
//     return Column(
//       children: [_volume(), _pitch(), _rate()],
//     );
//   }

//   Widget _volume() {
//     return Slider(
//         value: volume,
//         onChanged: (newVolume) {
//           setState(() => volume = newVolume);
//         },
//         min: 0.0,
//         max: 1.0,
//         divisions: 10,
//         label: "Volume: $volume");
//   }

//   Widget _pitch() {
//     return Slider(
//       value: pitch,
//       onChanged: (newPitch) {
//         setState(() => pitch = newPitch);
//       },
//       min: 0.5,
//       max: 2.0,
//       divisions: 15,
//       label: "Pitch: $pitch",
//       activeColor: Colors.red,
//     );
//   }

//   Widget _rate() {
//     return Slider(
//       value: rate,
//       onChanged: (newRate) {
//         setState(() => rate = newRate);
//       },
//       min: 0.0,
//       max: 1.0,
//       divisions: 10,
//       label: "Rate: $rate",
//       activeColor: Colors.green,
//     );
//   }

// // new code ends

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _inputSection(),
//         _btnSection(),
//         _engineSection(),
//         _futureBuilder(),
//         _buildSliders(),

//         if (searchedText != null)
//           MaterialButton(
//               color: Colors.blue.shade700,
//               onPressed: () {
//                 setState(() {
//                   searchedText = null;
//                   finishReason = null;
//                   // result = null;
//                 });
//               },
//               child: Text('search: $searchedText')),
//         Expanded(child: GeminiResponseTypeView(
//           builder: (context, child, response, loading) {
//             if (loading) {
//               return Lottie.asset('assets/lottie/ai.json');
//             }

//             if (response != null) {
//               print(response);
//               return Markdown(
//                 data: response,
//                 selectable: true,
//               );
//             } else {
//               return const Center(child: Text('input diet image!'));
//             }
//           },
//         )),

//         /// if the returned finishReason isn't STOP
//         if (finishReason != null) Text(finishReason!),

//         if (images != null)
//           Container(
//             height: 120,
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             alignment: Alignment.centerLeft,
//             child: Card(
//               child: ListView.builder(
//                 itemBuilder: (context, index) => ItemImageView(
//                   bytes: images!.elementAt(index),
//                 ),
//                 itemCount: images!.length,
//                 scrollDirection: Axis.horizontal,
//               ),
//             ),
//           ),

//         /// imported from local widgets
//         ChatInputBox(
//           controller: controller,
//           onClickCamera: () {
//             picker.pickMultiImage().then((value) async {
//               final imagesBytes = <Uint8List>[];
//               for (final file in value) {
//                 imagesBytes.add(await file.readAsBytes());
//               }

//               if (imagesBytes.isNotEmpty) {
//                 setState(() {
//                   images = imagesBytes;
//                 });
//               }
//             });
//           },
//           onSend: () {
//             if (controller.text.isNotEmpty) {
//               searchedText = controller.text;
//               controller.clear();
//               gemini
//                   .streamGenerateContent(searchedText!, images: images)
//                   .listen((value) {
//                 setState(() {
//                   images = null;
//                 });
//                 // result = (result ?? '') + (value.output ?? '');

//                 if (value.finishReason != 'STOP') {
//                   finishReason = 'Finish reason is `RECITATION`';
//                 }
//               }).onError((e) {
//                 log('streamGenerateContent error', error: e);
//               });
//             }
//           },
//         )
//       ],
//     );
//   }
// }
