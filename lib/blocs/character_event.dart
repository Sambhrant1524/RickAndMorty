import 'package:equatable/equatable.dart';

abstract class CharacterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CharacterFetched extends CharacterEvent {}

class CharacterRefreshed extends CharacterEvent {}