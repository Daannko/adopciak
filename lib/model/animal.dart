class Animal {
  int age = 0;
  String breed = "";
  String info = "";
  String location = "";
  String name = "";
  String type = "";
  String uId = "";
  String imageName = "";
  String owner = "";
  String ownerUId = "";
  List<dynamic> needs = [];
  List<dynamic> supports = [];

  Animal(this.uId, this.age, this.breed, this.name, this.info, this.location,
      this.owner, this.ownerUId, this.type, this.imageName);

  Map<String, dynamic> returnMap() {
    final data = {
      "Age": age,
      "Breed": breed,
      "Id": uId,
      "Info": info,
      "Location": location,
      "Name": name,
      "Needs": needs,
      "Owner": owner,
      "OwnerId": ownerUId,
      "SuppotedBy": supports,
      "Type": type,
      "imageName": imageName,
    };
    return data;
  }
}
