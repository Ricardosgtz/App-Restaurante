import 'package:equatable/equatable.dart';

class ClientHomeState extends Equatable {
  final int pageIndex;
  final bool isLoggedOut;

  const ClientHomeState({this.pageIndex = 0, this.isLoggedOut = false});

  ClientHomeState copyWith({int? pageIndex, bool? isLoggedOut}) {
    return ClientHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
    );
  }

  @override
  List<Object?> get props => [pageIndex, isLoggedOut];
}
