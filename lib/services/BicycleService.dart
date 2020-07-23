
class BicycleService {
  // static Future<String> getAvailableBike() async {
  //   var availableQuery = Firestore.instance
  //       .collection("bicycles")
  //       .where("availability", isEqualTo: true)
  //       .limit(1);

  //   await availableQuery.getDocuments().then((QuerySnapshot docs) {
  //     print(docs);
  //     if (docs.documents.isNotEmpty) {
  //       var docId = docs.documents[0].documentID;
  //       print(docId);
  //       var docRef = Firestore.instance.collection("bicycles").document(docId);
  //       Firestore.instance.runTransaction((transaction) async {
  //         await transaction.update(docRef, {"availability": false});
  //       });
  //       return docs.documents[0].documentID;
  //     } else {
  //       return "NOT_AVAILABLE";
  //     }
  //   });
  // }
}
