import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/sync_service.dart';

enum SyncStatus { initial, syncing, success, error }

class SyncState {
  final SyncStatus status;
  final String? error;

  SyncState({required this.status, this.error});
}

class SyncCubit extends Cubit<SyncState> {
  final SyncService _syncService;

  SyncCubit(this._syncService) : super(SyncState(status: SyncStatus.initial));

  Future<void> sync() async {
    emit(SyncState(status: SyncStatus.syncing));

    try {
      await _syncService.syncAll();
      emit(SyncState(status: SyncStatus.success));
    } catch (e) {
      emit(SyncState(status: SyncStatus.error, error: e.toString()));
    }
  }
}
