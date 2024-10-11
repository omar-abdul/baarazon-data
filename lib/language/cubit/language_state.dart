part of 'language_cubit.dart';

enum Language { english, somali }

@immutable
sealed class LanguageState {
  final Language? language;
  const LanguageState({this.language});
}

final class LanguageInitial extends LanguageState {
  const LanguageInitial() : super(language: null);
}

final class LanguageChanged extends LanguageState {
  const LanguageChanged({required Language language})
      : super(language: language);
}
