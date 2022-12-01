class SaveUserData {
  int credits = 0;
  String name = "";
  String surname = "";
  List<dynamic> supports = [];
  String email = "";

  SaveUserData(this.name, this.surname, this.email);

  Map<String, dynamic> returnMap() {
    final data = {
      "Credits": credits,
      "Name": name,
      "Surname": surname,
      "Supports": supports,
      "Email": email,
    };
    return data;
  }
}
