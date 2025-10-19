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
    final primaryColor = AppTheme.primaryColor;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🖼 Imagen de la categoría
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  image: (category?.image != null &&
                          category!.image!.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(category!.image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: (category?.image == null || category!.image!.isEmpty)
                      ? primaryColor.withOpacity(0.08)
                      : null,
                ),
                child: (category?.image == null || category!.image!.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 36,
                              color: primaryColor.withOpacity(0.7),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Sin imagen',
                              style: GoogleFonts.poppins(
                                color: primaryColor.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),

            // 📄 Contenido (nombre, descripción y botón)
            Expanded(
              flex: 4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      primaryColor.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Nombre
                    Text(
                      category?.name ?? '',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: theme.textTheme.titleLarge?.color ??
                            Colors.grey.shade800,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // 📝 Descripción
                    Expanded(
                      child: Text(
                        category?.description ?? '',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: 11.5,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // 🍽 Botón “Ver menú”
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'client/product/list',
                            arguments: category,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                const Color(0xFFFFB300),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.fastfood_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Ver menú',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
