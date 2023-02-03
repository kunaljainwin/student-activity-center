import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:samadhyan/keys.dart';
import 'package:samadhyan/utilities/text_to_speech.dart';
import 'package:samadhyan/widgets/login_helpers.dart';
import 'package:sizer/sizer.dart';

const backgroundColor = Color(0xff343541);
const botBackgroundColor = Color(0xff444654);

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

Future<String> generateResponse(String prompt) async {
  const apiKey = chatGPTApiKey; //apiSecretKey;

  var url = Uri.https("api.openai.com", "/v1/completions");
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $apiKey"
    },
    body: json.encode({
      "model": "text-davinci-003",
      "prompt": prompt,
      'temperature': 0,
      'max_tokens': 700,
      'top_p': 1,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
    }),
  );

  // Do something with the response
  Map<String, dynamic> newresponse = jsonDecode(response.body);

  return newresponse['choices'][0]['text'];
}

final List<ChatMessage> _messages = [];

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "OpenAI's ChatGPT bot",
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 20,
          ),
        ),
        backgroundColor: botBackgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Wrap(
                      direction: 100.w < 800 ? Axis.horizontal : Axis.vertical,
                      children: [
                        flexCardGpt(
                            icon: Icons.flash_on,
                            color: Colors.amberAccent,
                            text: "A chatbot powered by OpenAI's GPT-3"),
                        // flexCardGpt(
                        //     icon: Icons.multitrack_audio_rounded,
                        //     color: Colors.cyanAccent,
                        //     text: "It is trained to speak out responses"),
                        flexCardGpt(
                            icon: Icons.warning_amber_rounded,
                            color: Colors.red.shade400,
                            text:
                                "Limited knowledge of world after 2021.\n May produce harmful instructions or biased content"),
                      ],
                    ))
                  : _buildList(),
            ),
            Visibility(
              visible: isLoading,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  _buildInput(),
                  _buildSubmit(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
      child: IconButton(
        icon: const Icon(
          Icons.send_rounded,
          color: Color.fromRGBO(142, 142, 160, 1),
        ),
        onPressed: () async {
          if (_textController.text != "") {
            setState(
              () {
                FocusManager.instance.primaryFocus?.unfocus();
                _messages.add(
                  ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user,
                  ),
                );
                isLoading = true;
              },
            );
            var input = _textController.text;
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
            generateResponse(input).then((value) {
              setState(() {
                isLoading = false;
                _messages.add(
                  ChatMessage(
                    text: value,
                    chatMessageType: ChatMessageType.bot,
                  ),
                );
              });
              TextToSpeech.textToSpeech(value);
              Future.delayed(const Duration(milliseconds: 200))
                  .then((_) => _scrollDown());
            });
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 200))
                .then((_) => _scrollDown());
          } else {
            Get.snackbar("Error", "Please enter a message");
          }
        },
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: Colors.white),
        controller: _textController,
        onSubmitted: (str) {
          if (str != "") {
            setState(
              () {
                FocusManager.instance.primaryFocus?.unfocus();
                _messages.add(
                  ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user,
                  ),
                );
                isLoading = true;
              },
            );
            var input = _textController.text;
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
            generateResponse(input).then((value) {
              setState(() {
                isLoading = false;
                _messages.add(
                  ChatMessage(
                    text: value,
                    chatMessageType: ChatMessageType.bot,
                  ),
                );
              });
              TextToSpeech.textToSpeech(value);
              Future.delayed(const Duration(milliseconds: 200))
                  .then((_) => _scrollDown());
            });
            _textController.clear();
          } else {
            Get.snackbar("Error", "Please enter a message");
          }
        },
        decoration: const InputDecoration(
          fillColor: botBackgroundColor,
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  ListView _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        var message = _messages[index];
        return ChatMessageWidget(
          text: message.text,
          chatMessageType: message.chatMessageType,
          scrollController: _scrollController,
        );
      },
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class flexCardGpt extends StatelessWidget {
  const flexCardGpt({
    Key? key,
    this.icon,
    this.color,
    this.text,
  }) : super(key: key);
  final icon;
  final color;
  final text;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            icon,
            size: 50,
            color: color,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8, horizontal: 100.w < 800 ? 14.w : 2.w),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10.w,
        )
      ],
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({
    super.key,
    required this.text,
    required this.chatMessageType,
    required this.scrollController,
  });

  final String text;
  final ChatMessageType chatMessageType;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(16),
      color: chatMessageType == ChatMessageType.bot
          ? botBackgroundColor
          : backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          chatMessageType == ChatMessageType.bot
              ? Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
                    child: SvgPicture.asset(
                      "lib/assets/openAI_logo.svg",
                      height: 30,
                      width: 30,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    backgroundImage:
                        OptimizedCacheImageProvider(userSnapshot["imageurl"]),
                  ),
                ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: chatMessageType == ChatMessageType.bot &&
                          text == _messages.last.text
                      ? AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              text,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.white),
                              speed: const Duration(milliseconds: 30),
                            ),
                          ],
                          onFinished: () {
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                          onTap: () async {
                            TextToSpeech.stopSpeech();
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                          isRepeatingAnimation: false,
                          displayFullTextOnTap: true,
                        )
                      : Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                border: Border.all(color: Colors.white38)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                enableFeedback: true,
                hoverColor: Colors.teal.shade200,
                splashColor: Colors.teal.shade100.withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Copied to clipboard"),
                      duration: Duration(milliseconds: 600),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.content_copy_rounded,
                    color: Color.fromRGBO(142, 142, 160, 1),
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

enum ChatMessageType { user, bot }

class ChatMessage {
  ChatMessage({
    required this.text,
    required this.chatMessageType,
  });

  final String text;
  final ChatMessageType chatMessageType;
}
