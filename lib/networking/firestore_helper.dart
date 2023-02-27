import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dresssew/models/app_user.dart';
import 'package:dresssew/models/customer.dart';
import 'package:dresssew/models/tailor.dart';

class FireStoreHelper {
  final instance = FirebaseFirestore.instance;
  Future<List<Tailor>> loadAllTailors() async {
    List<Tailor> tailors = [];
    final result = await instance.collection("tailors").get();
    if (result.docs.isNotEmpty) {
      result.docs.forEach((element) {
        final tailor = Tailor.fromJson(element.data());
        tailors.add(tailor);
      });
    }
    return tailors;
  }

  Future<Tailor?> getTailorWithEmail(String email) async {
    final result = await instance
        .collection("tailors")
        .where('email', isEqualTo: email)
        .get();
    if (result.docs.isNotEmpty) {
      final tailor = Tailor.fromJson(result.docs.first.data());
      return tailor;
    }
    return null;
  }

  Future<Customer?> getCustomerWithEmail(String email) async {
    final result = await instance
        .collection("customers")
        .where('email', isEqualTo: email)
        .get();
    if (result.docs.isNotEmpty) {
      final customer = Customer.fromJson(result.docs.first.data());
      return customer;
    }
    return null;
  }

  Future<List<Customer>> loadAllCustomers() async {
    List<Customer> customers = [];
    final result = await instance.collection("customers").get();
    if (result.docs.isNotEmpty) {
      result.docs.forEach((element) {
        final customer = Customer.fromJson(element.data());
        customers.add(customer);
      });
    }
    return customers;
  }

  Future<AppUser?> getAppUserWithEmail(String? email) async {
    final result = await instance
        .collection("users")
        .where('email', isEqualTo: email)
        .get();
    if (result.docs.isNotEmpty) {
      final user = AppUser.fromJson(result.docs.first.data());
      return user;
    }
    return null;
  }

  Future<List<AppUser>> loadAllUsers() async {
    List<AppUser> appUsers = [];
    final result = await instance.collection("users").get();
    if (result.docs.isNotEmpty) {
      result.docs.forEach((element) {
        final user = AppUser.fromJson(element.data());
        appUsers.add(user);
      });
    }
    return appUsers;
  }
}
