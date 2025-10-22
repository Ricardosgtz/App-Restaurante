import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/models/Category.dart';
import 'package:flutter_application_1/src/domain/models/Product.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/ClientProductListItem.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/bloc/ClientProductListBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/bloc/ClientProductListEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/product/list/bloc/ClientProductListState.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeAppBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ClientProductListPage extends StatefulWidget {
  const ClientProductListPage({super.key});

  @override
  State<ClientProductListPage> createState() => _ClientProductListPageState();
}

class _ClientProductListPageState extends State<ClientProductListPage> {
  ClientProductListBloc? _bloc;
  Category? category;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (category != null) {
        _bloc?.add(GetProductsByCategory(idCategory: category!.id!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    category = ModalRoute.of(context)?.settings.arguments as Category;
    _bloc = BlocProvider.of<ClientProductListBloc>(context);

    return Scaffold(
      appBar: HomeAppBar(title: category?.name ?? 'Productos'),
      body: BlocListener<ClientProductListBloc, ClientProductListState>(
        listener: (context, state) {
          final responseState = state.response;
          if (responseState is Success) {
            if (responseState.data is bool) {
              _bloc?.add(GetProductsByCategory(idCategory: category!.id!));
            }
          } else if (responseState is Error) {
            Fluttertoast.showToast(
              msg: responseState.message,
              toastLength: Toast.LENGTH_LONG,
            );
          }
        },
        child: BlocBuilder<ClientProductListBloc, ClientProductListState>(
          builder: (context, state) {
            final responseState = state.response;

            if (responseState is Loading) {
              return const Center(
                child: SpinKitThreeBounce(
                  color: Colors.orange,
                  size: 30,
                  duration: Duration(seconds: 1),
                ),
              );
            }

            if (responseState is Success) {
              List<Product> products = responseState.data as List<Product>;

              return RefreshIndicator(
                color: Colors.orange,
                onRefresh: () async {
                  // 🔄 Dispara el evento de refresco
                  _bloc?.add(RefreshProducts(idCategory: category!.id!));
                  await Future.delayed(const Duration(seconds: 1));
                  Fluttertoast.showToast(
                    msg: "Productos Actualizados",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER_LEFT,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child:
                    products.isEmpty
                        ? const Center(
                          child: Text(
                            'No hay productos disponibles',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                        : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ClientProductListItem(
                              _bloc,
                              products[index],
                            );
                          },
                        ),
              );
            }

            // Si no hay respuesta todavía
            return const Center(child: Text('Cargando productos...'));
          },
        ),
      ),
    );
  }
}
