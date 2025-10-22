import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/domain/models/Cliente.dart';
import 'package:flutter_application_1/src/domain/utils/Resource.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/info/bloc/ProfileInfoBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/info/bloc/ProfileInfoEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/ProfileUpdateContent.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/bloc/ProfileUpdateEvent.dart';
import 'package:flutter_application_1/src/presentation/pages/profile/update/bloc/ProfileUpdateState.dart';
import 'package:flutter_application_1/src/presentation/widgets/HomeAppBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/src/presentation/utils/AlertHelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  ProfileUpdateBloc? _bloc;
  Cliente? cliente;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _bloc?.add(ProfileUpdateInitEvent(cliente: cliente));
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ProfileUpdateBloc>(context);
    cliente = ModalRoute.of(context)?.settings.arguments as Cliente?;

    return Scaffold(
      appBar: HomeAppBar(title: 'Actualizar Perfil'),
      body: BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
        listener: (context, state) async {
          final responseState = state.response;

          if (responseState is Error) {
            // Mostrar error con AlertHelper
            await AlertHelper.showAlertDialog(
              context: context,
              title: "Error",
              message: responseState.message,
              isSuccess: false,
            );
          } else if (responseState is Success) {
            Cliente cliente = responseState.data as Cliente;
            _bloc?.add(ProfileUpdateUpdateUserSession(cliente: cliente));

            Future.delayed(const Duration(seconds: 1), () {
              context.read<ProfileInfoBloc>().add(ProfileInfoGetUser());
            });

            // Mostrar éxito con AlertHelper
            await AlertHelper.showAlertDialog(
              context: context,
              title: "¡Éxito!",
              message: "Actualización exitosa del perfil.",
              isSuccess: true,
              onClose: () {
                Navigator.of(
                  context,
                ).pop(); // opcional: cerrar página si quieres
              },
            );
          }
        },
        child: BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
          builder: (context, state) {
            final responseState = state.response;
            if (responseState is Loading) {
              return Stack(
                children: [
                  ProfileUpdateContent(_bloc, state, cliente),
                  const Center(
                    child: SpinKitThreeBounce(
                      color: Colors.orange,
                      size: 30,
                      duration: Duration(seconds: 1),
                    ),
                  ),
                ],
              );
            }
            return ProfileUpdateContent(_bloc, state, cliente);
          },
        ),
      ),
    );
  }
}
