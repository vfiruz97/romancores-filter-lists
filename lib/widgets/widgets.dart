import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/data/job.dart';
import 'package:test/data/job_filter.dart';

import '../style.dart';

/// [JobTextWidget] some info about for other devs
class JobTextWidget extends StatelessWidget {
  const JobTextWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$title: ", style: Style.w600()),
        Text(subtitle),
      ],
    );
  }
}

/// [JobListTileWidget] some info about for other devs
class JobListTileWidget extends StatelessWidget {
  JobListTileWidget({
    Key? key,
    required this.job,
  }) : super(key: key);

  final Job job;
  final DateFormat formatter = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.code),
          title: Text(
            job.title,
            style: Style.w600(),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobTextWidget(
                  title: "Тип занятости",
                  subtitle: job.availability.name,
                ),
                JobTextWidget(
                  title: "Зарплата",
                  subtitle: "${job.salary} ₽",
                ),
                JobTextWidget(
                  title: "Опубликовано в: ",
                  subtitle: formatter.format(job.publishedAt),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

/// [CheckBoxWidget] some info about for other devs
class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({
    Key? key,
    required this.label,
    this.checked = true,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final bool checked;
  final ValueChanged<bool>? onChanged;

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool checked = false;

  @override
  void initState() {
    checked = widget.checked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          checked = !checked;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(checked);
        }
      },
      child: Row(
        children: [
          if (checked)
            const Icon(
              Icons.check_box,
              size: 20,
              color: Colors.blueAccent,
            )
          else
            const Icon(
              Icons.check_box_outline_blank,
              size: 20,
              color: Colors.blueAccent,
            ),
          Text(widget.label),
        ],
      ),
    );
  }
}

/// The method [dateRangePicker] is for the [DateRangePickerWidget] custom
/// widget.
///
/// Shows a full screen modal dialog containing a Material Design date range
/// picker.
Future<DateTimeRange?> dateRangePicker(
  BuildContext context,
  DateTimeRange? dateRange,
) async {
  final _dateRange = DateTimeRange(
    start: dateRange != null ? dateRange.start : DateTime.now(),
    end: dateRange != null ? dateRange.end : DateTime.now(),
  );
  final pickedDateRange = await showDateRangePicker(
    context: context,
    initialDateRange: _dateRange,
    firstDate: DateTime(DateTime.now().year - 5),
    lastDate: DateTime(DateTime.now().year + 5),
    initialEntryMode: DatePickerEntryMode.input,
  );
  return pickedDateRange;
}

/// [DateRangePickerWidget] some info about for other devs
class DateRangePickerWidget extends StatefulWidget {
  const DateRangePickerWidget({
    Key? key,
    this.onPickedDateRange,
  }) : super(key: key);

  final ValueChanged<DateTimeRange?>? onPickedDateRange;

  @override
  State<DateRangePickerWidget> createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  final DateFormat formatter = DateFormat('dd.MM.yyyy');

  DateTimeRange? _pickedDateRange;

  set pickedDateRange(DateTimeRange? dateRange) {
    _pickedDateRange = dateRange;
    if (widget.onPickedDateRange != null) {
      widget.onPickedDateRange!(_pickedDateRange);
    }
  }

  String get pickedDateRangeText {
    final _text = _pickedDateRange == null
        ? 'Выберите диапазон дат'
        : "${formatter.format(_pickedDateRange!.start)} - ${formatter.format(_pickedDateRange!.end)}";
    return _text;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final newDateRange = await dateRangePicker(context, _pickedDateRange);
        setState(() => pickedDateRange = newDateRange);
      },
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 20,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(pickedDateRangeText),
          ),
        ],
      ),
    );
  }
}

/// [SalaryRangerWidget] some info about for other devs
class SalaryRangerWidget extends StatefulWidget {
  const SalaryRangerWidget({
    Key? key,
    required this.min,
    required this.max,
    this.divisions,
    this.onChanged,
    this.values = const RangeValues(0, 0),
  }) : super(key: key);

  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<RangeValues>? onChanged;
  final RangeValues values;

  @override
  State<SalaryRangerWidget> createState() => _SalaryRangerWidgetState();
}

class _SalaryRangerWidgetState extends State<SalaryRangerWidget> {
  RangeValues values = const RangeValues(0, 0);

  RangeLabels get labels =>
      RangeLabels("${values.start.toInt()} ₽", "${values.end.toInt()} ₽");
  String get title =>
      "Зарплата: (${values.start.toInt()} - ${values.end.toInt()}) ₽.";

  @override
  void initState() {
    values = widget.values;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Style.w500()),
        SizedBox(
          height: 26,
          child: RangeSlider(
            values: values,
            onChanged: (RangeValues newValues) {
              setState(() {
                values = newValues;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(values);
              }
            },
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            labels: labels,
            activeColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}

/// [TitleWidget] some info about for other devs
class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$title:',
      style: Style.w500(),
    );
  }
}

/// [FilterFormWidget] some info about for other devs
///
/// Job filter form which ...
class FilterFormWidget extends StatefulWidget {
  const FilterFormWidget({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  final ValueChanged<JobFilter>? onChanged;

  @override
  State<FilterFormWidget> createState() => _FilterFormWidgetState();
}

class _FilterFormWidgetState extends State<FilterFormWidget> {
  JobFilter filter = JobFilter();

  void _onChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(filter);
    }
  }

  void _changeTitleFilter(String _title) {
    setState(() => filter.title = _title);
    _onChanged();
  }

  void _changeShowFullTimeFilter(bool enabled) {
    setState(() => filter.showFullTime = enabled);
    _onChanged();
  }

  void _changeShowPartTimeFilter(bool enabled) {
    setState(() => filter.showPartTime = enabled);
    _onChanged();
  }

  void _changeSalaryFilter(RangeValues _salary) {
    setState(() => filter.salary = _salary);
    _onChanged();
  }

  void _changeDateFilter(DateTimeRange? _date) {
    setState(() => filter.date = _date);
    _onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade300,
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              style: const TextStyle(fontSize: 12),
              decoration: Style.searchInputDecoration(),
              onChanged: _changeTitleFilter,
            ),
            const SizedBox(height: 8),
            const TitleWidget(title: 'Тип занятности'),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Row(
                children: [
                  CheckBoxWidget(
                    label: Availability.fullTime.name,
                    onChanged: _changeShowFullTimeFilter,
                  ),
                  CheckBoxWidget(
                    label: Availability.partTime.name,
                    onChanged: _changeShowPartTimeFilter,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SalaryRangerWidget(
              min: 0,
              max: 20000,
              values: const RangeValues(0, 20000),
              divisions: 1000,
              onChanged: _changeSalaryFilter,
            ),
            const SizedBox(height: 8),
            DateRangePickerWidget(onPickedDateRange: _changeDateFilter),
          ],
        ),
      ),
    );
  }
}
