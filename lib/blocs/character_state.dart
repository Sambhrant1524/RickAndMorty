import 'package:equatable/equatable.dart';
import '../models/character.dart';
import '../models/pagination_info.dart';

enum CharacterStatus { initial, success, failure, loading }

class CharacterState extends Equatable {
  final CharacterStatus status;
  final List<Character> characters;
  final PaginationInfo? paginationInfo;
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;

  const CharacterState({
    this.status = CharacterStatus.initial,
    this.characters = const <Character>[],
    this.paginationInfo,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,
  });

  CharacterState copyWith({
    CharacterStatus? status,
    List<Character>? characters,
    PaginationInfo? paginationInfo,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
  }) {
    return CharacterState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      paginationInfo: paginationInfo ?? this.paginationInfo,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        characters,
        paginationInfo,
        hasReachedMax,
        currentPage,
        errorMessage,
      ];
}