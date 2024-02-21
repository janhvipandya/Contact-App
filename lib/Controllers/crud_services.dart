import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUDService {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference contactsCollection =
      FirebaseFirestore.instance.collection('contacts');

  //add new contacts to firestore
  Future addNewContacts(
    String name,
    String phone,
    String email,
    List<String> groupIds,
  ) async {
    Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "phone": phone,
      "isFavourite": false,
    };
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .add(data);
      print("Document Added");
    } catch (e) {
      print(e.toString());
    }
  }

  //Get Favourite Contacts
  Stream<QuerySnapshot> getFavouriteContacts() async* {
    var favouriteContactsQuery = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("contacts")
        .where("isFavourite", isEqualTo: true)
        .orderBy("name");

    var favouriteContacts = favouriteContactsQuery.snapshots();
    yield* favouriteContacts;
  }

  //read document inside
  Stream<QuerySnapshot> getContacts(
      {String? searchQuery, bool showFavorites = false}) async* {
    var contactsQuery = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("contacts")
        .orderBy("name");

    //a filter for favourite contact
    if (showFavorites) {
      contactsQuery = contactsQuery.where("isFavorite", isEqualTo: true);
    }

    //a filter to perform search
    if (searchQuery != null && searchQuery.isNotEmpty) {
      String searchEnd = searchQuery + "\uf8ff";
      contactsQuery = contactsQuery.where("name",
          isGreaterThanOrEqualTo: searchQuery, isLessThan: searchEnd);
    }

    var contacts = contactsQuery.snapshots();
    yield* contacts;
  }

  //update a contact
  Future updateContact(String name, String phone, String email, String docID,
      bool isFavourite) async {
    Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "phone": phone,
      "isFavourite": isFavourite
    };
    try {
      await FirebaseFirestore.instance
        ..collection("users")
            .doc(user!.uid)
            .collection("contacts")
            .doc(docID)
            .update(data);
      print("Document Updated");
    } catch (e) {
      print(e.toString());
    }
  }

  //delete contact from firestore
  Future deleteContact(String docID) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)
          .delete();
      print("contact deleted");
    } catch (e) {
      print(e.toString());
    }
  }

  //Favouritecontact
  Future<void> toggleFavoriteContact(String docId, bool isFavorite) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("contacts")
        .doc(docId)
        .update({'isFavourite': isFavorite});

    //Groupid

    Future<List<Map<String, dynamic>>> getContactsByGroupId(
        String groupId) async {
      try {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await contactsCollection
                .where('groupIds', arrayContains: groupId)
                .get() as QuerySnapshot<Map<String, dynamic>>;

        return querySnapshot.docs.map((doc) => doc.data()).toList();
      } catch (e) {
        print('Error fetching contacts by group ID: $e');
        return [];
      }
    }
  }
}
