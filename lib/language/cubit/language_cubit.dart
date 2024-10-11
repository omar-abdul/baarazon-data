import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageInitial());

  void changeLanguage(Language language) {
    emit(LanguageChanged(language: language));
  }
}
