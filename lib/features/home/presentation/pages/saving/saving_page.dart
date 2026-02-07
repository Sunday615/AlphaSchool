import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';

class SavingPage extends StatefulWidget {
  const SavingPage({super.key});

  @override
  State<SavingPage> createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> with TickerProviderStateMixin {
  late final TabController _tab;

  DateTime? _fromDate;
  DateTime? _toDate;

  late final List<_SavingTxn> _personalData;
  late final List<_SavingTxn> _classData;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);

    final now = DateTime.now();
    _toDate = DateTime(now.year, now.month, now.day);
    _fromDate = _toDate!.subtract(const Duration(days: 30));

    _personalData = _demoData(seed: 1, days: 220);
    _classData = _demoData(seed: 9, days: 260);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // =========================
  // Styles
  // =========================
  LinearGradient _premiumGradient(bool isDark) => isDark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF071A3A), Color(0xFF0B2A6F), Color(0xFF1246A8)],
        )
      : LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blue500.withOpacity(.10),
            Colors.white,
            AppColors.blue400.withOpacity(.10),
          ],
        );

  // =========================
  // Date picker
  // =========================
  Future<void> _pickRange() async {
    final now = DateTime.now();
    final initStart = _fromDate ?? DateTime(now.year, now.month, now.day - 30);
    final initEnd = _toDate ?? DateTime(now.year, now.month, now.day);

    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5, 1, 1),
      lastDate: DateTime(now.year + 5, 12, 31),
      initialDateRange: DateTimeRange(start: initStart, end: initEnd),
      builder: (context, child) {
        final t = Theme.of(context);
        final isDark = t.brightness == Brightness.dark;

        return Theme(
          data: t.copyWith(
            colorScheme: t.colorScheme.copyWith(
              primary: AppColors.blue500,
              surface: isDark ? const Color(0xFF071A3A) : Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (range == null) return;
    setState(() {
      _fromDate = DateTime(
        range.start.year,
        range.start.month,
        range.start.day,
      );
      _toDate = DateTime(range.end.year, range.end.month, range.end.day);
    });
  }

  void _resetRange() {
    final now = DateTime.now();
    setState(() {
      _toDate = DateTime(now.year, now.month, now.day);
      _fromDate = _toDate!.subtract(const Duration(days: 30));
    });
  }

  // =========================
  // Data selection + compute
  // =========================
  List<_SavingTxn> _dataForTab(int index) =>
      index == 0 ? _personalData : _classData;

  _SavingView _buildView(List<_SavingTxn> raw) {
    final from = _fromDate;
    final to = _toDate;

    final filtered = raw.where((e) {
      final d = DateTime(e.date.year, e.date.month, e.date.day);
      final okFrom = from == null
          ? true
          : !d.isBefore(DateTime(from.year, from.month, from.day));
      final okTo = to == null
          ? true
          : !d.isAfter(DateTime(to.year, to.month, to.day));
      return okFrom && okTo;
    }).toList()..sort((a, b) => a.date.compareTo(b.date));

    double balance = 0;
    final rows = <_SavingRow>[];
    for (final e in filtered) {
      balance += (e.inAmount - e.outAmount);
      rows.add(_SavingRow(txn: e, balance: balance));
    }

    final totalIn = filtered.fold<double>(0, (s, e) => s + e.inAmount);
    final totalOut = filtered.fold<double>(0, (s, e) => s + e.outAmount);
    final totalBalance = totalIn - totalOut;

    final latestIn = filtered
        .where((e) => e.inAmount > 0)
        .fold<_SavingTxn?>(
          null,
          (best, e) => (best == null || e.date.isAfter(best.date)) ? e : best,
        );

    return _SavingView(
      rows: rows,
      totalIn: totalIn,
      totalOut: totalOut,
      totalBalance: totalBalance,
      latestIn: latestIn,
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : AppColors.blue500;

    return Scaffold(
      backgroundColor: t.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: _premiumGradient(isDark)),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                      child: Row(
                        children: [
                          _GlassIconButton(
                            isDark: isDark,
                            icon: FontAwesomeIcons.arrowLeft,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Saving",
                              style: t.textTheme.titleLarge?.copyWith(
                                color: titleColor,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .2,
                              ),
                            ),
                          ),
                          _GlassIconButton(
                            isDark: isDark,
                            icon: FontAwesomeIcons.arrowsRotate,
                            onTap: _resetRange,
                          ),
                          const SizedBox(width: 10),
                          _GlassIconButton(
                            isDark: isDark,
                            icon: FontAwesomeIcons.calendarDays,
                            onTap: _pickRange,
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 220.ms)
                    .slideY(begin: .08, end: 0, duration: 220.ms),

                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                  child: Column(
                    children: [
                      _RangeBar(
                            isDark: isDark,
                            from: _fromDate,
                            to: _toDate,
                            onTap: _pickRange,
                          )
                          .animate()
                          .fadeIn(duration: 220.ms, delay: 40.ms)
                          .slideY(begin: .08, end: 0),
                      const SizedBox(height: 10),
                      _GlassTabBar(isDark: isDark, controller: _tab)
                          .animate()
                          .fadeIn(duration: 220.ms, delay: 80.ms)
                          .slideY(begin: .08, end: 0),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tab,
                    children: [
                      _SavingTabBody(
                        kind: "Personal",
                        isDark: isDark,
                        dataBuilder: () => _buildView(_dataForTab(0)),
                      ),
                      _SavingTabBody(
                        kind: "Class",
                        isDark: isDark,
                        dataBuilder: () => _buildView(_dataForTab(1)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Demo generator
  // =========================
  List<_SavingTxn> _demoData({required int seed, required int days}) {
    final now = DateTime.now();
    final out = <_SavingTxn>[];

    int x = seed * 9973;
    int nextInt(int max) {
      x = (x * 1103515245 + 12345) & 0x7fffffff;
      return x % max;
    }

    for (int i = days; i >= 0; i--) {
      final d = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));

      final r = nextInt(100);
      double inAmt = 0;
      double outAmt = 0;

      if (r < 55) {
        inAmt = (nextInt(10) + 1) * 10000;
      } else if (r < 80) {
        outAmt = (nextInt(10) + 1) * 5000;
      } else {
        if (nextInt(2) == 0) {
          inAmt = (nextInt(5) + 1) * 5000;
        } else {
          outAmt = (nextInt(5) + 1) * 5000;
        }
      }

      out.add(_SavingTxn(date: d, inAmount: inAmt, outAmount: outAmt));
    }

    out.sort((a, b) => a.date.compareTo(b.date));
    return out;
  }
}

// ======================================================
// TAB BODY (Table + Footer Summary)
// ======================================================
class _SavingTabBody extends StatelessWidget {
  final String kind;
  final bool isDark;
  final _SavingView Function() dataBuilder;

  const _SavingTabBody({
    required this.kind,
    required this.isDark,
    required this.dataBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final view = dataBuilder();
    final rows = view.rows;

    final title = isDark ? Colors.white : AppColors.blue500;
    final muted = isDark
        ? Colors.white.withOpacity(.70)
        : AppColors.blue500.withOpacity(.62);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(.10)
                      : AppColors.blue500.withOpacity(.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(.14)
                        : AppColors.blue500.withOpacity(.18),
                  ),
                ),
                child: Text(
                  "$kind saving",
                  style: TextStyle(
                    color: title,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .2,
                    fontSize: 12.5,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "Rows: ${rows.length}",
                style: TextStyle(
                  color: muted,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 200.ms).slideY(begin: .06, end: 0),

          const SizedBox(height: 12),

          Expanded(
            child: _GlassPanel(
              isDark: isDark,
              child: Column(
                children: [
                  _TableHeader(
                    isDark: isDark,
                  ).animate().fadeIn(duration: 180.ms),

                  Expanded(
                    child: rows.isEmpty
                        ? Center(
                            child: Text(
                              "No data in selected range",
                              style: TextStyle(
                                color: muted,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 10),
                            itemCount: rows.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              thickness: 1,
                              color: isDark
                                  ? Colors.white.withOpacity(.08)
                                  : AppColors.slate.withOpacity(.10),
                            ),
                            itemBuilder: (context, i) {
                              return _TableRowItem(isDark: isDark, row: rows[i])
                                  .animate()
                                  .fadeIn(duration: 140.ms, delay: (14 * i).ms)
                                  .slideY(begin: .05, end: 0, duration: 140.ms);
                            },
                          ),
                  ),

                  _FooterSummary(isDark: isDark, typeText: kind, view: view)
                      .animate()
                      .fadeIn(duration: 220.ms, delay: 60.ms)
                      .slideY(begin: .06, end: 0, duration: 220.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// TABLE WIDGETS
// ======================================================
class _TableHeader extends StatelessWidget {
  final bool isDark;
  const _TableHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final c = isDark
        ? Colors.white.withOpacity(.75)
        : AppColors.blue500.withOpacity(.70);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(.05)
            : AppColors.blue500.withOpacity(.05),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(.10)
                : AppColors.slate.withOpacity(.14),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 12,
            child: Text(
              "Date",
              style: TextStyle(
                color: c,
                fontWeight: FontWeight.w900,
                letterSpacing: .2,
                fontSize: 12.5,
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "In / Out",
                style: TextStyle(
                  color: c,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .2,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Balance",
                style: TextStyle(
                  color: c,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .2,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRowItem extends StatelessWidget {
  final bool isDark;
  final _SavingRow row;

  const _TableRowItem({required this.isDark, required this.row});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final df = _safeDateFmt('yyyy/MM/dd', locale);
    final nf = _safeNumFmt(locale);

    final dateText = df.format(row.txn.date);

    final net = row.txn.inAmount > 0 ? row.txn.inAmount : -row.txn.outAmount;
    final netText = net == 0
        ? ""
        : (net > 0 ? "+${nf.format(net)}" : "−${nf.format(net.abs())}");

    final netColor = net > 0
        ? const Color(0xFF22C55E)
        : (net < 0 ? const Color(0xFFEF4444) : Colors.white.withOpacity(.25));

    final balText = nf.format(row.balance.abs());
    final balPrefix = row.balance >= 0 ? "" : "−";
    final balColor = isDark
        ? (row.balance >= 0 ? Colors.white : Colors.white.withOpacity(.85))
        : (row.balance >= 0
              ? AppColors.blue500
              : AppColors.blue500.withOpacity(.85));

    final dateColor = isDark ? Colors.white : AppColors.blue500;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 12,
            child: Text(
              dateText,
              style: TextStyle(
                color: dateColor,
                fontWeight: FontWeight.w900,
                fontSize: 13.2,
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                netText,
                style: TextStyle(
                  color: netColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 15.5,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "$balPrefix$balText",
                style: TextStyle(
                  color: balColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 13.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// FOOTER SUMMARY
// ======================================================
class _FooterSummary extends StatelessWidget {
  final bool isDark;
  final String typeText;
  final _SavingView view;

  const _FooterSummary({
    required this.isDark,
    required this.typeText,
    required this.view,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final nf = _safeNumFmt(locale);

    final latest = view.latestIn;
    final latestText = latest == null ? "-" : "+${nf.format(latest.inAmount)}";
    final latestDate = latest == null
        ? ""
        : _safeDateFmt('yyyy/MM/dd', locale).format(latest.date);

    final totalIn = "+${nf.format(view.totalIn)}";
    final totalOut = "−${nf.format(view.totalOut)}";

    final bal = view.totalBalance;
    final balText = bal >= 0 ? nf.format(bal) : "−${nf.format(bal.abs())}";

    final border = isDark
        ? Colors.white.withOpacity(.12)
        : AppColors.slate.withOpacity(.14);

    final titleColor = isDark ? Colors.white : AppColors.blue500;
    final muted = isDark
        ? Colors.white.withOpacity(.68)
        : AppColors.blue500.withOpacity(.62);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(.05)
            : AppColors.blue500.withOpacity(.035),
        border: Border(top: BorderSide(color: border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Saving details",
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .2,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Text(
                "Summary",
                style: TextStyle(
                  color: muted,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .2,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          _EqualGrid(
            gap: 10,
            children: [
              _MiniMetric(
                isDark: isDark,
                title: "Type",
                value: typeText,
                icon: FontAwesomeIcons.tag,
                valueColor: titleColor,
              ),
              _MiniMetric(
                isDark: isDark,
                title: "Latest In",
                value: latestText,
                subtitle: latestDate.isEmpty ? null : latestDate,
                icon: FontAwesomeIcons.arrowDown,
                valueColor: const Color(0xFF22C55E),
              ),
              _MiniMetric(
                isDark: isDark,
                title: "Total In",
                value: totalIn,
                icon: FontAwesomeIcons.circleArrowUp,
                valueColor: const Color(0xFF22C55E),
              ),
              _MiniMetric(
                isDark: isDark,
                title: "Total Out",
                value: totalOut,
                icon: FontAwesomeIcons.circleArrowDown,
                valueColor: const Color(0xFFEF4444),
              ),
              _MiniMetric(
                isDark: isDark,
                title: "Total Balance (In - Out)",
                value: balText,
                icon: FontAwesomeIcons.wallet,
                valueColor: isDark ? Colors.white : AppColors.blue500,
                span2: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EqualGrid extends StatelessWidget {
  final double gap;
  final List<Widget> children;
  const _EqualGrid({required this.gap, required this.children});

  @override
  Widget build(BuildContext context) {
    final items = children;

    final rows = <Widget>[];
    int i = 0;
    while (i < items.length) {
      final w = items[i];

      if (w is _MiniMetric && w.span2) {
        rows.add(w);
        i += 1;
        if (i < items.length) rows.add(SizedBox(height: gap));
        continue;
      }

      Widget? w2;
      if (i + 1 < items.length) {
        final maybe = items[i + 1];
        if (maybe is _MiniMetric && maybe.span2) {
          w2 = null;
        } else {
          w2 = maybe;
        }
      }

      rows.add(
        Row(
          children: [
            Expanded(child: items[i]),
            SizedBox(width: gap),
            Expanded(child: w2 ?? const SizedBox.shrink()),
          ],
        ),
      );

      i += (w2 == null ? 1 : 2);
      if (i < items.length) rows.add(SizedBox(height: gap));
    }

    return Column(children: rows);
  }
}

class _MiniMetric extends StatelessWidget {
  final bool isDark;
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color valueColor;
  final bool span2;

  const _MiniMetric({
    required this.isDark,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.valueColor,
    this.span2 = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark
        ? Colors.white.withOpacity(.12)
        : AppColors.slate.withOpacity(.14);
    final bg = isDark
        ? Colors.white.withOpacity(.07)
        : Colors.white.withOpacity(.86);

    final titleC = isDark
        ? Colors.white.withOpacity(.70)
        : AppColors.blue500.withOpacity(.68);
    final subC = isDark
        ? Colors.white.withOpacity(.62)
        : AppColors.blue500.withOpacity(.55);

    return SizedBox(
      height: 72,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(isDark ? .18 : .05),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(.10)
                    : AppColors.blue500.withOpacity(.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Center(child: FaIcon(icon, color: valueColor, size: 16)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: titleC,
                      fontWeight: FontWeight.w900,
                      fontSize: 11.2,
                      letterSpacing: .2,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: valueColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.8,
                      height: 1.0,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: subC,
                        fontWeight: FontWeight.w800,
                        fontSize: 10.8,
                        height: 1.0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// HEADER WIDGETS
// ======================================================
class _GlassTabBar extends StatelessWidget {
  final bool isDark;
  final TabController controller;

  const _GlassTabBar({required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    final border = isDark
        ? Colors.white.withOpacity(.14)
        : AppColors.slate.withOpacity(.14);

    return _GlassPanel(
      isDark: isDark,
      padding: const EdgeInsets.all(6),
      child: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        splashBorderRadius: BorderRadius.circular(16),
        indicator: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(.14)
              : AppColors.blue500.withOpacity(.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        labelColor: isDark ? Colors.white : AppColors.blue500,
        unselectedLabelColor: isDark
            ? Colors.white.withOpacity(.70)
            : AppColors.blue500.withOpacity(.55),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          letterSpacing: .2,
        ),
        tabs: const [
          Tab(text: "Personal"),
          Tab(text: "Class"),
        ],
      ),
    );
  }
}

class _RangeBar extends StatelessWidget {
  final bool isDark;
  final DateTime? from;
  final DateTime? to;
  final VoidCallback onTap;

  const _RangeBar({
    required this.isDark,
    required this.from,
    required this.to,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final df = _safeDateFmt('dd MMM yyyy', locale);

    final fromText = from == null ? "Any" : df.format(from!);
    final toText = to == null ? "Any" : df.format(to!);

    final text = isDark ? Colors.white : AppColors.blue500;
    final muted = isDark
        ? Colors.white.withOpacity(.70)
        : AppColors.blue500.withOpacity(.62);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: _GlassPanel(
        isDark: isDark,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            FaIcon(FontAwesomeIcons.sliders, color: text, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "$fromText  →  $toText",
                style: TextStyle(
                  color: text,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .2,
                ),
              ),
            ),
            Text(
              "Filter",
              style: TextStyle(color: muted, fontWeight: FontWeight.w900),
            ),
            const SizedBox(width: 8),
            FaIcon(FontAwesomeIcons.chevronRight, color: muted, size: 14),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// GLASS / ICON BUTTON
// ======================================================
class _GlassPanel extends StatelessWidget {
  final bool isDark;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const _GlassPanel({required this.isDark, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? Colors.white.withOpacity(.08)
        : Colors.white.withOpacity(.82);
    final border = isDark
        ? Colors.white.withOpacity(.14)
        : AppColors.slate.withOpacity(.14);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isDark ? 10 : 6,
          sigmaY: isDark ? 10 : 6,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({
    required this.isDark,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark
        ? Colors.white.withOpacity(.14)
        : AppColors.slate.withOpacity(.14);
    final bg = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.white.withOpacity(.86);
    final iconC = isDark ? Colors.white : AppColors.blue500;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: FaIcon(icon, color: iconC, size: 18),
        ),
      ),
    );
  }
}

// ======================================================
// MODELS
// ======================================================
class _SavingTxn {
  final DateTime date;
  final double inAmount;
  final double outAmount;

  const _SavingTxn({
    required this.date,
    required this.inAmount,
    required this.outAmount,
  });
}

class _SavingRow {
  final _SavingTxn txn;
  final double balance;

  const _SavingRow({required this.txn, required this.balance});
}

class _SavingView {
  final List<_SavingRow> rows;
  final double totalIn;
  final double totalOut;
  final double totalBalance;
  final _SavingTxn? latestIn;

  const _SavingView({
    required this.rows,
    required this.totalIn,
    required this.totalOut,
    required this.totalBalance,
    required this.latestIn,
  });
}

// ======================================================
// FORMAT HELPERS
// ======================================================
DateFormat _safeDateFmt(String pattern, String localeTag) {
  try {
    return DateFormat(pattern, localeTag);
  } catch (_) {
    return DateFormat(pattern, 'en');
  }
}

NumberFormat _safeNumFmt(String localeTag) {
  try {
    return NumberFormat.decimalPattern(localeTag);
  } catch (_) {
    return NumberFormat.decimalPattern('en');
  }
}
