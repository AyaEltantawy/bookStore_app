import 'package:bookstore_app/features/home/data/models/book_model.dart';
import 'package:bookstore_app/features/search/view/search/search_cubit.dart';
import 'package:bookstore_app/features/search/view/search/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchCubit searchCubit = SearchCubit();
    return BlocProvider(
      create: (context) => searchCubit..fetchSearch,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 23),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (query) {
                              searchCubit.fetchSearch(query);
                            },
                            decoration: InputDecoration(
                              suffixIconColor: Colors.pinkAccent,
                              suffixIcon: Icon(Icons.search),
                              hintText: 'Search',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Filter button
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: FilterDialog(
                                                searchCubit: searchCubit),
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.filter_list, size: 20)),
                              SizedBox(width: 4),
                              Text('Filter'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // BlocBuilder for UI update based on Cubit states
                    SearchBody(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDialog extends StatelessWidget {
  const FilterDialog({required this.searchCubit, super.key});

  final SearchCubit searchCubit;
  @override
  Widget build(BuildContext context) {
    String selectedCategory = '';
    double selectedPrice = 100; // default value, can be adjusted
    List<String> categories = [
      'All',
      'Fiction',
      'Science',
      'History'
    ]; // your real categories

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('Filter Books'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Category'),
                value: selectedCategory.isEmpty ? null : selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 20),

              // Price Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Max Price: ${selectedPrice.toInt()}'),
                  Slider(
                    min: 0,
                    max: 1000,
                    value: selectedPrice,
                    divisions: 20,
                    label: selectedPrice.toStringAsFixed(0),
                    onChanged: (value) {
                      setState(() {
                        selectedPrice = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                print("filtering");
                await searchCubit.fetchFilteredBooks(
                  category: selectedCategory,
                  price: selectedPrice.toInt(),
                );
                print("filtered");

                Navigator.pop(context);
              },
              child: Text('Apply Filter'),
            ),
          ],
        );
      },
    );
  }
}

class SearchBody extends StatelessWidget {
  const SearchBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SearchError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is SearchSuccess) {
          // Render search results
          return Column(
            children: [
              for (var book in state.searchResults)
                Row(
                  children: [
                    BookCardItem(book: book), // Pass book to build card
                    SizedBox(width: 10),
                  ],
                ),
            ],
          );
        }
        return Container(); // In case of SearchInitial state
      },
    );
  }
}

class BookCardItem extends StatelessWidget {
  const BookCardItem({
    required this.book,
    super.key,
  });

  final Books book;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 180,
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book.image ?? "", // Use image URL from book object
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.favorite_border, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            book.title ?? "", // Use title from book object
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Author: ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                TextSpan(
                  text: book.author, // Use author from book object
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.attach_money, color: Colors.black87, size: 18),
              Text(
                book.price ?? "0", // Use price from book object
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 13,
                ),
              ),
              SizedBox(width: 6),
              Text(
                book.priceAfterDiscount ??
                    "", // Use discounted price from book object
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.pinkAccent,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Spacer(),
              Icon(
                Icons.shopping_cart,
                color: Colors.pinkAccent,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
