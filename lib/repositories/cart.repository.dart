import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_basket/models/cart.model.dart';

class CartRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _ref = _firestore.collection('tempCart').withConverter(
    fromFirestore: (snapshot, _) => CartModel.fromJsonWithId(snapshot.data(), snapshot.id.toString()),
    toFirestore: (cart, _) => (cart).toJson(),
  );

  static Future<QueryDocumentSnapshot<CartModel>?> get(String userUuid) async {
    final list = await _ref.where('userUuid', isEqualTo: userUuid).orderBy('timestamp').limitToLast(1).get();
    return list.size > 0 ? list.docs.elementAt(0) : null;
  }

  static Future<dynamic> insert(CartModel model) async {
    try {
      model.uuid = (await _ref.add(model)).id;
      return model;
    } on FirebaseException catch (err) {
      print('FirebaseException: ${err.code}');
      return err.code;
    } catch (err) {
      print('Error: ${err}');
      return err.toString();
    }
  }

  static Future<String?> update(String uuid, Map<String, dynamic> json) async {
    try {
      await _ref.doc(uuid).update(json);
      return null;
    } on FirebaseException catch (err) {
      return err.code;
    } catch (err) {
      return err.toString();
    }
  }

  static Future<String?> delete(String uuid) async {
    try {
      await _ref.doc(uuid).delete();
      return null;
    } on FirebaseException catch (err) {
      return err.code;
    } catch (err) {
      return err.toString();
    }
  }
}
