import 'package:e_commerce/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/foundation.dart';

class WishlistStore {
  WishlistStore._();

  static final ValueNotifier<Map<String, HomeProductData>> _favoritesNotifier =
      ValueNotifier<Map<String, HomeProductData>>({});

  static ValueListenable<Map<String, HomeProductData>> get favoritesListenable =>
      _favoritesNotifier;

  static bool isFavorite(String productId) =>
      _favoritesNotifier.value.containsKey(productId);

  static void add(HomeProductData product) {
    final map = Map<String, HomeProductData>.from(_favoritesNotifier.value);
    map[product.id] = product;
    _favoritesNotifier.value = map;
  }

  static void remove(String productId) {
    if (!_favoritesNotifier.value.containsKey(productId)) return;
    final map = Map<String, HomeProductData>.from(_favoritesNotifier.value);
    map.remove(productId);
    _favoritesNotifier.value = map;
  }

  static void toggle(HomeProductData product) {
    if (isFavorite(product.id)) {
      remove(product.id);
      return;
    }
    add(product);
  }
}
