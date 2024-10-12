import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'phone_number_state.dart';

class PhoneNumberCubit extends Cubit<PhoneNumberState> {
  PhoneNumberCubit() : super(const PhoneNumber(phoneNumber: null));

  void changePhoneNumber(String phoneNumber) {
    emit(PhoneNumber(phoneNumber: phoneNumber));
  }
}
