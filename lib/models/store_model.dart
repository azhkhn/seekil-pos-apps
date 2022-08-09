class StoreModel {
  String? staging;
  String? address;

  StoreModel({this.staging, this.address});

  Map<String, dynamic> toMap() {
    return {
      'staging': staging,
      'address': address,
    };
  }

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      staging: map['staging'],
      address: map['address'],
    );
  }
}
