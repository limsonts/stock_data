import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stock_data/service/stock_service.dart';


class StockDetailsPage extends StatefulWidget {
  final String symbol;
 
  StockDetailsPage({required this.symbol});

  @override
  _StockDetailsPageState createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  final StockService _stockService = StockService();
  late double _currentPrice;
  late List<double> _historicalPrices;
   
  @override
  void initState() {
    super.initState();
    _fetchStockData();
  }

  void _fetchStockData() {
    setState(() {
      _currentPrice = _stockService.getCurrentPrice(widget.symbol);
      _historicalPrices = _stockService.getHistoricalPrices(widget.symbol);
    });
  }

  @override
  Widget build(BuildContext context) {  
    final double screenHeight =  MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.symbol} Stock Details',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 12, 97, 167),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          height: screenHeight,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              
              children: [
                const SizedBox(height: 20),
                Text('Current Price: \$${_currentPrice.toStringAsFixed(2)}',style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),),
                const SizedBox(height: 15),
                const Text('Historical Prices (last 30 minutes):',style: TextStyle(color: Colors.white),),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: screenHeight*0.24,
                    child: LineChart(
                      LineChartData(  
                         
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: true, border: const Border(
                          left: BorderSide(color: Colors.white),
                          top: BorderSide(color: Colors.white),
                          right: BorderSide(color: Colors.white),
                          bottom: BorderSide(color: Colors.white),
                        ) ),
                      
                        minX: 0,
                        maxX: 29,
                        minY: _historicalPrices.reduce(min) - 10,
                        maxY: _historicalPrices.reduce(max) + 10,
                        lineBarsData: [
                        
                          LineChartBarData(
                            spots: _historicalPrices
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value))
                                .toList(),
                            isCurved: true,
                            barWidth: 2,
                           
                           color: Colors.orange,
                            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: _fetchStockData,
                    child: Text('Refresh',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
