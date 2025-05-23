import 'package:bookstore_app/features/category/data/model/category_model.dart';
import 'package:bookstore_app/features/category/view/view_model/cubit/category_cubit.dart';
import 'package:bookstore_app/features/category/view/view_model/cubit/category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Categories'),
      ),
      backgroundColor: Colors.grey[200],
      body: BlocProvider(
        create: (_) => CategoryCubit()..fetchCategories(),
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategorySuccess) {
              return CustomScrollView(
                slivers: [
                  SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildCategoryCard(state.categories[index]);
                      },
                      childCount: state.categories.length,
                    ),
                  ),
                ],
              );
            } else if (state is CategoryError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Categories category) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            category.image != null && category.image!.isNotEmpty
                ? Image.network(
                    category.image!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 50),
                  )
                : const Icon(Icons.image, size: 100),
            const SizedBox(height: 12),
            Text(
              category.title ?? 'No title available',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
