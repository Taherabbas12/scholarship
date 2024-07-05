class UserModel {
  int? id;
  String name;
  String userTele;
  String nameProject;
  String nameUniversity;
  double totalPrice;
  bool isDoneProject;
  bool isDonePrice;

  UserModel({
    this.id,
    required this.name,
    required this.userTele,
    required this.nameProject,
    required this.nameUniversity,
    required this.totalPrice,
    required this.isDoneProject,
    required this.isDonePrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'user_tele': userTele,
      'name_project': nameProject,
      'name_university': nameUniversity,
      'total_price': totalPrice,
      'is_done_project': isDoneProject ? 1 : 0,
      'is_done_price': isDonePrice ? 1 : 0,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      userTele: map['user_tele'],
      nameProject: map['name_project'],
      nameUniversity: map['name_university'],
      totalPrice: map['total_price'],
      isDoneProject: map['is_done_project'] == 1,
      isDonePrice: map['is_done_price'] == 1,
    );
  }
}
