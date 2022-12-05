class UserDetails {
  String userID = "";
  int credits = 0;
  String email = "";
  String name = "";
  String surname = "";
  List<dynamic> supports = [];

  UserDetails(this.userID, this.credits, this.email, this.name, this.surname);

  Map<String, dynamic> returnMap() {
    final data = {
      "UserID": userID,
      "Credits": credits,
      "Email": email,
      "Name": name,
      "Surname": surname,
      "Supports": supports,
    };
    return data;
  }
}
