import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_filter/presentation/pages/filters/rust_filter_page.dart';
import 'package:flutter_image_filter/presentation/widgets/leaderboard_widget.dart';

import 'filters/c_filter_page.dart';
import 'filters/dart_filter_page.dart';
import 'filters/kotlin_filter_page.dart';
import 'filters/swift_filter_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtro de imagem'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selecione por onde quer testar o filtro:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CFilterPage()),
                    );
                  },
                  child: Text("Em C/C++"),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RustFilterPage()),
                    );
                  },
                  child: Text("Em Rust"),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DartFilterPage()),
                    );
                  },
                  child: Text("Em Dart"),
                ),
              ),
              if (Platform.isAndroid)
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => KotlinFilterPage(),
                        ),
                      );
                    },
                    child: Text("Em Koltin"),
                  ),
                ),
              if (Platform.isIOS)
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SwiftFilterPage(),
                        ),
                      );
                    },
                    child: Text("Em Swift"),
                  ),
                ),
              ResultWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
