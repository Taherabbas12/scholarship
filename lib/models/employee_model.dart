class EmployeeModel {
  int? id;
  String name;
  String position;
  double salary;
  String hireDate;
  String phone;

  EmployeeModel({
    this.id,
    required this.name,
    required this.position,
    required this.salary,
    required this.hireDate,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'salary': salary,
      'hireDate': hireDate,
      'phone': phone,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      salary: map['salary'],
      hireDate: map['hireDate'],
      phone: map['phone'],
    );
  }
}
