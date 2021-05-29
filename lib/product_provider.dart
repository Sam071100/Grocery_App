import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:groceries_shopping_app/models/product.dart';

// This is the class which is going to change the state and notify to each and every consumer widget
class ProductsOperationsController extends ChangeNotifier {
  // This is the list of products which is present in the stock
  List<Product> _productsInStock = [
    Product(
        name: 'Apple',
        picPath: 'assets/apple.jpg',
        price: '\₹150.00',
        weight: '1 Kg',
        price1: 150),
    Product(
        name: 'Lemon',
        picPath: 'assets/lemons.jpg',
        price: '\₹10.00',
        weight: '1 Pc',
        price1: 10),
    Product(
        name: 'Kiwi',
        picPath: 'assets/kiwi.jpg',
        price: '\₹15.00',
        weight: '1 Pcs',
        price1: 15),
    Product(
        name: 'Guava',
        picPath: 'assets/guava.jpg',
        price: '\₹50.00',
        weight: '1 Kg',
        price1: 50),
    Product(
        name: 'Tomato',
        picPath: 'assets/tomato.jpg',
        price: '\₹15.00',
        weight: '1 Kg',
        price1: 15),
    Product(
        name: 'Black Grapes',
        picPath: 'assets/grapes.jpg',
        price: '\₹90.00',
        weight: '1 Kg',
        price1: 90),
    Product(
        name: 'Maggi ketchup',
        picPath: 'assets/ketchup.png',
        price: '\₹290.00',
        weight: '550g',
        price1: 290),
    Product(
        name: 'IndiaGate Basmati Rice Organic',
        picPath: 'assets/rice.png',
        price: '\₹105.00',
        weight: '500g',
        price1: 105),
    Product(
        name: 'Organic Potatos',
        picPath: 'assets/potatoes.png',
        price: '\₹40.00',
        weight: '1 Kg',
        price1: 40),
    Product(
      name: 'Amul Toned Milk',
      picPath: 'assets/milk.png',
      price: '\₹64.00',
      weight: '1 Ltr',
      price1: 30,
    ),
    Product(
        name: 'Italian Pasta Toglile',
        picPath: 'assets/pasta.png',
        price: '\₹96.00',
        weight: '500g',
        price1: 96),
    Product(
        name: 'Organic Flour',
        picPath: 'assets/flour.png',
        price: '\₹90.00',
        weight: '1 Kg',
        price1: 90),
  ];

  // This list gets updated when the user enters the product into the cart
  List<Product> _shoppingCart = [];
  VoidCallback onCheckOutCallback;

  void onCheckOut({VoidCallback onCheckOutCallback}) {
    this.onCheckOutCallback = onCheckOutCallback;
  }

  UnmodifiableListView<Product> get productsInStock {
    return UnmodifiableListView(_productsInStock);
  }

  UnmodifiableListView<Product> get cart {
    return UnmodifiableListView(_shoppingCart);
  }

  // Method to add the items in the cart
  void addProductToCart(int index, {int bulkOrder = 0}) {
    bool inCart = false;
    int indexInCard = 0;
    if (_shoppingCart.length != 0) {
      for (int i = 0; i < _shoppingCart.length; i++) {
        if (_shoppingCart[i].name == _productsInStock[index].name &&
            _shoppingCart[i].picPath == _productsInStock[index].picPath) {
          indexInCard = i;
          inCart = true;
          break;
        }
      }
    }
    if (inCart == false) {
      _shoppingCart.add(
        Product(
          name: _productsInStock[index].name,
          picPath: _productsInStock[index].picPath,
          price: _productsInStock[index].price,
          weight: _productsInStock[index].weight,
          orderedQuantity:
              _productsInStock[index].orderedQuantity + (bulkOrder - 1),
        ),
      );
      notifyListeners(); // Informing the consumers to take this new state and rerender themselves
    } else {
      _shoppingCart[indexInCard].makeOrder(bulkOrder: bulkOrder);
      notifyListeners();
    }
  }

  // Method to calculate the total cost of the product in the cart
  double _totalCost = 0.00;
  void returnTotalCost() {
    if (_totalCost == 0) {
      for (int i = 0; i < _shoppingCart.length; i++) {
        _totalCost +=
            (double.parse(_shoppingCart[i].price.replaceAll('\₹', '')) *
                _shoppingCart[i].orderedQuantity);
      }
      notifyListeners();
    } else {
      _totalCost = 0.0;
      for (int i = 0; i < _shoppingCart.length; i++) {
        _totalCost +=
            (double.parse(_shoppingCart[i].price.replaceAll('\₹', '')) *
                _shoppingCart[i].orderedQuantity);
      }
      notifyListeners();
    }
  }

  // Method to remove the items from the cart
  void deleteFromCart(int index) {
    _shoppingCart.removeAt(index);
    notifyListeners();
  }

  double get totalCost {
    return double.parse(_totalCost.toStringAsExponential(3));
  }

  // Method to clear the cart
  void clearCart() {
    _shoppingCart.clear();
    onCheckOutCallback();
    notifyListeners();
  }
}
