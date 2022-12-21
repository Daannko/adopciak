class SaveUserData {
  int credits = 0;
  String name = "";
  String surname = "";
  List<dynamic> supports = [];
  String email = "";
  String phoneNumber = "";

  SaveUserData(this.name, this.surname, this.email, this.phoneNumber);

  Map<String, dynamic> returnMap() {
    final data = {
      "Credits": credits,
      "Name": name,
      "Surname": surname,
      "Supports": supports,
      "Email": email,
      "PhoneNumber": phoneNumber
    };
    return data;
  }
}
