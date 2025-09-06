import 'package:actividad4/models/products.dart';
import 'package:actividad4/pages/detalleProducto.dart';
import 'package:actividad4/pages/registration_and_editing.dart';
import 'package:actividad4/services/product_service.dart';
import 'package:actividad4/widgets/product_widget.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Products> _products = [];
  List<Products> _filteredProducts = [];
  bool _loading = true;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _loading = true;
    });

    final service = ProductsService();
    try {
      final productos = await service.fetchProducts();
      setState(() {
        _products = productos;
        _applyFilter();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print("Error cargando productos: $e");
    }
  }

  void _applyFilter() {
    setState(() {
      if (_searchText.isEmpty) {
        _filteredProducts = List.from(_products);
      } else {
        _filteredProducts = _products.where((product) {
          final nameLower = product.name.toLowerCase();
          final searchLower = _searchText.toLowerCase();
          return nameLower.contains(searchLower);
        }).toList();
      }
    });
  }

  void _goToRegistration({Products? product}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationAndEditing(product: product),
      ),
    );

    if (result == 'refresh') {
      _fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Buscar producto...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _searchText = value;
                      _applyFilter();
                    },
                  ),
                ),
                Expanded(
  child: _filteredProducts.isEmpty
      ? const Center(child: Text('No hay productos'))
      : ListView.builder(
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            return CardPrueba(
  product: product,
  onDetailPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleProducto(product: product),
      ),
    );
    if (result == 'refresh') {
      _fetchProducts();
    }
  },
);
          },
        ),
),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToRegistration(),
        tooltip: 'Registrar producto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
