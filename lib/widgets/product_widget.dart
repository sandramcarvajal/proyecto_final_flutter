import 'package:actividad4/models/products.dart';
import 'package:flutter/material.dart';

class CardPrueba extends StatelessWidget {
  const CardPrueba({
    super.key,
    required this.product,
    required this.onDetailPressed,
  });

  final Products product;
  final VoidCallback onDetailPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(product.name),
        trailing: TextButton(
          onPressed: onDetailPressed,
          child: const Text('Ver detalle'),
        ),
      ),
    );
  }
}
