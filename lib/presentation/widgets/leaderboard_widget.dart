import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filter/core/setup_dependencies.dart';
import 'package:flutter_image_filter/presentation/controllers/leaderboard_controller.dart';
import 'package:flutter_image_filter/presentation/controllers/leaderboard_state.dart';
import 'package:flutter_image_filter/presentation/pages/history_page.dart';

class ResultWidget extends StatefulWidget {
  const ResultWidget({super.key});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = locator.get<LeaderboardController>();

    return Column(
      spacing: 16,
      children: [
        Text("Resultados", style: Theme.of(context).textTheme.titleMedium),
        BlocConsumer<LeaderboardController, LeaderboardState>(
          bloc: controller,
          listener: (context, state) {},
          builder: (context, state) {
            if (state is LeaderboardLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is LeaderboardLoaded) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: state.list.length,
                itemBuilder: (_, i) {
                  final e = state.list[i];
                  return Card(
                    child: ListTile(
                      title: Text('${e.processingTimeMs}ms'),
                      subtitle: Text(e.language),
                      trailing: TextButton(
                        child: const Text('ver mais'),
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => HistoryPage(filterName: e.language),
                              ),
                            ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is LeaderboardError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Nenhum dado ainda'));
          },
        ),
      ],
    );
  }
}
