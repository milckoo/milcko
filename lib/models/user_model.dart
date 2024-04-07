class UserModel{
  String phoneNumber;
  String location;
  String uid;

  UserModel({
  required this.phoneNumber,
  required this.location,
  required this.uid,
  });

//from map
  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel( 
      phoneNumber: map['phoneNumber'] ?? ' ', 
      location: map['location'] ?? ' ', 
      uid: map['uid'] ?? ' ',
    );
  }

//to map
  Map<String,dynamic> toMap(){
    return {
      "phoneNumber" : phoneNumber,
      "location" : location,
      "uid" : uid,
    };
  }
}