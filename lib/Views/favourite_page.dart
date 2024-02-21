import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final Stream<QuerySnapshot> favoriteContactsStream;

  const FavoritesPage({
    Key? key,
    required this.favoriteContactsStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Contacts"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: favoriteContactsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading"),
            );
          }
          return snapshot.data!.docs.length == 0
              ? Center(
                  child: Text("No Favourite Contacts Found.."),
                )
              : ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic>? data =
                            document.data()! as Map<String, dynamic>;
                        return ListTile(
                          leading: CircleAvatar(child: Text(data["name"][0])),
                          title: Text(data["name"]),
                          subtitle: Text(data["phone"]),
                        );
                      })
                      .toList()
                      .cast(),
                );
        },
      ),
    );
  }
}
