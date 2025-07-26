import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_filter/core/setup_dependencies.dart';
import 'package:flutter_image_filter/presentation/controllers/history_controller.dart';
import 'package:flutter_image_filter/presentation/controllers/history_state.dart';

class HistoryPage extends StatelessWidget {
  final String filterName;

  const HistoryPage({required this.filterName, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = locator.get<HistoryController>();
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de $filterName')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocConsumer<HistoryController, HistoryState>(
          bloc: controller,
          listener: (BuildContext context, HistoryState state) {},
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HistoryLoaded) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: state.list.length,
                itemBuilder: (_, i) {
                  final e = state.list[i];
                  return Card(
                    child: ListTile(
                      title: Text('${e.processingTimeMs} ms'),
                      subtitle: Text('${e.timestamp}'),
                    ),
                  );
                },
              );
            } else if (state is HistoryError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Nada aqui'));
          },
        ),
      ),
    );
  }
}
