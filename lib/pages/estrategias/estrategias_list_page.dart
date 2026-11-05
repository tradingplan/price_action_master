import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/backend/schema/strategy_model.dart';
import '/backend/repositories/strategy_repository.dart';
import '/services/pro_access_service.dart';
import '/components/pro_upgrade_sheet.dart';
import '/main.dart';
import 'estrategia_detail_page.dart';

class EstrategiasListPage extends StatefulWidget {
  const EstrategiasListPage({super.key});

  static String routeName = 'EstrategiasList';
  static String routePath = '/estrategias';

  @override
  State<EstrategiasListPage> createState() => _EstrategiasListPageState();
}

class _EstrategiasListPageState extends State<EstrategiasListPage> {
  final StrategyRepository _repository = LocalStrategyRepository();
  final TextEditingController _searchController = TextEditingController();

  List<StrategyModel> _allStrategies = [];
  List<String> _categories = ['Todas'];
  String _selectedCategory = 'Todas';
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final strategies = await _repository.getAllStrategies();
    final categories = await _repository.getCategories();
    if (mounted) {
      setState(() {
        _allStrategies = strategies;
        _categories = categories;
        _isLoading = false;
      });
    }
  }

  List<StrategyModel> get _filteredStrategies {
    return _allStrategies.where((s) {
      final matchesCategory =
          _selectedCategory == 'Todas' || s.categoria == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          s.nome.toLowerCase().contains(_searchQuery) ||
          s.categoria.toLowerCase().contains(_searchQuery) ||
          s.tags.any((t) => t.toLowerCase().contains(_searchQuery)) ||
          s.descricaoCurta.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return AnimatedBuilder(
      animation: ProAccessService(),
      builder: (context, _) {
        final isPro = ProAccessService().isPro;

        return Scaffold(
          backgroundColor: theme.primaryBackground,
          appBar: AppBar(
            backgroundColor: theme.secondaryBackground,
            elevation: 0.5,
            leading: Builder(
              builder: (ctx) {
                final canPop = Navigator.of(ctx).canPop();
                return IconButton(
                  icon: Icon(
                    canPop ? Icons.arrow_back_ios_new_rounded : Icons.menu_rounded,
                    color: theme.primaryText,
                    size: canPop ? 20 : 24,
                  ),
                  tooltip: canPop ? 'Voltar' : 'Menu',
                  onPressed: () {
                    if (canPop) {
                      Navigator.of(ctx).pop();
                    } else {
                      NavBarPage.openDrawer();
                    }
                  },
                );
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Playbook Operacional',
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '20 Setups Táticos de Alta Probabilidade',
                  style: TextStyle(
                    color: theme.secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      if (!isPro) {
                        ProUpgradeSheet.show(context);
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: isPro
                            ? LinearGradient(
                                colors: [
                                  theme.success,
                                  theme.success.withAlpha(200)
                                ],
                              )
                            : const LinearGradient(
                                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                              ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (isPro ? theme.success : const Color(0xFFF59E0B))
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPro
                                ? Icons.verified_rounded
                                : Icons.workspace_premium_rounded,
                            size: 14,
                            color: isPro ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isPro ? 'PRO ATIVO' : 'SEJA PRO',
                            style: TextStyle(
                              color: isPro ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                  ),
                )
              : Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.lineColor),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x06000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: theme.primaryText, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Buscar setup, SMC, rompimento, VWAP...',
                            hintStyle: TextStyle(
                                color: theme.secondaryText, fontSize: 13),
                            prefixIcon: Icon(Icons.search_rounded,
                                color: theme.secondaryText, size: 20),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.close_rounded,
                                        color: theme.secondaryText, size: 18),
                                    onPressed: () => _searchController.clear(),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                    ),

                    // Category Filter Pills
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = cat == _selectedCategory;
                          return ChoiceChip(
                            label: Text(
                              cat,
                              style: TextStyle(
                                color: isSelected ? Colors.white : theme.primaryText,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: theme.primary,
                            backgroundColor: theme.secondaryBackground,
                            side: BorderSide(
                              color: isSelected
                                  ? theme.primary
                                  : theme.lineColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = cat;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Pro Upsell Banner (if user is not pro)
                    if (!isPro)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: InkWell(
                          onTap: () => ProUpgradeSheet.show(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFF59E0B),
                                width: 1.2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0A000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.lock_open_rounded,
                                    color: Color(0xFFB45309), size: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Desbloqueie todos os 20 setups operacionais por R\$ 19,90 vitalício',
                                    style: TextStyle(
                                      color: Color(0xFF92400E),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    color: Color(0xFFB45309), size: 14),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Strategies List
                    Expanded(
                      child: _filteredStrategies.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off_rounded,
                                      color: theme.secondaryText, size: 48),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Nenhuma estratégia encontrada',
                                    style: TextStyle(
                                      color: theme.secondaryText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: _filteredStrategies.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final strategy = _filteredStrategies[index];
                                return _StrategyCard(
                                  strategy: strategy,
                                  isProUser: isPro,
                                  onTap: () {
                                    if (strategy.isPro && !isPro) {
                                      ProUpgradeSheet.show(
                                        context,
                                        featureHighlighted: strategy.nome,
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EstrategiaDetailPage(
                                            strategy: strategy,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _StrategyCard extends StatelessWidget {
  final StrategyModel strategy;
  final bool isProUser;
  final VoidCallback onTap;

  const _StrategyCard({
    required this.strategy,
    required this.isProUser,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isLocked = strategy.isPro && !isProUser;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLocked ? theme.lineColor : theme.primary.withAlpha(40),
            width: isLocked ? 1.0 : 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: category badge + Pro/Free badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    strategy.categoria,
                    style: TextStyle(
                      color: theme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (strategy.isPro)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isLocked
                          ? const Color(0xFFFEF3C7)
                          : const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isLocked
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF10B981),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isLocked
                              ? Icons.lock_rounded
                              : Icons.check_circle_rounded,
                          size: 12,
                          color: isLocked
                              ? const Color(0xFFB45309)
                              : const Color(0xFF047857),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isLocked ? 'PRO' : 'DESBLOQUEADO',
                          style: TextStyle(
                            color: isLocked
                                ? const Color(0xFFB45309)
                                : const Color(0xFF047857),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF10B981),
                        width: 0.8,
                      ),
                    ),
                    child: const Text(
                      'GRATUITO',
                      style: TextStyle(
                        color: Color(0xFF047857),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              strategy.nome,
              style: TextStyle(
                color: theme.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (strategy.descricaoCurta.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                strategy.descricaoCurta,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.secondaryText,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ],
            const SizedBox(height: 12),

            // Bottom info: markets & checklist rules count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    for (final m in strategy.mercados)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          '• $m',
                          style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.checklist_rounded,
                        color: theme.primary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${strategy.checklist.length} checagens',
                      style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
