import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import '../repositories/character_repository.dart';
import 'character_event.dart';
import 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository characterRepository;
  
  CharacterBloc({required this.characterRepository}) : super(const CharacterState()) {
    on<CharacterFetched>(_onCharacterFetched);
    on<CharacterRefreshed>(_onCharacterRefreshed);
  }

  Future<void> _onCharacterFetched(
    CharacterFetched event,
    Emitter<CharacterState> emit,
  ) async {
    if (state.hasReachedMax) return;
    
    try {
      if (state.status == CharacterStatus.initial) {
        emit(state.copyWith(status: CharacterStatus.loading));
        final result = await characterRepository.fetchCharacters();
        return emit(
          state.copyWith(
            status: CharacterStatus.success,
            characters: result['characters'],
            paginationInfo: result['info'],
            currentPage: 1,
            hasReachedMax: result['info'].next == null,
          ),
        );
      }

      emit(state.copyWith(status: CharacterStatus.loading));
      final nextPage = state.currentPage + 1;
      final result = await characterRepository.fetchCharacters(page: nextPage);
      
      emit(
        state.copyWith(
          status: CharacterStatus.success,
          characters: [...state.characters, ...result['characters']],
          paginationInfo: result['info'],
          currentPage: nextPage,
          hasReachedMax: result['info'].next == null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: CharacterStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCharacterRefreshed(
    CharacterRefreshed event,
    Emitter<CharacterState> emit,
  ) async {
    emit(const CharacterState());
    add(CharacterFetched());
  }
}