
class UserData {
  late int id;
  late String email;
  late String fullName;
  late String mobileNumber;
  late String password;
  late String shopName;
  late String shopAddress;
  late String userType;
  late String status;
  late String district;
  late String gender;

  UserData({
    required this.id,
    required this.email,
    required this.fullName,
    required this.mobileNumber,
    required this.password,
    required this.shopName,
    required this.shopAddress,
    required this.status,
    required this.district,
    required this.gender,
    required this.userType
});
}
class UserDetails{
  late List<UserData> userDetailsList;
  UserDetails({required this.userDetailsList});
}