import 'package:flutter_bloc/flutter_bloc.dart';
import './region_enum.dart';
import '../../constants.dart';

class RegionState {
  final Regions regionName;
  RegionState(this.regionName);
}

class RegionCubit extends Cubit<RegionState> {
  RegionCubit() : super(RegionState(Regions.puntland));

  Future<void> initialize() async {
    final region = await getEnumFromIndex();
    emit(RegionState(region!));
  }

  void changeRegion(Regions region) async {
    await saveEnumAsIndex(region);
    emit(RegionState(region));
  }
}
