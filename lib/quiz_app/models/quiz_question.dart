import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class QuizQuestion {
  final String questionText;
  final String correctAnswer;
  final List<String> answers;

  List<String> get getShuffedList {
    final shuffledList = List<String>.from(answers);
    shuffledList.shuffle();
    return shuffledList;
  }

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      map['question'],
      map['correctAnswer'],
      List<String>.from(map['answers']),
    );
  }

  static Future<List<QuizQuestion>> fetchQuestions() async {
    final apiKey = dotenv.env['API_KEY'] ?? "";
    final baseUrl = dotenv.env['BASE_URL'] ?? "";

    final url = Uri.parse(baseUrl);
    final newYearsEve = DateTime.now().toString();

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model":
            "google/gemini-2.0-flash-lite-001", // change model will need to change output parsing
        "temperature": 1.0,
        "top_p": 1.0,
        "max_tokens": 7000,
        "frequency_penalty": 0.7,
        "presence_penalty": 0.8,
        "messages": [
          {
            "role": "system",
            "content": "You are a helpful assistant designed to output JSON.",
          },
          {
            "type": "message",
            "role": "user",
            "content":
                "Hãy tạo 5 câu hỏi quiz hoàn toàn ngẫu nhiên về các phrase hay dùng trong giao tiếp tiếng Anh, random_seed= ${newYearsEve}. Mỗi lần chạy API phải cho ra một kết quả khác nhau. Random field \"answers\" max 6 answers. Response format : [{ \"question\": \"...\", \"answers\": [...] , \"correctAnswer\": \"...\"}]",
            "stream": false,
            "reasoning": {"effort": "minimal"},
          },
        ],
        "response_format": {"type": "json_object"},
      }),
    );

    final data = jsonDecode(response.body);

    // Nội dung AI trả về
    final output = data["choices"][0]["message"]["content"]
        .toString()
        .split("```")[0]
        .replaceFirst("json", "");

    // Parse JSON
    final List decoded = jsonDecode(output);

    return decoded.map((e) => QuizQuestion.fromMap(e)).toList();
  }

  const QuizQuestion(this.questionText, this.correctAnswer, this.answers);
}
