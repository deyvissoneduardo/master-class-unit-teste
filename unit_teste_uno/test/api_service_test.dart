import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_teste_uno/api_service.dart';
import 'package:unit_teste_uno/product.dart';
import 'package:uno/uno.dart';

final productListJson = [
  {
    'id': 1,
    'title': 'title',
    'price': 12.0,
  },
  {
    'id': 2,
    'title': 'title2',
    'price': 13.0,
  },
];

class UnoMock extends Mock implements Uno {}

class ResponseMock extends Mock implements Response {}

void main() {
  final uno = UnoMock();
  tearDown(() => reset(uno));

  test('Should return one list the product', () {
    final response = ResponseMock();
    when(() => response.data).thenReturn(productListJson);
    when(() => uno.get(any())).thenAnswer((_) async => response);
    final service = ApiService(uno);

    expect(
      service.getProducts(),
      completion([
        Product(id: 1, title: 'title', price: 12.0),
        Product(id: 2, title: 'title2', price: 13.0),
      ]),
    );
  });

  test('Should return one list the product empty when failure', () {
    when(() => uno.get(any())).thenThrow(UnoError('error'));

    final service = ApiService(uno);

    expect(service.getProducts(), completion([]));
  });
}
