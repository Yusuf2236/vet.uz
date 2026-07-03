import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../widgets/section_header.dart';

/// Ferma boshqaruvi — ko'rsatkichlar, emlash eslatmalari va xodimlar litsenziyasi.
class FarmManagementScreen extends StatefulWidget {
  const FarmManagementScreen({super.key});

  @override
  State<FarmManagementScreen> createState() => _FarmManagementScreenState();
}

class _FarmManagementScreenState extends State<FarmManagementScreen> {
  final List<Map<String, String>> _employees = [
    {
      'name': 'Sherzod Rahimov',
      'role': 'Katta cho\'pon',
      'phone': '+998 93 501-22-33',
    },
    {
      'name': 'Umida Karimova',
      'role': 'Sut sog\'uvchi operator',
      'phone': '+998 90 345-67-89',
    },
    {
      'name': 'Rustam Tursunov',
      'role': 'Ferma yordamchisi',
      'phone': '+998 94 123-45-67',
    },
  ];

  static const List<({String animal, String vaccine, String due, bool soon})>
  _reminders = [
    (
      animal: 'Qoramol podasi',
      vaccine: 'Yashur (oqsil) vaksinasi',
      due: '3 kun ichida',
      soon: true,
    ),
    (
      animal: 'Boychibor',
      vaccine: 'Kuydirgi vaksinasi',
      due: '12 kun ichida',
      soon: false,
    ),
    (
      animal: 'Olapar (it)',
      vaccine: 'Quturishga qarshi',
      due: '1 hafta ichida',
      soon: true,
    ),
    (
      animal: 'Tovuqlar',
      vaccine: 'Nyukasl (La-Sota)',
      due: '20 kun ichida',
      soon: false,
    ),
  ];

  void _showAddEmployeeDialog() {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (ctx) {
        final titleColor = Theme.of(ctx).textTheme.titleLarge?.color;
        final secondary = Theme.of(ctx).textTheme.bodySmall?.color;

        return AlertDialog(
          backgroundColor: Theme.of(ctx).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: Text(
            "Yangi xodim qo'shish",
            style: AppTextStyles.h3.copyWith(color: titleColor),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Xodimlar boshqaruvi uchun qo'shimcha litsenziya",
                    style: AppTextStyles.caption.copyWith(color: secondary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.info, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Litsenziya narxi: 190,000 so'm / oy",
                            style: TextStyle(
                              color: AppColors.info,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "F.I.Sh.",
                      hintText: "Masalan: Sardor Alimov",
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? "Ismni kiriting" : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: roleController,
                    decoration: const InputDecoration(
                      labelText: "Lavozimi",
                      hintText: "Masalan: Yordamchi veterinar",
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? "Lavozimni kiriting" : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Telefon raqami",
                      hintText: "Masalan: +998 90 123-45-67",
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? "Telefon raqamini kiriting" : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Bekor qilish", style: TextStyle(color: secondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  setState(() {
                    _employees.add({
                      'name': nameController.text.trim(),
                      'role': roleController.text.trim(),
                      'phone': phoneController.text.trim(),
                    });
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Litsenziya faollashtirildi va xodim muvaffaqiyatli qo'shildi!"),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: const Text("To'lash va qo'shish"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.farmManagement, style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        children: [
          Text(
            AppStrings.farmStatus,
            style: AppTextStyles.h3.copyWith(color: titleColor),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (int i = 0; i < MockData.farmStats.length; i++) ...[
                if (i != 0) const SizedBox(width: AppSpacing.md),
                Expanded(child: _StatBox(index: i)),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const _MilkProductionChart(),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Emlash eslatmalari'),
          const SizedBox(height: AppSpacing.md),
          for (final r in _reminders) ...[
            _ReminderTile(
              animal: r.animal,
              vaccine: r.vaccine,
              due: r.due,
              soon: r.soon,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.xl),
          
          SectionHeader(
            title: 'Xodimlar boshqaruvi',
            actionLabel: "Qo'shish",
            onAction: _showAddEmployeeDialog,
          ),
          const SizedBox(height: AppSpacing.md),
          
          if (_employees.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(
                child: Text("Hozircha xodimlar yo'q", style: TextStyle(color: secondary)),
              ),
            )
          else
            for (final emp in _employees) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_outline, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emp['name'] ?? '',
                            style: AppTextStyles.title.copyWith(color: titleColor),
                          ),
                          Text(
                            "${emp['role']} · ${emp['phone']}",
                            style: AppTextStyles.caption.copyWith(color: secondary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        "Faol",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final int index;
  const _StatBox({required this.index});

  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.info,
    AppColors.accent,
  ];

  @override
  Widget build(BuildContext context) {
    final stat = MockData.farmStats[index];
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final valueColor = index == 0
        ? Theme.of(context).colorScheme.primary
        : _colors[index % _colors.length];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Text(stat.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stat.value,
              style: AppTextStyles.h3.copyWith(color: valueColor),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stat.unit,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final String animal;
  final String vaccine;
  final String due;
  final bool soon;

  const _ReminderTile({
    required this.animal,
    required this.vaccine,
    required this.due,
    required this.soon,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final c = soon ? AppColors.danger : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.vaccines_outlined, color: c, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  vaccine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: titleColor),
                ),
                Text(
                  '$animal · $due',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MilkProductionChart extends StatelessWidget {
  const _MilkProductionChart();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final dividerColor = Theme.of(context).dividerColor;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sut yetishtirish dinamikasi",
                style: AppTextStyles.title.copyWith(color: titleColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  "Haftalik",
                  style: AppTextStyles.label.copyWith(color: AppColors.info),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 160,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _ChartPainter(
                    progress: value,
                    gridColor: dividerColor.withValues(alpha: 0.5),
                    lineColor: AppColors.info,
                    labelColor: labelColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final double progress;
  final Color gridColor;
  final Color lineColor;
  final Color labelColor;

  _ChartPainter({
    required this.progress,
    required this.gridColor,
    required this.lineColor,
    required this.labelColor,
  });

  final List<String> days = ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'];
  final List<double> values = [2100, 2300, 2200, 2450, 2350, 2550, 2480];
  final double minY = 2000;
  final double maxY = 2600;

  @override
  void paint(Canvas canvas, Size size) {
    final paddingLeft = 48.0;
    final paddingBottom = 25.0;
    final paddingTop = 10.0;
    final paddingRight = 10.0;

    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;

    if (chartWidth <= 0 || chartHeight <= 0) return;

    // Draw Grid Lines and Y-axis Labels
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final gridSteps = 3;
    for (int i = 0; i <= gridSteps; i++) {
      final yValue = minY + (maxY - minY) * i / gridSteps;
      final yPos = paddingTop + chartHeight - (chartHeight * i / gridSteps);

      // Grid line
      canvas.drawLine(
        Offset(paddingLeft, yPos),
        Offset(paddingLeft + chartWidth, yPos),
        gridPaint,
      );

      // Y-label
      textPainter.text = TextSpan(
        text: '${yValue.toInt()}',
        style: TextStyle(color: labelColor, fontSize: 11, fontWeight: FontWeight.w500),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(paddingLeft - textPainter.width - 8, yPos - textPainter.height / 2),
      );
    }

    // Calculate Point Offsets
    final points = <Offset>[];
    final stepX = chartWidth / (values.length - 1);
    for (int i = 0; i < values.length; i++) {
      final x = paddingLeft + i * stepX;
      // Animate the Y value by interpolation towards the progress
      final normalY = (values[i] - minY) / (maxY - minY);
      final animatedNormalY = normalY * progress;
      final y = paddingTop + chartHeight - (chartHeight * animatedNormalY);
      points.add(Offset(x, y));
    }

    // Draw X-axis labels
    for (int i = 0; i < days.length; i++) {
      textPainter.text = TextSpan(
        text: days[i],
        style: TextStyle(color: labelColor, fontSize: 11, fontWeight: FontWeight.w500),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(points[i].dx - textPainter.width / 2, size.height - textPainter.height),
      );
    }

    // Draw Gradient Area Under the Path
    final areaPath = Path();
    areaPath.moveTo(points.first.dx, paddingTop + chartHeight);
    for (final p in points) {
      areaPath.lineTo(p.dx, p.dy);
    }
    areaPath.lineTo(points.last.dx, paddingTop + chartHeight);
    areaPath.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [lineColor.withValues(alpha: 0.35), lineColor.withValues(alpha: 0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(paddingLeft, paddingTop, chartWidth, chartHeight));
    
    canvas.drawPath(areaPath, gradientPaint);

    // Draw Line Path (Smooth cubic curve)
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlX1 = p1.dx + stepX / 2;
      final controlY1 = p1.dy;
      final controlX2 = p2.dx - stepX / 2;
      final controlY2 = p2.dy;
      linePath.cubicTo(controlX1, controlY1, controlX2, controlY2, p2.dx, p2.dy);
    }

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(linePath, linePaint);

    // Draw Dots on Points
    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    
    final dotOuterPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final p in points) {
      canvas.drawCircle(p, 5.0, dotOuterPaint);
      canvas.drawCircle(p, 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.labelColor != labelColor;
  }
}
