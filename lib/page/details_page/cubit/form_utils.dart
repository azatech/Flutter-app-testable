typedef FormData = Map<String, dynamic>;

extension FormDataUtils on FormData {
  int? get id => this['id'];
  String? get title => this['title'];
  String? get description => this['description'];
  bool get isCompleted => this['isCompleted'];
  DateTime get dueDate => this['dueDate'];
}