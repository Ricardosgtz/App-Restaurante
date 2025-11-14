import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Category.dart';
import 'package:flutter_application_1/src/presentation/pages/client/category/list/bloc/ClientCategoryListBloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientCategoryListItem extends StatelessWidget {
  final ClientCategoryListBloc? bloc;
  final Category? category;

  const ClientCategoryListItem(this.bloc, this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    const orangeColor = Color(0xFFFF9800);
    bool _isPressed = false;
    final primaryColor = AppTheme.primaryColor;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade300, // ✅ Borde gris suave
          width: 1.2, // grosor del borde
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400.withOpacity(0.6), // ✅ sombra gris clara
            blurRadius: 10, // qué tan difusa
            spreadRadius: 3, // leve expansión
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔸 Imagen de la categoría
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.25),
                      primaryColor.withOpacity(0.25),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child:
                    category?.image != null && category!.image!.isNotEmpty
                        ? Image.network(
                          category!.image!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Icon(
                                Icons.photo,
                                color: Colors.white,
                                size: 50,
                              ),
                        )
                        : Icon(
                          Icons.photo,
                          color: Colors.grey,
                          size: 50,
                        ),
              ),
            ),

            const SizedBox(width: 18),

            // 🔸 Texto y botón
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category?.name ?? 'Categoría',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    category?.description ??
                        'Descubre deliciosas opciones disponibles.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.left,
                    //maxLines: 2,
                    //overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // 🔸 Botón “Ver más”
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'client/product/list',
                          arguments: category,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _isPressed
                                  ? AppTheme.primaryColor.withOpacity(0.2)
                                  : AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ver Mas',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
