class TriviaModel {
  String? createdAt;
  String? description;
  String? id;
  int? index;
  String? name;
  List<Questions>? questions;

  TriviaModel(
      {this.createdAt,
      this.description,
      this.id,
      this.index,
      this.name,
      this.questions});

  TriviaModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    description = json['description'];
    id = json['id'];
    index = json['index'];
    name = json['name'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['id'] = this.id;
    data['index'] = this.index;
    data['name'] = this.name;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? id;

  Questions({this.id});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
