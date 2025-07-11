import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/models/supply_item.dart';
import '../../domain/models/supply_order.dart';
import '../../domain/services/i_supply_repository.dart';
import '../auth/auth_cubit.dart';
import '../../theme/app_tokens.dart';

class SupplyOrderForm extends StatefulWidget {
  final SupplyItem item;

  const SupplyOrderForm({Key? key, required this.item}) : super(key: key);

  @override
  State<SupplyOrderForm> createState() => _SupplyOrderFormState();
}

class _SupplyOrderFormState extends State<SupplyOrderForm> {
  final _qtyController = TextEditingController(text: '1');

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zamów: ${widget.item.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ilość (${widget.item.unit})'),
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Zamów'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final qty = int.tryParse(_qtyController.text) ?? 0;
    if (qty <= 0) return;
    final user = context.read<AuthCubit>().currentUser;
    if (user == null) return;
    final repo = GetIt.instance<ISupplyRepository>();
    final order = SupplyOrder(
      id: '',
      itemId: widget.item.id,
      orderedBy: user.id,
      orderedAt: DateTime.now(),
      quantityRequested: qty,
      status: 'pending',
    );
    await repo.placeOrder(order);
    if (mounted) Navigator.of(context).pop();
  }
}
