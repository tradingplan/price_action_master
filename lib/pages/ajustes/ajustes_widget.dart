import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '/backend/local_data_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'ajustes_model.dart';
export 'ajustes_model.dart';

class AjustesWidget extends StatefulWidget {
  const AjustesWidget({super.key});

  static String routeName = 'Ajustes';
  static String routePath = '/ajustes';

  @override
  State<AjustesWidget> createState() => _AjustesWidgetState();
}

class _AjustesWidgetState extends State<AjustesWidget> {
  late AjustesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int _userXP = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AjustesModel());
    _loadStats();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _loadStats() {
    final xp = LocalDataManager.getXP();
    setState(() {
      _userXP = xp;
    });
  }

  Future<void> _resetCourseProgress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FlutterFlowTheme.of(ctx).secondaryBackground,
        title: Text(
          'Resetar Progresso',
          style: FlutterFlowTheme.of(ctx).titleMedium.override(
                fontFamily: FlutterFlowTheme.of(ctx).titleMediumFamily,
                color: FlutterFlowTheme.of(ctx).primaryText,
                fontWeight: FontWeight.bold,
              ),
        ),
        content: Text(
          'Tem certeza de que deseja resetar todo o progresso dos cursos e o XP acumulado? Esta ação não pode ser desfeita.',
          style: FlutterFlowTheme.of(ctx).bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: TextStyle(color: FlutterFlowTheme.of(ctx).secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(ctx).error,
            ),
            child: const Text('Resetar Tudo', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await LocalDataManager.clearAllData();
      _loadStats();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            content: const Text('Progresso resetado com sucesso!'),
          ),
        );
      }
    }
  }

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse('https://tradingplan.com.br/pv/pam-privacy/');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: FlutterFlowTheme.of(context).error,
            content: const Text('Não foi possível abrir o link da política de privacidade.'),
          ),
        );
      }
    }
  }

  Future<void> _shareApp() async {
    const shareUrl = 'https://tradingplan.com.br/pv/pam-privacy/';
    const shareText =
        '📈 Domine Price Action, Smart Money Concepts e Padrões de Candlesticks com o Price Action Master! 100% Offline.\n\nAcesse: $shareUrl';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final modalTheme = FlutterFlowTheme.of(ctx);
        return Container(
          padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 28.0),
          decoration: BoxDecoration(
            color: modalTheme.secondaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10.0,
                color: Color(0x33000000),
                offset: Offset(0.0, -4.0),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.0,
                height: 4.0,
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: modalTheme.lineColor,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: modalTheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(Icons.share_rounded, color: modalTheme.primary, size: 24.0),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Compartilhar Aplicativo',
                          style: modalTheme.titleMedium.override(
                            fontFamily: modalTheme.titleMediumFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Recomende o Price Action Master para outros traders',
                          style: modalTheme.bodySmall.override(
                            fontFamily: modalTheme.bodySmallFamily,
                            color: modalTheme.secondaryText,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // Botão WhatsApp
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: modalTheme.lineColor),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withAlpha(25),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF25D366), size: 20.0),
                ),
                title: Text(
                  'Enviar via WhatsApp',
                  style: modalTheme.bodyMedium.override(
                    fontFamily: modalTheme.bodyMediumFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: modalTheme.secondaryText),
                onTap: () async {
                  Navigator.pop(ctx);
                  final whatsappUrl = Uri.parse(
                    'https://api.whatsapp.com/send?text=${Uri.encodeComponent(shareText)}',
                  );
                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              const SizedBox(height: 10.0),
              // Botão Copiar Link
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: modalTheme.lineColor),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: modalTheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(Icons.copy_rounded, color: modalTheme.primary, size: 20.0),
                ),
                title: Text(
                  'Copiar Mensagem e Link',
                  style: modalTheme.bodyMedium.override(
                    fontFamily: modalTheme.bodyMediumFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: modalTheme.secondaryText),
                onTap: () async {
                  Navigator.pop(ctx);
                  await Clipboard.setData(const ClipboardData(text: shareText));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        content: const Text('Mensagem e link copiados com sucesso!'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          'Ajustes',
          style: theme.headlineSmall.override(
            fontFamily: theme.headlineSmallFamily,
            color: theme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card do App & Versão
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: theme.lineColor),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x1A000000),
                      offset: Offset(0.0, 2.0),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52.0,
                      height: 52.0,
                      decoration: BoxDecoration(
                        color: theme.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Icon(
                        Icons.candlestick_chart_rounded,
                        color: theme.primary,
                        size: 30.0,
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price Action Master',
                            style: theme.titleMedium.override(
                              fontFamily: theme.titleMediumFamily,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            'Versão 2.0 • 100% Offline-First',
                            style: theme.bodySmall.override(
                              fontFamily: theme.bodySmallFamily,
                              color: theme.secondaryText,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Gamificação & Estatísticas
              Text(
                'PROGRESSO DO ALUNO',
                style: theme.bodySmall.override(
                  fontFamily: theme.bodySmallFamily,
                  color: theme.secondaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.0,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: theme.lineColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      icon: Icons.bolt,
                      iconColor: const Color(0xFFE5A100),
                      value: '$_userXP XP',
                      label: 'Total Acumulado',
                    ),
                    Container(
                      width: 1.0,
                      height: 36.0,
                      color: theme.lineColor,
                    ),
                    _buildStatItem(
                      context,
                      icon: Icons.military_tech_outlined,
                      iconColor: theme.primary,
                      value: _userXP >= 1000 ? 'Avançado' : (_userXP >= 400 ? 'Intermediário' : 'Iniciante'),
                      label: 'Nível Atual',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Gerenciamento de Dados
              Text(
                'ARMAZENAMENTO & DADOS LOCAIS',
                style: theme.bodySmall.override(
                  fontFamily: theme.bodySmallFamily,
                  color: theme.secondaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.0,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: theme.lineColor),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.refresh_rounded, color: theme.error),
                      title: Text(
                        'Resetar Progresso dos Cursos',
                        style: theme.bodyMedium.override(
                          fontFamily: theme.bodyMediumFamily,
                          color: theme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Apaga módulos concluídos e zera o XP local',
                        style: theme.bodySmall.override(
                          fontFamily: theme.bodySmallFamily,
                          color: theme.secondaryText,
                          fontSize: 11.0,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right, color: theme.secondaryText),
                      onTap: _resetCourseProgress,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Sobre
              Text(
                'SOBRE A PLATAFORMA',
                style: theme.bodySmall.override(
                  fontFamily: theme.bodySmallFamily,
                  color: theme.secondaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.0,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: theme.lineColor),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.offline_bolt_outlined, color: theme.primary),
                      title: Text(
                        'Modo 100% Offline',
                        style: theme.bodyMedium.override(
                          fontFamily: theme.bodyMediumFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Todos os catálogos e ferramentas funcionam sem internet',
                        style: theme.bodySmall.override(
                          fontFamily: theme.bodySmallFamily,
                          color: theme.secondaryText,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                    Divider(height: 1.0, color: theme.lineColor),
                    ListTile(
                      leading: Icon(Icons.info_outline, color: theme.secondaryText),
                      title: Text(
                        'Finalidade Educacional',
                        style: theme.bodyMedium.override(
                          fontFamily: theme.bodyMediumFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'O Price Action Master destina-se exclusivamente ao aprendizado técnico e simulação.',
                        style: theme.bodySmall.override(
                          fontFamily: theme.bodySmallFamily,
                          color: theme.secondaryText,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                    Divider(height: 1.0, color: theme.lineColor),
                    ListTile(
                      leading: Icon(Icons.share_outlined, color: theme.primary),
                      title: Text(
                        'Compartilhar este Aplicativo',
                        style: theme.bodyMedium.override(
                          fontFamily: theme.bodyMediumFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Recomende para outros traders e amigos',
                        style: theme.bodySmall.override(
                          fontFamily: theme.bodySmallFamily,
                          color: theme.secondaryText,
                          fontSize: 11.0,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right, color: theme.secondaryText),
                      onTap: _shareApp,
                    ),
                    Divider(height: 1.0, color: theme.lineColor),
                    ListTile(
                      leading: Icon(Icons.privacy_tip_outlined, color: theme.primary),
                      title: Text(
                        'Política de Privacidade',
                        style: theme.bodyMedium.override(
                          fontFamily: theme.bodyMediumFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'tradingplan.com.br/pv/pam-privacy',
                        style: theme.bodySmall.override(
                          fontFamily: theme.bodySmallFamily,
                          color: theme.secondaryText,
                          fontSize: 11.0,
                        ),
                      ),
                      trailing: Icon(Icons.open_in_new_rounded, color: theme.secondaryText, size: 18.0),
                      onTap: _openPrivacyPolicy,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 18.0),
            const SizedBox(width: 4.0),
            Text(
              value,
              style: theme.titleMedium.override(
                fontFamily: theme.titleMediumFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2.0),
        Text(
          label,
          style: theme.bodySmall.override(
            fontFamily: theme.bodySmallFamily,
            color: theme.secondaryText,
            fontSize: 11.0,
          ),
        ),
      ],
    );
  }
}
