class Taks {
  String title;
  String description;
  bool isCompleted;

  Taks({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  //Convertir a Map para guardarlo
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  //Crear desde Map al cargar
  factory Taks.fromJson(Map<String, dynamic> json) {
    return Taks(
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
