import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends UsersEvent {
  final int page;

  const FetchUsers({this.page = 1});

  @override
  List<Object?> get props => [page];
}