import 'models/materia_prima_model.dart';
import 'models/receta_model.dart';

class DummyDb {
  static final DummyDb instance = DummyDb._internal();

  DummyDb._internal();

  List<MateriaPrima> materiasPrimas = [
    MateriaPrima(idmateriaprima: 1, nombre: 'Harina de Trigo', unidadmedida: 'Kg', cantidaddisponible: 120.0, cantidadminima: 50.0, costoporkilo: 18.5, categoria: 'Harina'),
    MateriaPrima(idmateriaprima: 2, nombre: 'Azúcar Refinada', unidadmedida: 'Kg', cantidaddisponible: 45.0, cantidadminima: 20.0, costoporkilo: 22.0, categoria: 'Azúcar'),
    MateriaPrima(idmateriaprima: 3, nombre: 'Levadura Seca', unidadmedida: 'Kg', cantidaddisponible: 4.0, cantidadminima: 5.0, costoporkilo: 120.0, categoria: 'Levadura'),
    MateriaPrima(idmateriaprima: 4, nombre: 'Mantequilla', unidadmedida: 'Kg', cantidaddisponible: 15.0, cantidadminima: 10.0, costoporkilo: 85.0, categoria: 'Lácteos'),
    MateriaPrima(idmateriaprima: 5, nombre: 'Huevo', unidadmedida: 'Kg', cantidaddisponible: 8.0, cantidadminima: 10.0, costoporkilo: 45.0, categoria: 'Lácteos'),
    MateriaPrima(idmateriaprima: 6, nombre: 'Sal Fina', unidadmedida: 'Kg', cantidaddisponible: 12.0, cantidadminima: 5.0, costoporkilo: 15.0, categoria: 'Otros'),
    MateriaPrima(idmateriaprima: 7, nombre: 'Leche Entera', unidadmedida: 'Litros', cantidaddisponible: 25.0, cantidadminima: 15.0, costoporkilo: 24.0, categoria: 'Lácteos'),
  ];

  List<Receta> recetas = [
    Receta(
      idreceta: 1, 
      nombre: 'Concha Vainilla', 
      categoria: 'Pan dulce',
      pasos: '1. Mezclar ingredientes secos.\n2. Añadir líquidos.\n3. Amasar por 15 min.\n4. Dejar reposar.\n5. Hornear a 180°C por 20 min.',
      ingredientes: [
        IngredienteReceta(idreceta: 1, idmateriaprima: 1, cantidadnecesaria: 1.0, nombreMateriaPrima: 'Harina de Trigo', unidadmedida: 'Kg'),
        IngredienteReceta(idreceta: 1, idmateriaprima: 2, cantidadnecesaria: 0.2, nombreMateriaPrima: 'Azúcar Refinada', unidadmedida: 'Kg'),
        IngredienteReceta(idreceta: 1, idmateriaprima: 4, cantidadnecesaria: 0.15, nombreMateriaPrima: 'Mantequilla', unidadmedida: 'Kg'),
      ]
    ),
    Receta(
      idreceta: 2, 
      nombre: 'Bolillo', 
      categoria: 'Pan salado',
      pasos: '1. Activar levadura.\n2. Mezclar con harina y sal.\n3. Amasar hasta punto de ventana.\n4. Hornear con vapor a 200°C.',
      ingredientes: [
        IngredienteReceta(idreceta: 2, idmateriaprima: 1, cantidadnecesaria: 2.0, nombreMateriaPrima: 'Harina de Trigo', unidadmedida: 'Kg'),
        IngredienteReceta(idreceta: 2, idmateriaprima: 3, cantidadnecesaria: 0.05, nombreMateriaPrima: 'Levadura Seca', unidadmedida: 'Kg'),
        IngredienteReceta(idreceta: 2, idmateriaprima: 6, cantidadnecesaria: 0.04, nombreMateriaPrima: 'Sal Fina', unidadmedida: 'Kg'),
      ]
    ),
    Receta(
      idreceta: 3, 
      nombre: 'Pastel de Chocolate', 
      categoria: 'Pastel',
      pasos: '1. Precalentar horno a 170°C.\n2. Mezclar cacao con harina.\n3. Añadir huevos y leche.\n4. Hornear por 45 min.',
      ingredientes: [],
    ),
  ];
}
