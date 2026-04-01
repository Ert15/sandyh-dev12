import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app2/auth/bloc/sandyq_list_bloc.dart';
import 'package:flutter_app2/profile/widgets/tapew.dart';

class Tape extends StatefulWidget {
  const Tape({super.key, required this.index});
  final int index;

  @override
  State<Tape> createState() => _TapeState();
}

class _TapeState extends State<Tape> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10.0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 249, 249),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<SandyqListBloc>().add(FetchReasstarans());
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  TextField(
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      hintText: "Поиск",
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(167, 166, 166, 1),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 14,
                      ),

                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    onChanged: (value) {
                      context.read<SandyqListBloc>().add(
                        Searchrestaurant(value),
                      );
                    },
                  ),
                  const Icon(
                    Icons.search,
                    color: Color.fromRGBO(195, 195, 195, 1),
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<SandyqListBloc, SandyqListState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.message.isNotEmpty) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  if (state.users.isNotEmpty) {
                    final users = state.users;

                    return Tapew(users: users, index: widget.index);
                  }
                  return const Center(child: Text('No restaurants found.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
