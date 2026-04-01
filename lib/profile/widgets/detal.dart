import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app2/auth/bloc/sandyq_list_bloc.dart';
import 'package:flutter_app2/models/models.dart';

class Detal extends StatefulWidget {
  final ReasstaransList restaurant;
  final int index;
  final SandyqListBloc bloc;

  const Detal({
    super.key,
    required this.restaurant,
    required this.index,
    required this.bloc,
  });

  @override
  State<Detal> createState() => _DetalState();
}

class _DetalState extends State<Detal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 240.0,
            floating: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Image.network(
                    widget.restaurant.imageurl ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        widget.restaurant.name ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Color.fromRGBO(255, 255, 255, 1),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: BlocBuilder<SandyqListBloc, SandyqListState>(
                      bloc: widget.bloc,
                      builder: (context, state) {
                        return IconButton(
                          onPressed: () {
                            final originalIndex = widget.bloc.restaurants
                                .indexWhere(
                                  (r) => r.id == widget.restaurant.id,
                                );
                            if (originalIndex != -1) {
                              widget.bloc.add(
                                FetchReasstaranslike(originalIndex),
                              );
                            }
                          },
                          icon: Icon(
                            widget.restaurant.like
                                ? Icons.favorite_sharp
                                : Icons.favorite_border_sharp,
                            color: widget.restaurant.like ? Colors.red : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Описание",
                    style: TextStyle(
                      color: Color.fromRGBO(146, 146, 146, 1),
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.restaurant.detal ?? '',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 1),
                    child: TextButton(
                      child: Text(
                        "Подробнее",
                        style: TextStyle(
                          color: Color.fromRGBO(70, 48, 210, 1),
                          fontSize: 13,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: const Color.fromRGBO(255, 202, 202, 202),
                  ),
                  Stack(
                    children: [
                      Icon(Icons.timer),
                      Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Text(
                          "Работаем с 08:00 до 18:00",
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Stack(
                    children: [
                      Icon(Icons.vertical_align_bottom_rounded),
                      Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Text(
                          widget.restaurant.address ?? '',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
