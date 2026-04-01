part of 'sandyq_list_bloc.dart';

class SandyqListState {
  final List<ReasstaransList> users;
  final List<ReasstaransList> favorites;
  final String message;
  final bool isLoading;

  SandyqListState({
    this.users = const [],
    this.favorites = const [],
    this.message = '',
    this.isLoading = false,
    final Object? exception,
  });
  SandyqListState copyWith({
    List<ReasstaransList>? users,
    List<ReasstaransList>? favorites,
    String? message,
    bool? isLoading,
    Object? exception,
  }) {
    return SandyqListState(
      users: users ?? this.users,
      favorites: favorites ?? this.favorites,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory SandyqListState.loaded(
    List<ReasstaransList> users, {
    List<ReasstaransList>? favorites,
  }) {
    return SandyqListState(
      users: users,
      favorites: favorites ?? users.where((r) => r.like).toList(),
      isLoading: false,
    );
  }

  factory SandyqListState.error(String message, Object? exception) {
    return SandyqListState(
      message: message,
      isLoading: false,
      exception: exception,
    );
  }

  factory SandyqListState.loading() {
    return SandyqListState(isLoading: true);
  }
}

class SandyqListStateError extends SandyqListState {
  final Object? exception;

  SandyqListStateError(this.exception);
}
