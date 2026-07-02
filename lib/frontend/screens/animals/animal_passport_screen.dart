import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/animal.dart';

class AnimalPassportScreen extends StatefulWidget {
  final Animal animal;

  const AnimalPassportScreen({super.key, required this.animal});

  @override
  State<AnimalPassportScreen> createState() => _AnimalPassportScreenState();
}

class _AnimalPassportScreenState extends State<AnimalPassportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<VaccineRecord> _vaccines;
  late List<MedicalRecord> _medicalLogs;
  late List<ReminderRecord> _reminders;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _vaccines = List.from(widget.animal.vaccines);
    _medicalLogs = List.from(widget.animal.medicalLogs);
    _reminders = List.from(widget.animal.reminders);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addVaccine() {
    final nameCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: const Text("Yangi emlash qo'shish", style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Vaksina nomi"),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: dateCtrl,
              decoration: const InputDecoration(labelText: "Sana (kun.oy.yil)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Bekor qilish"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty && dateCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _vaccines.add(
                    VaccineRecord(
                      name: nameCtrl.text.trim(),
                      date: dateCtrl.text.trim(),
                      completed: false,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("Qo'shish", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addMedicalLog() {
    final titleCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: const Text("Tibbiy yozuv qo'shish", style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Tashxis / Sabab"),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: noteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Tavsif va shifokor eslatmalari"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Bekor qilish"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty && noteCtrl.text.trim().isNotEmpty) {
                final now = DateTime.now();
                final formattedDate = "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}";
                setState(() {
                  _medicalLogs.insert(
                    0,
                    MedicalRecord(
                      title: titleCtrl.text.trim(),
                      date: formattedDate,
                      note: noteCtrl.text.trim(),
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("Qo'shish", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addReminder() {
    final titleCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    String period = "Har kuni";

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(ctx).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: const Text("Yangi eslatma qo'shish", style: AppTextStyles.h3),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Eslatma nomi"),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: timeCtrl,
                decoration: const InputDecoration(labelText: "Vaqt (soat:daqiqa)"),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: period,
                items: ["Har kuni", "Har haftada", "Har oyda"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setDialogState(() => period = val);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Bekor qilish"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isNotEmpty && timeCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    _reminders.add(
                      ReminderRecord(
                        title: titleCtrl.text.trim(),
                        time: timeCtrl.text.trim(),
                        period: period,
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text("Qo'shish", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondaryColor = Theme.of(context).textTheme.bodySmall?.color;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.animal.name} Pasporti", style: AppTextStyles.h3),
      ),
      body: Column(
        children: [
          // Animal Info Card
          Container(
            margin: const EdgeInsets.all(AppSpacing.screenH),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF162A24), const Color(0xFF0F1A17)]
                    : [AppColors.primary.withValues(alpha: 0.1), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(widget.animal.icon, color: AppColors.primary, size: 32),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.animal.name,
                        style: AppTextStyles.h2.copyWith(color: titleColor),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${widget.animal.type} · ${widget.animal.breed} · ${widget.animal.age}",
                        style: AppTextStyles.body.copyWith(color: secondaryColor),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            widget.animal.healthy ? Icons.check_circle : Icons.warning_amber_rounded,
                            size: 16,
                            color: widget.animal.healthy ? AppColors.success : AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.animal.health,
                            style: AppTextStyles.caption.copyWith(
                              color: widget.animal.healthy ? AppColors.success : AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tabs Selector
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: "Emlashlar"),
              Tab(text: "Tibbiy karta"),
              Tab(text: "Eslatmalar"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVaccinesTab(),
                _buildMedicalLogsTab(),
                _buildRemindersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinesTab() {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondaryColor = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addVaccine,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_moderator),
        label: const Text("Emlash qo'shish"),
      ),
      body: _vaccines.isEmpty
          ? const Center(child: Text("Emlashlar tarixi mavjud emas"))
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenH),
              itemCount: _vaccines.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (ctx, i) {
                final v = _vaccines[i];
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        v.completed ? Icons.verified : Icons.pending_actions,
                        color: v.completed ? AppColors.success : AppColors.amber,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              v.name,
                              style: AppTextStyles.bodyStrong.copyWith(color: titleColor),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              v.completed ? "Emlangan: ${v.date}" : "Kutilayotgan sana: ${v.date}",
                              style: AppTextStyles.caption.copyWith(color: secondaryColor),
                            ),
                          ],
                        ),
                      ),
                      if (!v.completed)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _vaccines[i] = VaccineRecord(
                                name: v.name,
                                date: v.date,
                                completed: true,
                              );
                            });
                          },
                          child: const Text("Emlandi"),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMedicalLogsTab() {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondaryColor = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMedicalLog,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.note_add),
        label: const Text("Yozuv qo'shish"),
      ),
      body: _medicalLogs.isEmpty
          ? const Center(child: Text("Tibbiy ko'riklar tarixi mavjud emas"))
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenH),
              itemCount: _medicalLogs.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (ctx, i) {
                final log = _medicalLogs[i];
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            log.title,
                            style: AppTextStyles.bodyStrong.copyWith(color: titleColor),
                          ),
                          Text(
                            log.date,
                            style: AppTextStyles.caption.copyWith(color: secondaryColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        log.note,
                        style: AppTextStyles.body.copyWith(color: secondaryColor),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildRemindersTab() {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondaryColor = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addReminder,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alarm),
        label: const Text("Eslatma qo'shish"),
      ),
      body: _reminders.isEmpty
          ? const Center(child: Text("Faol eslatmalar mavjud emas"))
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenH),
              itemCount: _reminders.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (ctx, i) {
                final rem = _reminders[i];
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.alarm, color: AppColors.primary, size: 24),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rem.title,
                              style: AppTextStyles.bodyStrong.copyWith(color: titleColor),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${rem.period} - soat ${rem.time}",
                              style: AppTextStyles.caption.copyWith(color: secondaryColor),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                        onPressed: () {
                          setState(() {
                            _reminders.removeAt(i);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
