import 'dart:async';
import 'dart:developer';
import 'package:checkmate/features/bookings/domain/entities/get_lab_search_req_entity.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_bloc.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_event.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_state.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => s1<LabsBloc>(),
      child: SearchTestPage(),
    );
  }
}

class SearchTestPage extends StatefulWidget {
  const SearchTestPage({super.key});

  @override
  State<SearchTestPage> createState() => _SearchTestPageState();
}

class _SearchTestPageState extends State<SearchTestPage> {
  final TextEditingController textEditingController = TextEditingController();
  Timer? _debounce;
  List<String> names = ['jithu', 'abhi'];

  void onSearch(String quwey) {
    _debounce?.cancel();
    if (quwey.isEmpty) {
      names = [];
      return;
    }
    _debounce = Timer(Duration(milliseconds: 400), () {
      _perfSearch(quwey);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              BlocBuilder<LabsBloc, LabsState>(
                builder: (context, state) {
                  if (state is LabsLoading) {
                    return CircularProgressIndicator();
                  }
                  if (state is LabsLoaded) {
                    return Column(
                      children: [
                        Text(state.tests.length.toString()),
                        TextField(
                          controller: textEditingController,
                          onChanged: onSearch,
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      TextField(
                        controller: textEditingController,
                        onChanged: onSearch,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _perfSearch(String quwey) async {
    log('called search');
    context.read<LabsBloc>().add(
      SearchTestsEvent(GetSearchResultRequestEntity(query: quwey)),
    );
  }
}
