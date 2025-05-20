class ContactModel{

  final int? id;
  final String? name;
  final String? phone;

  ContactModel({this.id, this.name, this.phone});

  ContactModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        phone = res["phone"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

}