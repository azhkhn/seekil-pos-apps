class PartnershipModel {
  int? id;
  String? name;
  String? whatsapp;
  String? address;
  int? commission;
  String? dropZone; // yes|no
  String? startDate;
  String? endDate;

  PartnershipModel(
      {this.id,
      this.name,
      this.whatsapp,
      this.address,
      this.commission,
      this.dropZone,
      this.startDate,
      this.endDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'whatsapp': whatsapp,
      'address': address,
      'potongan': commission,
      'drop_zone': dropZone,
      'start_date': startDate,
      'end_date': endDate,
    };
  }

  factory PartnershipModel.fromMap(Map<String, dynamic> map) {
    return PartnershipModel(
      id: map['id'],
      name: map['name'],
      whatsapp: map['whatsapp'],
      address: map['address'],
      commission: map['potongan'],
      dropZone: map['drop_zone'],
      startDate: map['start_date'],
      endDate: map['end_date'],
    );
  }
}
