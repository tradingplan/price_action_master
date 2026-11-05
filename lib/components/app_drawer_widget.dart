import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/backend/local_data_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/pro_access_service.dart';
import '/components/pro_upgrade_sheet.dart';
import '/index.dart';
import '/main.dart';

class AppDrawerWidget extends StatefulWidget {
  const AppDrawerWidget({super.key});

  @override
  State<AppDrawerWidget> createState() => _AppDrawerWidgetState();
}

class _AppDrawerWidgetState extends State<AppDrawerWidget> {
  int _xp = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    setState(() {
      _xp = LocalDataManager.getXP();
    });
  }

  String _getUserLevel(int xp) {
    if (xp >= 1000) return 'Trader Avançado';
    if (xp >= 400) return 'Trader Intermediário';
    return 'Trader Iniciante';
  }

  void _navigateToTab(String tabName) {
    Navigator.of(context).pop(); // fecha o drawer
    final navPage = NavBarPage.of(context);
    if (navPage != null) {
      navPage.changeTab(tabName);
    }
  }

  Future<void> _openPrivacy() async {
    Navigator.of(context).pop();
    final uri = Uri.parse('https://tradingplan.com.br/pv/pam/privacidade.html');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Drawer(
      backgroundColor: theme.secondaryBackground,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // 1. Header do Usuário & XP
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      border: Border(
                        bottom: BorderSide(color: theme.lineColor, width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: theme.primary.withAlpha(25),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.candlestick_chart_rounded,
                                color: theme.primary,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price Action Master',
                                    style: TextStyle(
                                      color: theme.primaryText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getUserLevel(_xp),
                                    style: TextStyle(
                                      color: theme.secondaryText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // XP Bar Indicator
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.lineColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.bolt, color: Color(0xFFF59E0B), size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$_xp XP Acumulado',
                                    style: TextStyle(
                                      color: theme.primaryText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Offline-First',
                                style: TextStyle(
                                  color: theme.secondaryText,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Banner de Status PRO
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                    child: AnimatedBuilder(
                      animation: ProAccessService(),
                      builder: (context, _) {
                        final isPro = ProAccessService().isPro;
                        if (isPro) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF10B981),
                              ),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.verified_rounded, color: Color(0xFF047857), size: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'PRO Vitalício Ativo · Sem Ads',
                                    style: TextStyle(
                                      color: Color(0xFF047857),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            ProUpgradeSheet.show(context);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.workspace_premium_rounded, color: Color(0xFFB45309), size: 24),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Seja PRO Vitalício',
                                        style: TextStyle(
                                          color: Color(0xFF92400E),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        '20 Setups, SMC & Sem Anúncios',
                                        style: TextStyle(
                                          color: Color(0xFFB45309),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFB45309), size: 14),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 3. Seção: PILARES PRINCIPAIS
                  _DrawerSectionTitle(title: 'CONTEÚDO PRINCIPAL', theme: theme),
                  _DrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Início',
                    theme: theme,
                    onTap: () => _navigateToTab('Inicio'),
                  ),
                  _DrawerItem(
                    icon: Icons.school_rounded,
                    title: 'Cursos & Módulos',
                    theme: theme,
                    onTap: () => _navigateToTab('Cursos'),
                  ),
                  _DrawerItem(
                    icon: Icons.auto_graph_rounded,
                    title: 'Playbook Operacional (20 Setups)',
                    badgeText: 'NOVO',
                    badgeColor: const Color(0xFFF59E0B),
                    theme: theme,
                    onTap: () => _navigateToTab('Playbook'),
                  ),
                  _DrawerItem(
                    icon: Icons.candlestick_chart_rounded,
                    title: 'Candlesticks (Velas)',
                    theme: theme,
                    onTap: () => _navigateToTab('VelasJaponesas'),
                  ),

                  Divider(color: theme.lineColor, height: 24),

                  // 4. Seção: FERRAMENTAS & PRÁTICA
                  _DrawerSectionTitle(title: 'FERRAMENTAS & PRÁTICA', theme: theme),
                  _DrawerItem(
                    icon: Icons.calculate_outlined,
                    title: 'Calculadoras (Lote & Risco)',
                    theme: theme,
                    onTap: () => _navigateToTab('Calculadoras'),
                  ),
                  _DrawerItem(
                    icon: Icons.quiz_outlined,
                    title: 'Quizzes & Desafios',
                    theme: theme,
                    onTap: () => _navigateToTab('Quiz'),
                  ),
                  _DrawerItem(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Tarot do Trader (Psicologia)',
                    theme: theme,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.pushNamed(
                        TarotWidget.routeName,
                        extra: <String, dynamic>{
                          '__transition_info__': const TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.rightToLeft,
                          ),
                        },
                      );
                    },
                  ),

                  Divider(color: theme.lineColor, height: 24),

                  // 5. Seção: SISTEMA & PREFERÊNCIAS
                  _DrawerSectionTitle(title: 'PREFERÊNCIAS', theme: theme),
                  _DrawerItem(
                    icon: Icons.settings_rounded,
                    title: 'Ajustes & Dados',
                    theme: theme,
                    onTap: () => _navigateToTab('Ajustes'),
                  ),
                  _DrawerItem(
                    icon: Icons.shield_outlined,
                    title: 'Política de Privacidade (LGPD)',
                    theme: theme,
                    onTap: _openPrivacy,
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: theme.lineColor, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price Action Master v2.0',
                    style: TextStyle(color: theme.secondaryText, fontSize: 11),
                  ),
                  Text(
                    '100% Offline',
                    style: TextStyle(
                      color: theme.success,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerSectionTitle extends StatelessWidget {
  final String title;
  final FlutterFlowTheme theme;

  const _DrawerSectionTitle({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
      child: Text(
        title,
        style: TextStyle(
          color: theme.secondaryText,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? badgeText;
  final Color? badgeColor;
  final FlutterFlowTheme theme;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.theme,
    this.badgeText,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      horizontalTitleGap: 10,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Icon(icon, color: theme.secondaryText, size: 22),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: theme.primaryText,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (badgeText != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor ?? const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badgeText!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}
