import 'dart:math';

class StockService {
  final Random _random = Random();

  double getCurrentPrice(String symbol) {
    return 100 + _random.nextDouble() * 100; // Generate a random price between 100 and 200
  }

  List<double> getHistoricalPrices(String symbol) {
    return List.generate(30, (_) => 100 + _random.nextDouble() * 100); // Generate 30 random prices
  }
}