import 'package:actividad4/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:actividad4/models/products.dart';


class RegistrationAndEditing extends StatefulWidget {
  final Products? product;

  const RegistrationAndEditing({Key? key, this.product}) : super(key: key);

  @override
  State<RegistrationAndEditing> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationAndEditing> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _categoryController = TextEditingController(text: widget.product?.category ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final service = ProductsService();

    final product = Products(
      id: widget.product?.id,
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      category: _categoryController.text,
    );

    try {
      if (widget.product == null) {
        // Nuevo producto
        await service.createProduct(product);
      } else {
        // Editar producto existente
        await service.updateProduct(product);
      }

      // Volver al Home y refrescar la lista
      Navigator.pop(context, 'refresh');
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error guardando producto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Producto' : 'Registrar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isSaving
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un nombre';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Precio'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un precio';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Ingresa un número válido';
                        }
                        return null;
                      },
                    ),
                     TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una categoria';
                        }
                        const SizedBox(height: 20);
                        return null;
                        
  }),            
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProduct,
                      child: Text(isEditing ? 'Guardar cambios' : 'Registrar'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
