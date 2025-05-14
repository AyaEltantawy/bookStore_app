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
      create: (_) => OrderHistoryCubit(),
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
        title:
            const Text("Order history", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
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
            child: ListView.builder(
              itemCount: state.filteredOrders.length,
              itemBuilder: (context, index) {
                return OrderCard(order: state.filteredOrders[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
