import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_basket/models/product.model.dart';
import 'package:fruit_basket/models/product_filter.model.dart';

class ProductsRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _ref = _firestore.collection('products').withConverter(
    fromFirestore: (snapshot, _) => ProductModel.fromJsonWithId(snapshot.data(), snapshot.id),
    toFirestore: (product, _) => (product).toJson(),
  );

  static Future<List<QueryDocumentSnapshot<ProductModel>>> getAll() async => (await _ref.get()).docs;

// static Future<List<QueryDocumentSnapshot<ProductModel>>> filter(List<ProductFilter> filters) async {
//   Query<ProductModel> filterRef = _ref;
//
//   for (final filter in filters) {
//     if (filter.isEquals) filterRef = filterRef.where(filter.field, isEqualTo: filter.value);
//     if (filter.isExists) filterRef = filterRef.where(filter.field, arrayContains: filter.value);
//     if (filter.isGreater) filterRef = filterRef.where(filter.field, isGreaterThan: filter.value);
//     if (filter.isLower) filterRef = filterRef.where(filter.field, isLessThan: filter.value);
//     if (filter.isEquals) filterRef = filterRef.where(filter.field, whereIn: : filter.value);
//   }
//   // final filterRef =
//
//   return (await _ref.get()).docs;
// }
}
