import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app2/auth/bloc/sandyq_list_bloc.dart';
import 'package:flutter_app2/profile/widgets/detal.dart';

class Tapew extends StatelessWidget {
  const Tapew({super.key, required this.users, required this.index});
  final List<dynamic> users;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10.0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 249, 249),
      ),
      body: ListView.builder(
        key: UniqueKey(),
        physics: BouncingScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final restaurant = users[index];
          return Card(
            key: ValueKey(restaurant.id),
            color: Color.fromRGBO(254, 254, 254, 1),
            elevation: 10,
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: Colors.white,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      final bloc = context.read<SandyqListBloc>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detal(
                            restaurant: restaurant,
                            index: index,
                            bloc: bloc,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Ink.image(
                          image: NetworkImage(restaurant.imageurl ?? ""),
                          width: 400,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    restaurant.name ?? "",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      final bloc = context
                                          .read<SandyqListBloc>();
                                      final originalIndex = bloc.restaurants
                                          .indexWhere(
                                            (r) => r.id == restaurant.id,
                                          );
                                      if (originalIndex != -1) {
                                        bloc.add(
                                          FetchReasstaranslike(originalIndex),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      restaurant.like
                                          ? Icons.favorite_sharp
                                          : Icons.favorite_border_sharp,
                                      color: restaurant.like
                                          ? Colors.red
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                restaurant.detal ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 5),
                              Text(
                                restaurant.address ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
