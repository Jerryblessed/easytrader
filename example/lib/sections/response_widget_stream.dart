import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';

/// The [main] function is the entry point of the application
// void main() {
//   /// Call the runApp function to start the app
//   runApp(const MyApp());
// }

class ResponseWidgetSection extends StatefulWidget {
  const ResponseWidgetSection({super.key});

  @override
  State<ResponseWidgetSection> createState() => _SectionTextInputStreamState();
}

class _SectionTextInputStreamState extends State<ResponseWidgetSection> {
  final controller = TextEditingController();
  String? searchedText, result, _finishReason;
  bool _loading = false;

  String? get finishReason => _finishReason;
  bool get loading => _loading;

  set finishReason(String? set) {
    if (set != _finishReason) {
      setState(() => _finishReason = set);
    }
  }

  set loading(bool set) {
    if (set != loading) {
      setState(() => _loading = set);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// Set the app theme to use Material 3
      theme: ThemeData(
        useMaterial3: true,
      ),

      /// Set the app home page to be the Test widget
      home: const Test(title: 'Stable diffusion'),
    );
  }
}

/// The [Test] widget.
class Test extends StatefulWidget {
  /// The title of the widget.
  final String title;

  const Test({Key? key, required this.title}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

/// The [_TestState] widget.
class _TestState extends State<Test> {
  /// The text editing controller for the query.
  final TextEditingController _queryController = TextEditingController();

  /// Initializes the [StabilityAI] class from the 'brain_fusion' package.
  final StabilityAI _ai = StabilityAI();

  /// This is the api key from stability.ai or https://dreamstudio.ai/, Create yours and replace it here.
  final String apiKey = 'sk-Zc8rU2zrNJA0UzcV34fss0J2az2k3TVdYGwJUpGcuPHhJmZp';

  /// This is the style [ImageAIStyle]
  final ImageAIStyle imageAIStyle = ImageAIStyle.christmas;

  /// The boolean value to run the function.
  bool run = false;

  /// The [_generate] function to generate image data.
  Future<Uint8List> _generate(String query) async {
    /// Call the generateImage method with the required parameters.
    Uint8List image = await _ai.generateImage(
      apiKey: apiKey,
      imageAIStyle: imageAIStyle,
      prompt: query,
    );
    return image;
  }

  @override
  void dispose() {
    /// Dispose the [_queryController].
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// The size of the container for the generated image.
    final double size = Platform.isAndroid || Platform.isIOS
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height / 2;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Colors.grey.shade300,
                  ),
                ),
                child: TextField(
                  controller: _queryController,
                  decoration: InputDecoration(
                    hintText: 'Enter query text...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 8),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: size,
                  width: size,
                  child: run
                      ? FutureBuilder<Uint8List>(
                          /// Call the [_generate] function to get the image data.
                          future: _generate(_queryController.text),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              /// While waiting for the image data, display a loading indicator.
                              return Center(
                                child: const CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              /// If an error occurred while getting the image data, display an error message.
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              /// If the image data is available, display the image using Image.memory().
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(snapshot.data!),
                              );
                            } else {
                              /// If no data is available, display a placeholder or an empty container.
                              return Container();
                            }
                          },
                        )
                      : const Center(
                          child: Text(
                            'Enter Text and Click the button to generate',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /// Get the user input from the [_queryController].
          String query = _queryController.text;
          if (query.isNotEmpty) {
            /// If the user input is not empty, set [run] to true to generate the image.
            setState(() {
              run = true;
            });
          } else {
            /// If the user input is empty, print an error message.
            if (kDebugMode) {
              print('Query is empty !!');
            }
          }
        },
        tooltip: 'Generate',
        child: const Icon(Icons.gesture),
      ),
    );
  }
}


// import 'package:friday/widgets/chat_input_box.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:lottie/lottie.dart';

// class ResponseWidgetSection extends StatefulWidget {
//   const ResponseWidgetSection({super.key});

//   @override
//   State<ResponseWidgetSection> createState() => _SectionTextInputStreamState();
// }

// class _SectionTextInputStreamState extends State<ResponseWidgetSection> {
//   final controller = TextEditingController();
//   final gemini = Gemini.instance;
//   String? searchedText, result, _finishReason;
//   bool _loading = false;

//   String? get finishReason => _finishReason;
//   bool get loading => _loading;

//   set finishReason(String? set) {
//     if (set != _finishReason) {
//       setState(() => _finishReason = set);
//     }
//   }

//   set loading(bool set) {
//     if (set != loading) {
//       setState(() => _loading = set);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (searchedText != null)
//           MaterialButton(
//               color: Colors.blue.shade700,
//               onPressed: () {
//                 setState(() {
//                   searchedText = null;
//                   result = null;
//                 });
//               },
//               child: Text('search: $searchedText')),
//         Expanded(
//             child: loading
//                 ? Lottie.asset('assets/lottie/ai.json')
//                 : result != null
//                     ? GeminiResponseTypeView(
//                         builder: (context, child, response, loading) =>
//                             Markdown(data: response ?? ''))
//                     : const Center(child: Text('Search something!'))),
//         if (finishReason != null) Text(finishReason!),
//         ChatInputBox(
//           controller: controller,
//           onSend: () {
//             if (controller.text.isNotEmpty) {
//               searchedText = controller.text;
//               controller.clear();
//               loading = true;
//               result = null;
//               finishReason = null;

//               gemini
//                   .streamGenerateContent(searchedText!,
//                       generationConfig: GenerationConfig(
//                         maxOutputTokens: 2000,
//                         temperature: 0.9,
//                         topP: 0.1,
//                         topK: 16,
//                       ))
//                   .listen((value) {
//                 result = (result ?? '') + (value.output ?? '');

//                 if (value.finishReason != 'STOP') {
//                   finishReason = 'Finish reason is `RECITATION`';
//                 }
//                 loading = false;
//               });
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
