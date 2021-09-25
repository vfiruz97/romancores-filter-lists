import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test/data/job.dart';
import 'package:test/data/job_filter.dart';
import 'package:test/widgets/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
      supportedLocales: const [Locale('ru')],
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Job> jobs = Job.jobs;

  void _filterJobs(JobFilter _filter) {
    final newJobs = Job.filterJobs(_filter);
    setState(() => jobs = newJobs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список работ'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            FilterFormWidget(
              onChanged: _filterJobs,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  return JobListTileWidget(job: jobs[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
