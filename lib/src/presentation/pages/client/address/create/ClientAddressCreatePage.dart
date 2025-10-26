import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeAppBar.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/ClientAddressCreateContent.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/create/bloc/ClientAddressCreateState.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/address/list/bloc/ClientAddressListEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/presentation/utils/AlertHelper.dart';

class ClientAddressCreatePage extends StatefulWidget {
  const ClientAddressCreatePage({super.key});

  @override
  State<ClientAddressCreatePage> createState() => _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {
  ClientAddressCreateBloc? _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ClientAddressCreateBloc>(context);

    return Scaffold(
      appBar: HomeAppBar(title: 'Agrega Una Nueva Dirección'),
      body: BlocListener<ClientAddressCreateBloc, ClientAddressCreateState>(
        listener: (context, state) async {
          final responseState = state.response;

          if (responseState is Success) {
            // Actualiza la lista de direcciones
            context.read<ClientAddressListBloc>().add(GetUserAddress(context));

            // Muestra AlertDialog de éxito
            await AlertHelper.showAlertDialog(
              context: context,
              title: "¡Éxito!",
              message: "La dirección fue creada correctamente.",
              isSuccess: true,
              onClose: () {
                Navigator.pop(context); // Regresa a la lista de direcciones
              },
            );
          } 
          else if (responseState is Error) {
            // Muestra AlertDialog de error
            await AlertHelper.showAlertDialog(
              context: context,
              title: "Error",
              message: responseState.message,
              isSuccess: false,
            );
          }
        },
        child: BlocBuilder<ClientAddressCreateBloc, ClientAddressCreateState>(
          builder: (context, state) {
            return ClientAddressCreateContent(_bloc, state);
          },
        ),
      ),
    );
  }
}
