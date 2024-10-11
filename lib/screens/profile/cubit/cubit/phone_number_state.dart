part of 'phone_number_cubit.dart';

@immutable
sealed class PhoneNumberState {
  final String? phoneNumber;
  const PhoneNumberState({this.phoneNumber});
}

final class PhoneNumber extends PhoneNumberState {
  const PhoneNumber({super.phoneNumber});
}
