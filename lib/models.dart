class CategoryModel {
  final int? id;
  final String name;

  CategoryModel({this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel(id: json['id'], name: json['name']);
}

class TaskModel {
  int? id;
  final String title;
  final String description;
  final int categoryId;
  final bool isDone;
  final String? categoryName; // Helper for UI display

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    this.isDone = false,
    this.categoryName,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'categoryId': categoryId,
    'isDone': isDone ? 1 : 0,
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    categoryId: json['categoryId'],
    isDone: json['isDone'] == 1,
    categoryName: json['categoryName'],
  );
}