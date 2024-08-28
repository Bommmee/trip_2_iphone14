import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class GeminiResponsePage extends StatefulWidget {
  final List<String> likedPlaces;
  final Map<String, String> tourPlanData;

  const GeminiResponsePage({
    Key? key,
    required this.likedPlaces,
    required this.tourPlanData,
  }) : super(key: key);

  @override
  _GeminiResponsePageState createState() => _GeminiResponsePageState();
}

class _GeminiResponsePageState extends State<GeminiResponsePage> {
  List<String> _messages = [];
  bool _isSending = false;

  late GenerativeModel model;

  @override
  void initState() {
    super.initState();
    initializeModel();
    _sendMessage();
  }

  void initializeModel() {
    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'YOUR_API_KEY', // 여기에 실제 API 키를 입력하세요
    );
  }

  Future<void> _sendMessage() async {
    setState(() {
      _isSending = true;
    });

    String prompt = '저는 다음과 같은 여행 계획을 세우고 싶습니다: '
        '관계 - ${widget.tourPlanData['relationship']}, '
        '인원 수 - ${widget.tourPlanData['peopleCount']}, '
        '여행 시작 시간 - ${widget.tourPlanData['startTime']}, '
        '여행 종료 시간 - ${widget.tourPlanData['endTime']}, '
        '예산 - ${widget.tourPlanData['budget']}, '
        '관심사 - ${widget.tourPlanData['interests']}. '
        '아래 장소들을 방문하고자 합니다: ${widget.likedPlaces.join(", ")}. '
        '입력받은 내용을 출력해주세요. ';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        final responseText = response.text ?? '잠시만 기다려주세요...';
        _messages.add(responseText);
        _isSending = false;
      });
    } catch (e) {
      setState(() {
        _messages.add('에러 발생: $e');
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini 여행 계획'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? const Center(child: Text('아직 응답이 없습니다.'))
                  : Markdown(
                      data: _messages.join("\n\n"),
                      styleSheet: MarkdownStyleSheet(
                        h1: const TextStyle(color: Colors.blue),
                        p: const TextStyle(fontSize: 16),
                      ),
                    ),
            ),
            if (_isSending) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
