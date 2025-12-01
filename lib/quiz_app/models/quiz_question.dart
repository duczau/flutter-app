class QuizQuestion {
  final String questionText;
  final List<String> answers;

  List<String> getShuffedList() {
    final shuffledList = List<String>.from(answers);
    shuffledList.shuffle();
    return shuffledList;
  }

  const QuizQuestion(this.questionText, this.answers);
}
