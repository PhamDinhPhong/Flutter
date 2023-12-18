class Sellers{
  String? sellerUID;
  String? sellerName;
  String? sellerAvatarURL;
  String? sellerEmail;
  String? sellerRestaurantStatus;

  Sellers({
    this.sellerUID,
    this.sellerName,
    this.sellerAvatarURL,
    this.sellerEmail,
    this.sellerRestaurantStatus,
  });

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    sellerAvatarURL = json["sellerAvatarURL"];
    sellerEmail = json["sellerEmail"];
    sellerRestaurantStatus = json["Restaurant_Status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sellerUID"] = this.sellerUID;
    data["sellerName"] = this.sellerName;
    data["sellerAvatarURL"] = this.sellerAvatarURL;
    data["sellerEmail"] = this.sellerEmail;
    data["Restaurant_Status"] = this.sellerRestaurantStatus;
    return data;
  }
}