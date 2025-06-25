class QuestionModel {
  String? answer;
  String? content;
  String? explanation;
  String? hint;
  String? id;
  List<String>? options;
  String? triviaId;

  QuestionModel(
      {this.answer,
      this.content,
      this.explanation,
      this.hint,
      this.id,
      this.options,
      this.triviaId});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    content = json['content'];
    explanation = json['explanation'];
    hint = json['hint'];
    id = json['id'];
    options = json['options'].cast<String>();
    triviaId = json['trivia_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['content'] = this.content;
    data['explanation'] = this.explanation;
    data['hint'] = this.hint;
    data['id'] = this.id;
    data['options'] = this.options;
    data['trivia_id'] = this.triviaId;
    return data;
  }
}
