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

    stringsToEmit.forEach((str) => nameService.update(element: str));
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
      if (productStream.operation == Operation.Add) {
        expect(productStream.item, products[addCount]);
        print('Product ${productStream.item.name} added successfully!');
        addCount++;
      } else if (productStream.operation == Operation.Update) {
        expect(productStream.item, products[2]);
        print('Product ${productStream.item.name} updated successfully!');
      }
    });

    // Adding products in the store
    products.forEach(store.addItem);

    await Future.delayed(Duration(seconds: 1));

    // Updating a product from the store
    var bag = products[2];
    bag.name = 'Hand Bag';
    store.updateItem(bag);
  });
}
