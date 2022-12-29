import 'package:flutter/cupertino.dart';
import 'package:laundryappv2/Models/subscriptions.dart';

class Cart with ChangeNotifier {
  SubscriptionData? subscriptionData;
  Cart(this.subscriptionData);
  Map<String, int> _items = {};
  void addItem(String title) {
    if (_items.containsKey(title)) {
      _items.update(title, (quantity) {
        return quantity + 1;
      });
    } else {
      _items.putIfAbsent(title, () => 1);
    }

    notifyListeners();
  }

  void removeItem(String title) {
    if (_items.containsKey(title)) {
      if (_items[title] == 1) {
        _items.remove(title);
      } else {
        _items.update(
            title, (quantity) => quantity > 0 ? quantity - 1 : quantity);
      }
    }

    notifyListeners();
  }

  int itemCount(String title) {
    return _items[title] ?? 0;
  }

  int totalCount() {
    int sum = 0;
    _items.values.forEach((element) {
      sum += element;
    });
    return sum;
  }

  Map<String, int> get items {
    return {..._items};
  }
}
