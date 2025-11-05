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
    });
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
                return const Center(
                  child: Text(
                    'No hay categorías disponibles',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.60,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ClientCategoryListItem(_bloc, categories[index]);
                },
              );
            }

            // 🔄 Pantalla de carga elegante
            return _buildLoadingScreen();
          },
        ),
      ),
    );
  }

  /// 🧡 Pantalla de carga con animación y texto
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
