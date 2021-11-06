import 'package:flutter_test/flutter_test.dart';
import 'package:stream_mixin/store_service.dart';

import 'package:stream_mixin/stream_mixin.dart';

class NameService with StreamMixin<String> {}

class ProductModel extends BaseModel {
  String name;
  ProductModel({
    required this.name,
    required String id,
  }) : super(id: id);
}

class ProductStore extends StoreService<ProductModel> {}

void main() {
  test('Simple list of strings', () {
    var nameService = NameService();
    List<String> stringsToEmit = ['Arnold', 'Simon', 'Parge'];

    expect(
      nameService.onChange,
      emitsInOrder(stringsToEmit),
    );

    for (var str in stringsToEmit) {
      nameService.update(str);
    }
  });

  test('List of models', () async {
    var store = ProductStore();

    List<ProductModel> products = [
      ProductModel(id: 'as7bd6', name: 'Shoes'),
      ProductModel(id: 'sd8sdn', name: 'Bag'),
      ProductModel(id: 'aps9da', name: 'Shirt'),
      ProductModel(id: 'tjl4tl', name: 'Watch'),
    ];
    int addCount = 0;

    store.onChange.listen((StreamElement<ProductModel> productStream) {
      if (productStream.operation == Operation.add) {
        expect(productStream.item, products[addCount]);
        addCount++;
      } else if (productStream.operation == Operation.update) {
        expect(productStream.item, products[1]);
      } else if (productStream.operation == Operation.delete) {
        expect(productStream.item, products[2]);
        expect(store.values.length, 3);
      }
    });

    // Adding products in the store
    products.forEach(store.add);

    // Updating a product from the store
    await Future.delayed(const Duration(seconds: 1));
    var bag = products[1];
    bag.name = 'Hand Bag';
    store.update(bag);

    // Updating a product from the store
    await Future.delayed(const Duration(seconds: 1));
    var shirt = products[2];
    store.delete(shirt);

    // Waiting for the events to end
    await Future.delayed(const Duration(milliseconds: 500));
  });
}
