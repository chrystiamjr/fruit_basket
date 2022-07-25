import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_basket/models/cart.model.dart';

class PurchasesRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _ref = _firestore.collection('purchases').withConverter(
    fromFirestore: (snapshot, _) => CartModel.fromJsonWithId(snapshot.data(), snapshot.id),
    toFirestore: (cart, _) => (cart).toJson(),
  );

  static Future<List<QueryDocumentSnapshot<CartModel>>> getAll(String userUuid) async =>
      (await _ref.where('userUuid', isEqualTo: userUuid).get()).docs;
}
