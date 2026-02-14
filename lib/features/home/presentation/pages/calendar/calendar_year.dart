import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/widgets/app_page_template.dart';

/// =======================
/// YEAR CALENDAR PAGE
/// - 12 months grid (4 rows x 3 cols)
/// - select a day from any month
/// - bottom: table of events for selected day
/// =======================

enum CalendarEventType { event, task, holiday }

class CalendarEventModel {
  final String id;
  final DateTime date; // date-only
  final String title;
  final String? note;
  final CalendarEventType type;

  const CalendarEventModel({
    required this.id,
    required this.date,
    required this.title,
    this.note,
    this.type = CalendarEventType.event,
  });
}

class YearCalendarPage extends StatefulWidget {
  final String backgroundAsset;

  const YearCalendarPage({
    super.key,
    this.backgroundAsset = 'assets/images/homepagewall/mainbg.jpeg',
  });

  @override
  State<YearCalendarPage> createState() => _YearCalendarPageState();
}

class _YearCalendarPageState extends State<YearCalendarPage> {
  late final DateTime _yearStart;
  late DateTime _selectedDate; // date-only
  late final List<CalendarEventModel> _all;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _yearStart = DateTime(now.year, 1, 1);
    _selectedDate = _onlyDate(now);
    _all = _demoEventsForYear(now.year);
  }

  // ---- Computed ----

  Set<DateTime> get _markedDays {
    final s = <DateTime>{};
    for (final e in _all) {
      s.add(_onlyDate(e.date));
    }
    return s;
  }

  List<CalendarEventModel> get _eventsForSelectedDay {
    final d = _selectedDate;
    final items = _all.where((e) => _sameDay(e.date, d)).toList()
      ..sort((a, b) => a.title.compareTo(b.title));
    return items;
  }

  int _eventCountForDay(DateTime d) {
    final dd = _onlyDate(d);
    return _all.where((e) => _sameDay(e.date, dd)).length;
  }

  // ---- UI ----

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    return AppPageTemplate(
      title: 'Year Calendar',
      backgroundAsset: widget.backgroundAsset,
      animate: true,
      premiumDark: true,
      showBack: true,
      scrollable: true,
      contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _YearHeader(
                year: _yearStart.year,
                selectedDate: _selectedDate,
                totalEventsToday: _eventsForSelectedDay.length,
              )
              .animate()
              .fadeIn(duration: 220.ms)
              .slideY(
                begin: .05,
                end: 0,
                duration: 420.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 12),
          _MonthGrid(
                year: _yearStart.year,
                selectedDate: _selectedDate,
                markedDays: _markedDays,
                onPickDate: (d) => setState(() => _selectedDate = _onlyDate(d)),
              )
              .animate()
              .fadeIn(delay: 60.ms, duration: 220.ms)
              .slideY(
                begin: .05,
                end: 0,
                duration: 420.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 14),
          _SectionTitle(
                title: 'Events on ${_formatDateLong(_selectedDate)}',
                subtitle: _eventsForSelectedDay.isEmpty
                    ? 'No events'
                    : '${_eventsForSelectedDay.length} event${_eventsForSelectedDay.length == 1 ? '' : 's'}',
              )
              .animate()
              .fadeIn(delay: 120.ms, duration: 220.ms)
              .slideY(
                begin: .05,
                end: 0,
                duration: 420.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 10),
          if (_eventsForSelectedDay.isEmpty)
            _EmptyEventsCard(
                  isDark: isDark,
                  hint:
                      'Tap any day in the month grid above.\nRed dot means there are events.',
                )
                .animate()
                .fadeIn(delay: 160.ms, duration: 240.ms)
                .slideY(
                  begin: .06,
                  end: 0,
                  duration: 420.ms,
                  curve: Curves.easeOutCubic,
                )
          else
            _EventsTable(
                  isDark: isDark,
                  rows: _eventsForSelectedDay,
                  countForDay: _eventCountForDay,
                )
                .animate()
                .fadeIn(delay: 160.ms, duration: 240.ms)
                .slideY(
                  begin: .06,
                  end: 0,
                  duration: 420.ms,
                  curve: Curves.easeOutCubic,
                ),
        ],
      ),
    );
  }

  // ===== Helpers =====

  static DateTime _onlyDate(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String _formatDateShort(DateTime d) =>
      '${_two(d.day)}/${_two(d.month)}/${d.year}';

  static String _formatDateLong(DateTime d) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  static List<CalendarEventModel> _demoEventsForYear(int year) {
    DateTime d(int m, int day) => DateTime(year, m, day);

    return [
      CalendarEventModel(
        id: 'e1',
        date: d(1, 12),
        title: 'Parent Meeting',
        note: 'Room 2A • 09:00',
        type: CalendarEventType.event,
      ),
      CalendarEventModel(
        id: 'e2',
        date: d(2, 2),
        title: 'Design Review',
        note: 'Banner drafts',
        type: CalendarEventType.task,
      ),
      CalendarEventModel(
        id: 'e3',
        date: d(3, 8),
        title: 'Sports Day',
        note: 'Bring sports uniform',
        type: CalendarEventType.event,
      ),
      CalendarEventModel(
        id: 'e4',
        date: d(4, 13),
        title: 'Holiday',
        note: 'School closed',
        type: CalendarEventType.holiday,
      ),
      CalendarEventModel(
        id: 'e5',
        date: d(6, 5),
        title: 'Vaccination Check',
        note: 'Bring health book',
        type: CalendarEventType.event,
      ),
      CalendarEventModel(
        id: 'e6',
        date: d(8, 18),
        title: 'System Maintenance',
        note: 'Firebase deploy',
        type: CalendarEventType.task,
      ),
      CalendarEventModel(
        id: 'e7',
        date: d(10, 1),
        title: 'New Term Begins',
        note: 'Welcome back!',
        type: CalendarEventType.event,
      ),
      CalendarEventModel(
        id: 'e8',
        date: d(12, 24),
        title: 'Year-End Celebration',
        note: 'Auditorium • 15:00',
        type: CalendarEventType.event,
      ),
      // multiple events same day
      CalendarEventModel(
        id: 'e9',
        date: d(12, 24),
        title: 'Decoration Setup',
        note: 'Front Office',
        type: CalendarEventType.task,
      ),
    ];
  }
}

/// =======================
/// HEADER
/// =======================

class _YearHeader extends StatelessWidget {
  final int year;
  final DateTime selectedDate;
  final int totalEventsToday;

  const _YearHeader({
    required this.year,
    required this.selectedDate,
    required this.totalEventsToday,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    final cardBg = isDark ? Colors.white.withOpacity(.06) : Colors.white;
    final border = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.black.withOpacity(.06);
    final shadow = Colors.black.withOpacity(isDark ? .40 : .10);

    final titleColor = isDark ? Colors.white : Colors.black.withOpacity(.90);
    final muted = isDark ? Colors.white.withOpacity(.70) : Colors.black54;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(blurRadius: 18, offset: const Offset(0, 10), color: shadow),
        ],
      ),
      child: Row(
        children: [
          _IconBubble(icon: Icons.calendar_month_rounded, isDark: isDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$year (Year View)',
                  style: t.textTheme.titleMedium?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Selected: ${_YearCalendarPageState._formatDateShort(selectedDate)} • $totalEventsToday event(s)',
                  style: t.textTheme.bodySmall?.copyWith(
                    color: muted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _HintPill(isDark: isDark),
        ],
      ),
    );
  }
}

class _HintPill extends StatelessWidget {
  final bool isDark;
  const _HintPill({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(.10) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(.12)
              : Colors.black.withOpacity(.06),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.info_outline_rounded,
        size: 18,
        color: isDark ? Colors.white.withOpacity(.92) : Colors.black54,
      ),
    );
  }
}

/// =======================
/// MONTH GRID (4 x 3)
/// (Fix number cut-off by giving more height)
/// =======================

class _MonthGrid extends StatelessWidget {
  final int year;
  final DateTime selectedDate;
  final Set<DateTime> markedDays;
  final ValueChanged<DateTime> onPickDate;

  const _MonthGrid({
    required this.year,
    required this.selectedDate,
    required this.markedDays,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,

        // ✅ was 1.10 (short). Make cards taller so day numbers never clip.
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, i) {
        final month = i + 1;
        return _MiniMonthCard(
          year: year,
          month: month,
          selectedDate: selectedDate,
          markedDays: markedDays,
          onPickDate: onPickDate,
        );
      },
    );
  }
}

class _MiniMonthCard extends StatelessWidget {
  final int year;
  final int month;
  final DateTime selectedDate;
  final Set<DateTime> markedDays;
  final ValueChanged<DateTime> onPickDate;

  const _MiniMonthCard({
    required this.year,
    required this.month,
    required this.selectedDate,
    required this.markedDays,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    final cardBg = isDark ? Colors.white.withOpacity(.06) : Colors.white;
    final border = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.black.withOpacity(.06);
    final shadow = Colors.black.withOpacity(isDark ? .40 : .10);

    final headerColor = isDark ? Colors.white : Colors.black.withOpacity(.88);
    final muted = isDark ? Colors.white.withOpacity(.70) : Colors.black54;

    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // Mon=1..Sun=7
    final offset = (firstWeekday + 6) % 7; // Mon-first => 0..6

    const weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    const markRed = Color(0xFFEF4444);
    const selectedBlue = Color(0xFF3B82F6);

    final title = _monthName(month);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(blurRadius: 16, offset: const Offset(0, 10), color: shadow),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          // month header
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: t.textTheme.labelLarge?.copyWith(
                    color: headerColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.1,
                  ),
                ),
              ),
              Container(
                height: 22,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(.10)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(.12)
                        : Colors.black.withOpacity(.06),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: markRed,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                            color: markRed.withOpacity(.25),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'event',
                      style: TextStyle(
                        color: muted,
                        fontWeight: FontWeight.w900,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // weekday row
          Row(
            children: [
              for (final w in weekdayLabels)
                Expanded(
                  child: Center(
                    child: Text(
                      w,
                      style: t.textTheme.bodySmall?.copyWith(
                        color: muted,
                        fontWeight: FontWeight.w900,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),

          // ✅ days grid (Fix: give more vertical room + move number to top)
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 42,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 3.5,
                crossAxisSpacing: 3.5,

                // ✅ was 1.18 (too short). Make cells taller.
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, i) {
                final day = i - offset + 1;
                if (day < 1 || day > daysInMonth) return const SizedBox();

                final d = DateTime(year, month, day);
                final isSelected = _YearCalendarPageState._sameDay(
                  d,
                  selectedDate,
                );

                final hasEvent = markedDays.contains(
                  DateTime(d.year, d.month, d.day),
                );

                final bg = isSelected
                    ? selectedBlue.withOpacity(isDark ? .24 : .16)
                    : Colors.transparent;

                final borderColor = isSelected
                    ? selectedBlue.withOpacity(isDark ? .70 : .55)
                    : Colors.transparent;

                final textColor = isDark
                    ? Colors.white.withOpacity(.92)
                    : Colors.black.withOpacity(.82);

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onPickDate(d),
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor, width: 1.2),
                      ),
                      child: Stack(
                        children: [
                          // ✅ number at top (prevents being "cut" by bottom dot)
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11.2,
                                  height: 1.0, // ✅ avoid vertical clipping
                                ),
                              ),
                            ),
                          ),

                          // dot at bottom
                          if (hasEvent)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Container(
                                  width: 6.5,
                                  height: 6.5,
                                  decoration: const BoxDecoration(
                                    color: markRed,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static String _monthName(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[m - 1];
  }
}

/// =======================
/// SECTION TITLE
/// =======================

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: t.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: t.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? Colors.white.withOpacity(.72)
                      : t.colorScheme.onSurface.withOpacity(.70),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(.10)),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.list_alt_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ],
    );
  }
}

/// =======================
/// EMPTY CARD
/// =======================

class _EmptyEventsCard extends StatelessWidget {
  final bool isDark;
  final String hint;

  const _EmptyEventsCard({required this.isDark, required this.hint});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    final cardBg = isDark ? Colors.white.withOpacity(.06) : Colors.white;
    final border = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.black.withOpacity(.06);
    final shadow = Colors.black.withOpacity(isDark ? .40 : .10);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(blurRadius: 18, offset: const Offset(0, 10), color: shadow),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 44,
            color: isDark ? Colors.white.withOpacity(.86) : Colors.black54,
          ),
          const SizedBox(height: 10),
          Text(
            'No events on this day',
            style: t.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: t.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: t.colorScheme.onSurface.withOpacity(.70),
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// EVENTS TABLE (BOTTOM)
/// =======================

class _EventsTable extends StatelessWidget {
  final bool isDark;
  final List<CalendarEventModel> rows;

  final int Function(DateTime d) countForDay;

  const _EventsTable({
    required this.isDark,
    required this.rows,
    required this.countForDay,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? Colors.white.withOpacity(.06) : Colors.white;
    final border = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.black.withOpacity(.06);
    final shadow = Colors.black.withOpacity(isDark ? .40 : .10);

    final headBg = isDark
        ? Colors.white.withOpacity(.08)
        : const Color(0xFFF3F4F6);

    final textColor = isDark
        ? Colors.white.withOpacity(.92)
        : Colors.black.withOpacity(.86);
    final muted = isDark ? Colors.white.withOpacity(.68) : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(blurRadius: 18, offset: const Offset(0, 10), color: shadow),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            color: headBg,
            child: Row(
              children: [
                _Th(text: 'Type', flex: 2, color: muted),
                const SizedBox(width: 10),
                _Th(text: 'Title', flex: 5, color: muted),
                const SizedBox(width: 10),
                _Th(text: 'Note', flex: 6, color: muted),
              ],
            ),
          ),
          for (int i = 0; i < rows.length; i++)
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? Colors.white.withOpacity(.08)
                        : Colors.black.withOpacity(.06),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _TypePill(type: rows[i].type, isDark: isDark),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: Text(
                      rows[i].title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: Text(
                      (rows[i].note ?? '-'),
                      style: TextStyle(
                        color: muted,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.6,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Th extends StatelessWidget {
  final String text;
  final int flex;
  final Color color;

  const _Th({required this.text, required this.flex, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12.2,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  final CalendarEventType type;
  final bool isDark;

  const _TypePill({required this.type, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final c = _typeColor(type);
    final label = _typeText(type);
    final icon = _typeIcon(type);

    final bg = isDark ? Colors.white.withOpacity(.10) : c.withOpacity(.10);
    final border = isDark ? Colors.white.withOpacity(.12) : c.withOpacity(.22);
    final fg = isDark ? Colors.white.withOpacity(.92) : c;

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: .15,
            ),
          ),
        ],
      ),
    );
  }

  static Color _typeColor(CalendarEventType t) {
    switch (t) {
      case CalendarEventType.event:
        return const Color(0xFF3B82F6);
      case CalendarEventType.task:
        return const Color(0xFFF59E0B);
      case CalendarEventType.holiday:
        return const Color(0xFF22C55E);
    }
  }

  static String _typeText(CalendarEventType t) {
    switch (t) {
      case CalendarEventType.event:
        return 'Event';
      case CalendarEventType.task:
        return 'Task';
      case CalendarEventType.holiday:
        return 'Holiday';
    }
  }

  static IconData _typeIcon(CalendarEventType t) {
    switch (t) {
      case CalendarEventType.event:
        return Icons.event_rounded;
      case CalendarEventType.task:
        return Icons.task_alt_rounded;
      case CalendarEventType.holiday:
        return Icons.celebration_rounded;
    }
  }
}

/// =======================
/// Small Bubble
/// =======================

class _IconBubble extends StatelessWidget {
  final IconData icon;
  final bool isDark;

  const _IconBubble({required this.icon, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? Colors.white.withOpacity(.10) : const Color(0xFFF3F4F6),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(.12)
              : Colors.black.withOpacity(.06),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 20,
          color: isDark ? Colors.white.withOpacity(.92) : Colors.black54,
        ),
      ),
    );
  }
}
