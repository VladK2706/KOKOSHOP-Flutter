class ProductosCarrito {
   final int id_carrito;
   final int id_producto;
   final int cantidad_product;

   ProductosCarrito({
      required this.id_carrito,
      required this.id_producto,
      required this.cantidad_product,
   });

   Map<String, dynamic> toMap() {
      return {
         'id_carrito': id_carrito,
         'id_producto': id_producto,
         'cantidad_product': cantidad_product,
      };
   }

   factory ProductosCarrito.fromMap(Map<String, dynamic> map) {
      return ProductosCarrito(
         id_carrito: map['id_carrito'] as int? ?? 0,
         id_producto: map['id_producto'] as int? ?? 0,
         cantidad_product: map['cantidad_product'] as int? ?? 0,
      );
   }
}
