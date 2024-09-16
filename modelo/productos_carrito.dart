class productosCarrito {
   int? id_carrito;  // Cambiado a opcional
   int id_producto;
   int cantidad_product;

   productosCarrito({
      this.id_carrito,  // Ya no es requerido
      required this.id_producto,
      required this.cantidad_product,
   });

   factory productosCarrito.fromMap(Map<String, dynamic> json) => productosCarrito(
      id_carrito: json['id_carrito'],
      id_producto: json['id_producto'],
      cantidad_product: json['cantidad_product'],
   );

   Map<String, dynamic> toMap() => {
      'id_carrito': id_carrito,
      'id_producto': id_producto,
      'cantidad_product': cantidad_product,
   };
}
