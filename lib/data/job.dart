import 'package:test/data/job_filter.dart';

enum Availability { partTime, fullTime }

extension AvailabilityX on Availability {
  String get name {
    switch (this) {
      case Availability.partTime:
        return 'неполный р/день';
      case Availability.fullTime:
        return 'полный р/день';
      default:
        return 'none';
    }
  }
}

class Job {
  final String title;
  final int salary;
  final DateTime publishedAt;
  final Availability availability;

  const Job({
    required this.title,
    required this.salary,
    required this.publishedAt,
    required this.availability,
  });

  static final List<Job> jobs = [
    Job(
      title: 'PHP Developer in OAO Ltc.',
      salary: 15000,
      publishedAt: DateTime.parse("2021-09-23"),
      availability: Availability.fullTime,
    ),
    Job(
      title: 'Front-end Developer ..',
      salary: 13000,
      publishedAt: DateTime.parse("2021-09-23"),
      availability: Availability.partTime,
    ),
    Job(
      title: 'Java Developer',
      salary: 14500,
      publishedAt: DateTime.parse("2021-09-22"),
      availability: Availability.fullTime,
    ),
    Job(
      title: 'Dart Backend Developer',
      salary: 15500,
      publishedAt: DateTime.parse("2021-09-21"),
      availability: Availability.partTime,
    ),
    Job(
      title: 'Flutter Developer',
      salary: 15000,
      publishedAt: DateTime.parse("2021-09-19"),
      availability: Availability.fullTime,
    ),
    Job(
      title: 'PHP Developer',
      salary: 14000,
      publishedAt: DateTime.parse("2021-09-20"),
      availability: Availability.partTime,
    ),
  ];

  static List<Job> filterJobs(JobFilter filter) {
    final _jobs = Job.jobs;

    final _filtredJobs = _jobs.where((job) {
      bool _isTitleValid = true,
          _isAvailabilityValid = true,
          _isSalaryValid = true,
          _isDateValid = true;

      // Фильтр по названию (string)
      if (filter.title != null && filter.title!.isNotEmpty) {
        _isTitleValid =
            job.title.toLowerCase().startsWith(filter.title!.toLowerCase());
      }

      // Фильтр по типу занятности (enum)
      if (filter.showFullTime && filter.showPartTime) {
        _isAvailabilityValid = job.availability == Availability.fullTime ||
            job.availability == Availability.partTime;
      } else if (filter.showFullTime) {
        _isAvailabilityValid = job.availability == Availability.fullTime;
      } else if (filter.showPartTime) {
        _isAvailabilityValid = job.availability == Availability.partTime;
      } else {
        _isAvailabilityValid = false;
      }

      // Фильтр по зарплате (int)
      if (filter.salary != null) {
        _isSalaryValid = job.salary >= filter.salary!.start.toInt() &&
            job.salary <= filter.salary!.end.toInt();
      }

      // Фильтр по дате публикации (Date)
      if (filter.date != null) {
        _isDateValid = job.publishedAt.compareTo(filter.date!.start) >= 0 &&
            job.publishedAt.compareTo(filter.date!.end) <= 0;
      }

      return _isTitleValid &&
          _isAvailabilityValid &&
          _isSalaryValid &&
          _isDateValid;
    }).toList();
    return _filtredJobs;
  }
}
