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
}
