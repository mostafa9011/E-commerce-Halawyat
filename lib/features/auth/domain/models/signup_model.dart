class SignUpModel {
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? password;
  String? referralCode;
  int? governmentId;
  int? cityId;
  int? platform;
  SignUpModel({this.fName, this.lName, this.phone, this.email='', this.password, this.referralCode = '',this.cityId, this.governmentId,this.platform});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    referralCode = json['referral_code'];
    cityId = json['city'];
    governmentId = json['governorate'];
    platform = json['platform'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['referral_code'] = referralCode;
    data['platform'] = platform;
    data['governorate'] = governmentId;
    data['city'] = cityId;
    return data;
  }
}
