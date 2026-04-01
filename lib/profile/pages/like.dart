import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app2/auth/bloc/sandyq_list_bloc.dart';
// ignore: unused_import
import 'package:flutter_app2/models/models.dart';
import 'package:flutter_app2/profile/widgets/tapew.dart';

class Like extends StatefulWidget {
  const Like({super.key, required this.index});
  final int index;
  @override
  State<Like> createState() => _LikeState();
}

class _LikeState extends State<Like> {
  @override
  void initState() {
    super.initState();
    context.read<SandyqListBloc>().add(FetchFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранные рестораны'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<SandyqListBloc, SandyqListState>(
        builder: (context, state) {
          if (state is SandyqListStateError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }

          final favoriteRestaurants = state.favorites;

          if (favoriteRestaurants.isEmpty) {
            return Center(child: Text('Нет избранных ресторанов.'));
          }
          return Tapew(users: favoriteRestaurants, index: widget.index);
        },
      ),
    );
  }
}
