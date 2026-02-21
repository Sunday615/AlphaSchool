import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:alpha_school/core/widgets/app_page_template.dart';
import 'package:alpha_school/core/widgets/app_modern_count_tabbar.dart' as tabs;

// ---- Helpers (avoid withOpacity deprecated) ----
int _alpha(double o) => (o * 255).round().clamp(0, 255);
Color _o(Color c, double opacity) => c.withAlpha(_alpha(opacity));

// ✅ Same gradient as global tabbar file (default indicator gradient)
const Gradient _kGlobalTabGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF60A5FA), Color(0xFF3B82F6), Color(0xFF2563EB)],
);

// ---- Status colors (as requested) ----
const Color _kStatusMustPay = Color(0xFF2563EB); // blue
const Color _kStatusPending = Color(0xFFF59E0B); // yellow
const Color _kStatusPaid = Color(0xFF22C55E); // green

class FeePage extends StatefulWidget {
  const FeePage({
    super.key,
    this.backgroundAsset = _kDefaultBg,
    this.showBack = true,
  });

  final String backgroundAsset;
  final bool showBack;

  static const String _kDefaultBg = 'assets/images/homepagewall/mainbg.jpeg';

  @override
  State<FeePage> createState() => _FeePageState();
}

class _FeePageState extends State<FeePage> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  late final List<FeeItem> _fees;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _fees = FeeDemoFactory.buildSample();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabGrad = _kGlobalTabGradient;

    // ✅ unselected label for tabbar (same style as score.dart)
    final unselected = const Color.fromARGB(
      255,
      71,
      71,
      71,
    ).withAlpha((0.70 * 255).round());

    final mustPay = _fees.where((e) => e.status == FeeStatus.mustPay).toList();
    final pending = _fees.where((e) => e.status == FeeStatus.pending).toList();
    final paid = _fees.where((e) => e.status == FeeStatus.paid).toList();

    return AppPageTemplate(
      title: "Fees",
      backgroundAsset: widget.backgroundAsset,
      showBack: widget.showBack,
      scrollable: false,

      // ✅ Make page premium gradient match global tabbar gradient
      premiumDarkGradient: tabGrad,

      contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tabs.AppModernCountTabBar(
            controller: _tab,
            indicatorGradient: tabGrad,
            labelColor: Colors.white,
            unselectedLabelColor: unselected,
            items: [
              tabs.AppTabItem(
                // Tabs requested (Lao). Meanings: Must Pay / Pending / Paid
                label: "ທີ່ຕ້ອງຈ່າຍ",
                icon: FontAwesomeIcons.moneyBillWave,
                count: mustPay.length,
              ),
              tabs.AppTabItem(
                label: "ກຳລັງກວດສອບ",
                icon: FontAwesomeIcons.clock,
                count: pending.length,
              ),
              tabs.AppTabItem(
                label: "ຈ່າຍແລ້ວ",
                icon: FontAwesomeIcons.circleCheck,
                count: paid.length,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _FeeListView(
                  items: mustPay,
                  emptyText: "No fees to pay 🎉",
                  onViewDetail: _openDetail,
                ),
                _FeeListView(
                  items: pending,
                  emptyText: "No pending payments",
                  onViewDetail: _openDetail,
                ),
                _FeeListView(
                  items: paid,
                  emptyText: "No payment history yet",
                  onViewDetail: _openDetail,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(FeeItem item) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: 280.ms,
        reverseTransitionDuration: 220.ms,
        pageBuilder: (_, a1, __) => FadeTransition(
          opacity: a1,
          child: FeeDetailPage(
            item: item,
            backgroundAsset: widget.backgroundAsset,
          ),
        ),
      ),
    );
  }
}

class _FeeListView extends StatelessWidget {
  const _FeeListView({
    required this.items,
    required this.onViewDetail,
    required this.emptyText,
  });

  final List<FeeItem> items;
  final void Function(FeeItem item) onViewDetail;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: _o(Theme.of(context).colorScheme.onSurface, .65),
          ),
        ),
      ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.08, end: 0);
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final item = items[i];

        return _FeeCardGlass(item: item, onViewDetail: () => onViewDetail(item))
            .animate()
            .fadeIn(duration: 220.ms, delay: (24 * i).ms)
            .slideY(begin: 0.12, end: 0, duration: 320.ms, delay: (24 * i).ms);
      },
    );
  }
}

class _FeeCardGlass extends StatelessWidget {
  const _FeeCardGlass({required this.item, required this.onViewDetail});

  final FeeItem item;
  final VoidCallback onViewDetail;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final cardBg = isDark ? _o(Colors.white, .08) : Colors.white;
    final border = isDark ? _o(Colors.white, .12) : _o(Colors.black, .08);
    final textMain = isDark ? Colors.white : Colors.black87;
    final textSub = _o(textMain, .65);

    final statusMeta = item.status.meta(cs, isDark);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onViewDetail,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: _o(Colors.black, isDark ? .16 : .06),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _FeeIcon(seed: item.seed, status: item.status),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textMain,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _MiniChip(
                              text: statusMeta.label,
                              bg: statusMeta.bg,
                              fg: statusMeta.fg,
                              border: statusMeta.border,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.note,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textSub,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.chevron_right_rounded, color: _o(textMain, .55)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InfoRow(
                      icon: FontAwesomeIcons.moneyBillWave,
                      label: "Amount",
                      value: item.amountText,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoRow(
                      icon: FontAwesomeIcons.calendar,
                      label: "Due date",
                      value: item.dueText,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _InfoRow(
                      icon: FontAwesomeIcons.circleInfo,
                      label: "Status",
                      value: statusMeta.valueText,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoRow(
                      icon: FontAwesomeIcons.clock,
                      label: "Paid time",
                      value: item.paidText,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Spacer(),
                  _ViewDetailButton(onPressed: onViewDetail),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeeIcon extends StatelessWidget {
  const _FeeIcon({required this.seed, required this.status});
  final int seed;
  final FeeStatus status;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final base = switch (status) {
      FeeStatus.mustPay => _kStatusMustPay,
      FeeStatus.pending => _kStatusPending,
      FeeStatus.paid => _kStatusPaid,
    };

    final bg = _o(base, isDark ? .22 : .14);
    final border = _o(base, isDark ? .34 : .22);

    IconData icon;
    switch (status) {
      case FeeStatus.mustPay:
        icon = FontAwesomeIcons.moneyBillWave;
        break;
      case FeeStatus.pending:
        icon = FontAwesomeIcons.clock;
        break;
      case FeeStatus.paid:
        icon = FontAwesomeIcons.circleCheck;
        break;
    }

    return Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          child: Center(
            child: FaIcon(icon, size: 18, color: isDark ? Colors.white : base),
          ),
        )
        .animate()
        .scale(duration: 220.ms, curve: Curves.easeOutBack)
        .fadeIn(duration: 200.ms);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textMain = isDark ? Colors.white : Colors.black87;
    final textSub = _o(textMain, .62);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? _o(Colors.white, .06) : _o(Colors.black, .03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? _o(Colors.white, .10) : _o(Colors.black, .06),
        ),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 14, color: _o(cs.primary, isDark ? .95 : .90)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textSub,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textMain,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
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

class _MiniChip extends StatelessWidget {
  const _MiniChip({
    required this.text,
    required this.bg,
    required this.fg,
    required this.border,
  });

  final String text;
  final Color bg;
  final Color fg;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w900, fontSize: 11),
      ),
    );
  }
}

class _ViewDetailButton extends StatelessWidget {
  const _ViewDetailButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? _o(cs.primary, .22) : _o(cs.primary, .12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? _o(cs.primary, .34) : _o(cs.primary, .20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.visibility_rounded, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    "View details",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 220.ms)
        .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
  }
}

class FeeDetailPage extends StatelessWidget {
  const FeeDetailPage({
    super.key,
    required this.item,
    this.backgroundAsset = FeePage._kDefaultBg,
  });

  final FeeItem item;
  final String backgroundAsset;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusMeta = item.status.meta(cs, isDark);

    return AppPageTemplate(
      title: "Fee details",
      backgroundAsset: backgroundAsset,
      showBack: true,
      scrollable: true,
      premiumDarkGradient: _kGlobalTabGradient,
      contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailHeader(item: item, statusMeta: statusMeta),
          const SizedBox(height: 12),
          _DetailCard(
            title: "Payment summary",
            rows: [
              _DetailRow("Fee", item.title),
              _DetailRow("Amount", item.amountText),
              _DetailRow("Status", statusMeta.valueText),
              _DetailRow("Due date", item.dueText),
              _DetailRow("Paid time", item.paidText),
              _DetailRow("Reference", item.reference),
            ],
          ),
          const SizedBox(height: 12),
          _DetailCard(
            title: "Notes",
            rows: [
              _DetailRow("Info", item.note),
              _DetailRow(
                "Support",
                "Contact the finance office for questions.",
              ),
            ],
          ),
          const SizedBox(height: 18),
          _PrimaryActionBar(item: item),
        ],
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.item, required this.statusMeta});
  final FeeItem item;
  final _StatusMeta statusMeta;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMain = isDark ? Colors.white : Colors.black87;
    final textSub = _o(textMain, .65);

    return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? _o(Colors.white, .08) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? _o(Colors.white, .12) : _o(Colors.black, .08),
            ),
            boxShadow: [
              BoxShadow(
                color: _o(Colors.black, isDark ? .16 : .06),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              _FeeIcon(seed: item.seed, status: item.status),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textMain,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textSub,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _MiniChip(
                text: statusMeta.label,
                bg: statusMeta.bg,
                fg: statusMeta.fg,
                border: statusMeta.border,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 240.ms)
        .slideY(begin: 0.08, end: 0, duration: 320.ms);
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.rows});

  final String title;
  final List<_DetailRow> rows;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMain = isDark ? Colors.white : Colors.black87;
    final textSub = _o(textMain, .65);

    return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? _o(Colors.white, .08) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? _o(Colors.white, .12) : _o(Colors.black, .08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textMain,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              ...rows.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          r.label,
                          style: TextStyle(
                            color: textSub,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          r.value,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: textMain,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 240.ms)
        .slideY(begin: 0.06, end: 0, duration: 320.ms);
  }
}

class _PrimaryActionBar extends StatelessWidget {
  const _PrimaryActionBar({required this.item});
  final FeeItem item;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final canPay = item.status == FeeStatus.mustPay;

    return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text("Back"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: isDark
                        ? _o(Colors.white, .18)
                        : _o(Colors.black, .10),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: canPay ? () {} : null,
                icon: const Icon(Icons.payment_rounded),
                label: Text(canPay ? "Pay now" : "Paid"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: cs.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 260.ms)
        .slideY(begin: 0.08, end: 0, duration: 340.ms);
  }
}

// -------------------- Demo Models --------------------

enum FeeStatus { mustPay, pending, paid }

extension on FeeStatus {
  _StatusMeta meta(ColorScheme cs, bool isDark) {
    switch (this) {
      case FeeStatus.mustPay:
        return _StatusMeta(
          label: "MUST PAY",
          valueText: "Must pay",
          bg: _o(_kStatusMustPay, isDark ? .18 : .12),
          fg: isDark ? Colors.white : _kStatusMustPay,
          border: _o(_kStatusMustPay, isDark ? .34 : .20),
        );
      case FeeStatus.pending:
        return _StatusMeta(
          label: "PENDING",
          valueText: "Pending verification",
          bg: _o(_kStatusPending, isDark ? .18 : .12),
          fg: isDark ? Colors.white : _kStatusPending,
          border: _o(_kStatusPending, isDark ? .34 : .20),
        );
      case FeeStatus.paid:
        return _StatusMeta(
          label: "PAID",
          valueText: "Payment successful",
          bg: _o(_kStatusPaid, isDark ? .18 : .12),
          fg: isDark ? Colors.white : _kStatusPaid,
          border: _o(_kStatusPaid, isDark ? .34 : .20),
        );
    }
  }
}

class _StatusMeta {
  const _StatusMeta({
    required this.label,
    required this.valueText,
    required this.bg,
    required this.fg,
    required this.border,
  });

  final String label;
  final String valueText;
  final Color bg;
  final Color fg;
  final Color border;
}

class FeeItem {
  FeeItem({
    required this.title,
    required this.amount,
    required this.status,
    required this.dueAt,
    required this.paidAt,
    required this.note,
    required this.reference,
    required this.seed,
  });

  final String title;
  final int amount; // LAK
  final FeeStatus status;
  final DateTime dueAt;
  final DateTime? paidAt;
  final String note;
  final String reference;
  final int seed;

  String get amountText => "${_formatInt(amount)} LAK";

  String get dueText => _formatDateTime(dueAt);

  String get paidText => paidAt == null ? "-" : _formatDateTime(paidAt!);
}

class FeeDemoFactory {
  static List<FeeItem> buildSample() {
    final now = DateTime.now();
    final r = Random(42);

    final names = <String>[
      "Tuition fee",
      "Exam fee",
      "Library fee",
      "Uniform fee",
      "Transportation fee",
      "Lab fee",
      "Activity fee",
      "School trip fee",
      "Sports fee",
      "Late payment penalty",
      "Canteen deposit",
      "Graduation fee",
    ];

    final out = <FeeItem>[];
    for (var i = 0; i < names.length; i++) {
      final status = (i % 3 == 0)
          ? FeeStatus.mustPay
          : (i % 3 == 1)
          ? FeeStatus.pending
          : FeeStatus.paid;

      final amount = 50000 + (r.nextInt(45) * 10000);
      final dueAt = now.add(Duration(days: (i % 5) + 1, hours: 9 + (i % 4)));

      DateTime? paidAt;
      if (status == FeeStatus.paid) {
        paidAt = now.subtract(Duration(days: (i % 6) + 1, hours: 2 + (i % 5)));
      } else if (status == FeeStatus.pending) {
        paidAt = now.subtract(Duration(days: 1, hours: 1 + (i % 4)));
      }

      out.add(
        FeeItem(
          title: names[i],
          amount: amount,
          status: status,
          dueAt: dueAt,
          paidAt: paidAt,
          note: "Semester 2 • Grade ${7 + (i % 6)}",
          reference: "FEE-${100200 + i}",
          seed: 1000 + i * 77,
        ),
      );
    }

    // Sort by due date ascending for Must Pay / Pending; Paid by paid time desc
    out.sort((a, b) {
      if (a.status == FeeStatus.paid && b.status == FeeStatus.paid) {
        return (b.paidAt ?? b.dueAt).compareTo(a.paidAt ?? a.dueAt);
      }
      return a.dueAt.compareTo(b.dueAt);
    });

    return out;
  }
}

class _DetailRow {
  const _DetailRow(this.label, this.value);
  final String label;
  final String value;
}

String _formatInt(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    b.write(s[i]);
    final remaining = s.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) b.write(',');
  }
  return b.toString();
}

String _two(int n) => n < 10 ? "0$n" : "$n";

String _formatDateTime(DateTime d) {
  // Simple readable format: YYYY-MM-DD HH:mm
  return "${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}";
}
