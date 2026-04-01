// ignore: unused_import
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app2/models/models.dart';
import 'package:flutter_app2/models/searc_user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'sandyq_list_event.dart';
part 'sandyq_list_state.dart';

class SandyqListBloc extends Bloc<SandyqListEvent, SandyqListState> {
  final PostRepository postRepository;
  List<ReasstaransList> restaurants = [];

  SandyqListBloc({required this.postRepository}) : super(SandyqListState()) {
    on<FetchReasstarans>(_onFetchReasstarans);
    on<FetchReasstaranslike>(_onFetchReasstaranslike);
    on<FetchFavorites>(_onFetchFavorites);
    on<Searchrestaurant>(_onSearchRestaurant);
  }

  Future<void> _saveFavoritesToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final favorites = restaurants
        .where((r) => r.like)
        .map((r) => r.id)
        .toList();
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'favorites': favorites,
    }, SetOptions(merge: true));
  }

  Future<void> _loadFavoritesFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (doc.exists) {
      final data = doc.data();
      final favorites = List<String>.from(data?['favorites'] ?? []);
      for (var restaurant in restaurants) {
        restaurant.like = favorites.contains(restaurant.id);
      }
    }
  }

  Future<void> _onFetchReasstarans(
    FetchReasstarans event,
    Emitter<SandyqListState> emit,
  ) async {
    emit(SandyqListState.loading());
    try {
      final users = await postRepository.fetchReasstarans();
      restaurants = users;
      try {
        await _loadFavoritesFromFirestore();
      } catch (e) {
        // Ignore errors in loading favorites, continue with restaurants without like status
      }
      emit(SandyqListState.loaded(restaurants));
    } catch (e) {
      emit(SandyqListState.error('Failed to load restaurants', e));
      emit(SandyqListStateError('Failed to load restaurants'));
    }
  }

  Future<void> _onFetchReasstaranslike(
    FetchReasstaranslike event,
    Emitter<SandyqListState> emit,
  ) async {
    try {
      final restaurant = restaurants[event.index];
      restaurant.like = !restaurant.like;
      emit(SandyqListState.loaded(restaurants));
      try {
        await _saveFavoritesToFirestore();
      } catch (e) {
        // Ignore errors in saving favorites
      }
    } catch (e) {
      emit(SandyqListState.error('Failed to update like status', e));
    }
  }

  Future<void> _onFetchFavorites(
    FetchFavorites event,
    Emitter<SandyqListState> emit,
  ) async {
    try {
      final favoriteRestaurants = restaurants.where((restaurant) {
        return restaurant.like == true;
      }).toList();

      emit(SandyqListState.loaded(restaurants, favorites: favoriteRestaurants));
    } catch (e) {
      emit(SandyqListState.error('Failed to load favorite restaurants', e));
    }
  }

  Future<void> _onSearchRestaurant(
    Searchrestaurant event,
    Emitter<SandyqListState> emit,
  ) async {
    if (event.query.length > 2) {
      try {
        List<ReasstaransList> res = [];
        for (var restaurant in restaurants) {
          if (restaurant.name!.toLowerCase().contains(
            event.query.toLowerCase(),
          )) {
            res.add(restaurant);
          }
        }
        emit(SandyqListState.loaded(res));
      } catch (e) {
        emit(SandyqListState.error('Failed to search restaurants: $e', e));
      }
    } else {
      emit(SandyqListState.loaded(restaurants));
    }
  }
}
