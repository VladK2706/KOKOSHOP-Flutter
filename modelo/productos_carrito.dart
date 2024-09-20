class productosCarrito {
   final int id_carrito;
   final int id_producto;
   final int cantidad_product;

   productosCarrito({
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

   factory productosCarrito.fromMap(Map<String, dynamic> map) {
      return productosCarrito(
         id_carrito: map['id_carrito'],
         id_producto: map['id_producto'],
         cantidad_product: map['cantidad_product'],
      );
   }
}
