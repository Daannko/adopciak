class Support {
  int amount = 0;
  int periodicity = 0;
  String userUId = "";
  String animalUid = "";

  Support(this.amount, this.periodicity, this.userUId, this.animalUid);

  Map<String, dynamic> returnUserMap() {
    final data = {
      "Amount": amount,
      "Periodicity": periodicity,
      "AnimalUid": animalUid,
    };
    return data;
  }

  Map<String, dynamic> returnAnimalMap() {
    final data = {
      "Amount": amount,
      "Periodicity": periodicity,
      "UserUId": userUId,
    };
    return data;
  }
}
