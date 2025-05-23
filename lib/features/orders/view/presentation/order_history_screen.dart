import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/order_cubit.dart';
import '../view_model/order_state.dart';
import '../widget/order_card.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = OrderHistoryCubit();
        cubit.getOrderHistory(cubit.state.selectedFilter.toLowerCase());
        return cubit;
      },
      child: const _OrderHistoryView(),
    );
  }
}

class _OrderHistoryView extends StatelessWidget {
  const _OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<OrderHistoryCubit>();
    final state = cubit.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order History",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              children: cubit.filters.map((filter) {
                final isSelected = filter == state.selectedFilter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (_) => cubit.setFilter(filter),
                  selectedColor: Colors.pink[200],
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.error != null) {
                  return Center(
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state.orders.isEmpty) {
                  return const Center(child: Text("No orders found."));
                } else {
                  print("orddddddddders${state.orders.length}");
                  return ListView.builder(
                    itemCount: state.orders.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: OrderCard(order: state.orders[index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
