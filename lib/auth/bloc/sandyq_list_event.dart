// sandyq_list_event.dart

part of 'sandyq_list_bloc.dart';

abstract class SandyqListEvent {}

class FetchReasstarans extends SandyqListEvent {}

class FetchReasstaranslike extends SandyqListEvent {
  final int index;
  FetchReasstaranslike(this.index);
}

class FetchFavorites extends SandyqListEvent {}

class FavoritesUpdatedState extends SandyqListState {
  final List<ReasstaransList> favorites;

  FavoritesUpdatedState(this.favorites);
}

class Searchrestaurant extends SandyqListEvent {
  final String query;

  Searchrestaurant(this.query);
}


class favoriteRestaurants extends SandyqListEvent {
  final List<ReasstaransList> favorites;
  favoriteRestaurants(this.favorites);
}

class UpdateFavorites extends SandyqListEvent {
  final List<ReasstaransList> favorites;
  UpdateFavorites(this.favorites);
}
