class Support {
  int amount = 0;
  int periodicity = 7;
  DateTime nextSupport = DateTime.now().add(const Duration(days: 7));
  String userUid = "";
  String animalUid = "";

  Support(this.amount, this.userUid, this.animalUid);

  Map<String, dynamic> returnMap() {
    final data = {
      "Amount": amount,
      "Periodicity": periodicity,
      "NextSupport": nextSupport.toString(),
      "UserUId": userUid,
      "AnimalUid": animalUid,
    };
    return data;
  }
}
