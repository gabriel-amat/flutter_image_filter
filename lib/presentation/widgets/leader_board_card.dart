import 'package:flutter/material.dart';
import 'package:flutter_image_filter/core/utils/enum/language_enum.dart';
import 'package:flutter_image_filter/domain/entities/filter_result_entity.dart';
import 'package:flutter_image_filter/presentation/pages/history_page.dart';
import 'package:flutter_image_filter/presentation/widgets/logo_widget.dart';

class LeaderBoardCard extends StatelessWidget {
  final FilterResultEntity filter;

  const LeaderBoardCard({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: LogoWidget(imagePath: filter.language.getLogoPath()),
        title: Text('${filter.processingTimeMs} ms'),
        subtitle: Text(filter.language),
        trailing: TextButton(
          child: const Text('ver mais'),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryPage(language: filter.language),
                ),
              ),
        ),
      ),
    );
  }
}
