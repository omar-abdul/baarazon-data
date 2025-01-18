import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectionStatus { connected, disconnected }

class ConnectivityCubit extends Cubit<ConnectionStatus> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityCubit() : super(ConnectionStatus.connected) {
    _subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.none)) {
      emit(ConnectionStatus.disconnected);
    }

    // Double check for actual internet connection
    final hasInternet = await (Connectivity().checkConnectivity());
    emit(hasInternet.contains(ConnectivityResult.none)
        ? ConnectionStatus.disconnected
        : ConnectionStatus.connected);
  }

  Future<bool> checkInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      emit(ConnectionStatus.disconnected);
      return false;
    }

    final hasInternet = await (Connectivity().checkConnectivity());
    emit(hasInternet.contains(ConnectivityResult.none)
        ? ConnectionStatus.disconnected
        : ConnectionStatus.connected);
    return true;
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
