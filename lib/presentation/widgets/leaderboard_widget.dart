import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filter/core/setup_dependencies.dart';
import 'package:flutter_image_filter/presentation/controllers/leaderboard_controller.dart';
import 'package:flutter_image_filter/presentation/controllers/leaderboard_state.dart';
import 'package:flutter_image_filter/presentation/widgets/leader_board_card.dart';

class ResultWidget extends StatefulWidget {
  const ResultWidget({super.key});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  final controller = locator.get<LeaderboardController>();

  @override
  void initState() {
    controller.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: state.list.length,
                itemBuilder: (_, i) {
                  return LeaderBoardCard(filter: state.list[i]);
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
