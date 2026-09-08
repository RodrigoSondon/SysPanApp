import 'package:flutter/material.dart';
import '../../../app/presentation/global/colors.dart';
import '../../../data/dummy_db.dart';
import '../../../data/models/receta_model.dart';

class ProduccionScreen extends StatefulWidget {
  const ProduccionScreen({super.key});

  @override
  State<ProduccionScreen> createState() => _ProduccionScreenState();
}

class _ProduccionScreenState extends State<ProduccionScreen> {
  final List<Map<String, dynamic>> _historial = [
    {'id': '1', 'receta': 'Concha Vainilla', 'cantidad': 50, 'merma': 2, 'fecha': 'Hoy 06:00 AM', 'panadero': 'Juan P.'},
    {'id': '2', 'receta': 'Bolillo', 'cantidad': 200, 'merma': 5, 'fecha': 'Hoy 05:00 AM', 'panadero': 'Juan P.'},
    {'id': '3', 'receta': 'Cuernito', 'cantidad': 40, 'merma': 0, 'fecha': 'Ayer 06:30 PM', 'panadero': 'Pedro M.'},
  ];

  void _mostrarFormularioProduccion(BuildContext context) {
    Receta? recetaSeleccionada;
    final cantidadCtrl = TextEditingController();
    final mermaCtrl = TextEditingController(text: '0');

    final recetasDisponibles = DummyDb.instance.recetas;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registrar Horneada',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Receta>(
                decoration: const InputDecoration(
                  labelText: 'Receta',
                  border: OutlineInputBorder(),
                ),
                items: recetasDisponibles.map((r) {
                  return DropdownMenuItem(value: r, child: Text(r.nombre));
                }).toList(),
                onChanged: (val) {
                  recetaSeleccionada = val;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cantidadCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad Producida (Batches/Unidades)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: mermaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Mermas / Desperdicio (Piezas)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.delete_outline),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (recetaSeleccionada != null && cantidadCtrl.text.isNotEmpty) {
                      final cantidad = double.tryParse(cantidadCtrl.text) ?? 1.0;
                      
                      // Descontar inventario
                      if (recetaSeleccionada!.ingredientes != null) {
                        for (var ing in recetaSeleccionada!.ingredientes!) {
                          final mpIndex = DummyDb.instance.materiasPrimas.indexWhere(
                              (m) => m.idmateriaprima == ing.idmateriaprima);
                          if (mpIndex != -1) {
                            final mp = DummyDb.instance.materiasPrimas[mpIndex];
                            final nuevaCantidad = mp.cantidaddisponible - (ing.cantidadnecesaria * cantidad);
                            DummyDb.instance.materiasPrimas[mpIndex] = mp.copyWith(cantidaddisponible: nuevaCantidad);
                          }
                        }
                      }

                      setState(() {
                        _historial.insert(0, {
                          'id': DateTime.now().millisecondsSinceEpoch.toString(),
                          'receta': recetaSeleccionada!.nombre,
                          'cantidad': cantidad.toInt(),
                          'merma': int.tryParse(mermaCtrl.text) ?? 0,
                          'fecha': 'Justo ahora',
                          'panadero': 'Usuario Actual',
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Producción registrada. Inventario actualizado automáticamente.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('GUARDAR PRODUCCIÓN'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Producción y Mermas'),
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de Horneadas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _historial.length,
                itemBuilder: (context, index) {
                  final item = _historial[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.success.withOpacity(0.2),
                        child: const Icon(Icons.bakery_dining, color: AppColors.success),
                      ),
                      title: Text(item['receta'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Producción: ${item['cantidad']} piezas | Merma: ${item['merma']} piezas'),
                          const SizedBox(height: 2),
                          Text('Fecha: ${item['fecha']} | Por: ${item['panadero']}', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormularioProduccion(context),
        backgroundColor: AppColors.success,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nueva Horneada', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
