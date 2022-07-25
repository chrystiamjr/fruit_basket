import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_basket/models/category.model.dart';

class CategoriesRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _ref = _firestore.collection('categories').withConverter(
    fromFirestore: (snapshot, _) => CategoryModel.fromJsonWithId(snapshot.data(), snapshot.id),
    toFirestore: (category, _) => (category).toJson(),
  );

  static Future<List<QueryDocumentSnapshot<CategoryModel>>> getAll() async => (await _ref.get()).docs;
}
