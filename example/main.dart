import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chemical_structural_formula_viewer/chemical_structural_formula_viewer.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  StructurePage? page;
  List<String> files = [];
  void addData() async {
    final result = await FilePicker.platform.pickFiles(
        allowedExtensions: ["cdxml", "cml"],
        type: FileType.custom,
        allowMultiple: true);
    if (result == null) return;
    final pathes = result.files.map((e) => e.path).nonNulls;
    print(pathes.first);
    files.addAll(pathes);
    load(pathes.first);
    print("done");
    setState(() {});
  }

  void load(String path) {
    var xml = File(path).readAsStringSync();
    switch (path.split(".").last) {
      case "cdxml":
        page = parseCdxml(xml);
        break;
      case "cml":
        page = parseCml(xml);
        break;
    }
  }

  // var benzene = parseCml(benzeneCml);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              return TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    load(files[index]);
                    setState(() {});
                  },
                  child: Text(files[index]));
            }),
      ),
      appBar: AppBar(
        title: const Text('Chemical Structural Formula Viewer'),
      ),
      body: InteractiveViewer(
        maxScale: 100,
        minScale: 0.1,
        child: StructureViewer(
          page: page,
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: addData),
    );
  }
}
