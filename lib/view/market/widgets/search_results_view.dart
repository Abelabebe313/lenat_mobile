import 'package:flutter/material.dart';
import 'package:lenat_mobile/models/market_product_model.dart';
import 'package:lenat_mobile/view/market/widgets/market_item_widget.dart';
import 'package:lenat_mobile/view/market/widgets/product_detail_page.dart';

class SearchResultsView extends StatelessWidget {
  final String searchQuery;
  final List<MarketPlaceModel> searchResults;

  const SearchResultsView({
    Key? key,
    required this.searchQuery,
    required this.searchResults,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search Results for "$searchQuery"',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: searchResults.isEmpty
            ? const Center(
                child: Text(
                  'No products found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final product = searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: MarketItemWidget(product: product),
                  );
                },
              ),
      ),
    );
  }
}
