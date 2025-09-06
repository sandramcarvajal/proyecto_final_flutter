import 'package:actividad4/pages/registration_and_editing.dart';
import 'package:actividad4/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:actividad4/models/products.dart';

class DetalleProducto extends StatefulWidget {
  final Products product;

  const DetalleProducto({super.key, required this.product});

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  bool _isDeleting = false;

  void _eliminarProducto() async {
    final service = ProductsService();

    setState(() {
      _isDeleting = true;
    });

    try {
      await service.deleteProduct(widget.product.id!);

      // Volver al Home y avisar que hay que refrescar la lista
      Navigator.pop(context, 'refresh');
    } catch (e) {
      setState(() {
        _isDeleting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error eliminando producto: $e')),
      );
    }
  }

  void _editarProducto() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationAndEditing(product: widget.product),
      ),
    );

    if (result == 'refresh') {
      // Volver con refresco para actualizar el Home
      Navigator.pop(context, 'refresh');
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isDeleting
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${product.name}', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text('Precio: \$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  // Aquí puedes agregar más atributos
                  Text('Descripción: ${product.description ?? 'No disponible'}'),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: _editarProducto,
                        child: const Text('Editar'),
                      ),
                      ElevatedButton(
                        onPressed: _eliminarProducto,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
