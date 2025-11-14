import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Category.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/category/list/ClientCategoryListItem.dart';
import 'package:flutter_application_1/src/presentation/pages/client/category/list/bloc/ClientCategoryListBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/category/list/bloc/ClientCategoryListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/category/list/bloc/ClientCategoryListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart'; // 🔸 Para AppTheme.primaryColor

class ClientCategoryListPage extends StatefulWidget {
  const ClientCategoryListPage({super.key});

  @override
  State<ClientCategoryListPage> createState() => _ClientCategoryListPageState();
}

class _ClientCategoryListPageState extends State<ClientCategoryListPage> {
  late ClientCategoryListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ClientCategoryListBloc>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(GetCategories(context));
      _checkAndShowHint();
    });
  }

  /// Verifica si el aviso ya se mostró antes
  Future<void> _checkAndShowHint() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenHint = prefs.getBool('hasSeenCategoryHint') ?? false;

    if (!hasSeenHint) {
      await Future.delayed(const Duration(milliseconds: 600)); // Espera breve
      _showHintDialog(context);
      prefs.setBool('hasSeenCategoryHint', true);
    }
  }

  /// 🍜 Diálogo elegante de aviso (versión categorías)
  void _showHintDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Solo se cierra con el botón
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🍲 Ícono circular con degradado naranja
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.ramen_dining_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),

                const SizedBox(height: 20),

                //Título principal
                Text(
                  '¡Explora las categorías!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                // 📝 Texto explicativo
                Text(
                  'Toca el botón “Ver menú” para descubrir los productos disponibles en cada categoría.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                //Botón "Entendido"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Entendido',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<ClientCategoryListBloc, ClientCategoryListState>(
        listener: (context, state) {
          final responseState = state.response;
          if (responseState is Success && responseState.data is bool) {
            _bloc.add(GetCategories(context));
          }
          if (responseState is Error) {
            Fluttertoast.showToast(
              msg: responseState.message,
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        child: BlocBuilder<ClientCategoryListBloc, ClientCategoryListState>(
          builder: (context, state) {
            final responseState = state.response;

            if (responseState is Success) {
              final categories = responseState.data as List<Category>;

              if (categories.isEmpty) {
                return Center(
                  child: Text(
                    'No hay categorías disponibles',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 15,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ClientCategoryListItem(_bloc, categories[index]),
                  );
                },
              );
            }

            // Pantalla de carga elegante
            return _buildLoadingScreen();
          },
        ),
      ),
    );
  }

  /// Pantalla de carga con animación y texto
  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitThreeBounce(
              color: Colors.orange,
              size: 35,
              duration: Duration(milliseconds: 1200),
            ),
            const SizedBox(height: 20),
            Text(
              'Cargando categorías...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
