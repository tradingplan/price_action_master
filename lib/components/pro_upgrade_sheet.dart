import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/pro_access_service.dart';
import '/services/in_app_purchase_service.dart';

class ProUpgradeSheet extends StatefulWidget {
  final String? featureHighlighted;

  const ProUpgradeSheet({
    super.key,
    this.featureHighlighted,
  });

  static Future<void> show(BuildContext context, {String? featureHighlighted}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProUpgradeSheet(
        featureHighlighted: featureHighlighted,
      ),
    );
  }

  @override
  State<ProUpgradeSheet> createState() => _ProUpgradeSheetState();
}

class _ProUpgradeSheetState extends State<ProUpgradeSheet> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    InAppPurchaseService().addListener(_onIapUpdated);
    ProAccessService().addListener(_onProUpdated);
  }

  @override
  void dispose() {
    InAppPurchaseService().removeListener(_onIapUpdated);
    ProAccessService().removeListener(_onProUpdated);
    super.dispose();
  }

  void _onIapUpdated() {
    if (mounted) setState(() {});
  }

  void _onProUpdated() {
    if (ProAccessService().isPro && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF10B981),
          content: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Parabéns! Versão PRO Vitalícia desbloqueada com sucesso.',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _handleUnlock() async {
    final iap = InAppPurchaseService();
    if (iap.isAvailable && iap.proProduct != null) {
      setState(() => _isLoading = true);
      final launched = await iap.buyPro();
      if (!launched && mounted) {
        setState(() => _isLoading = false);
        if (iap.lastError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFFEF4444),
              content: Text(iap.lastError!),
            ),
          );
        }
      }
    } else {
      _showWebFallbackDialog();
    }
  }

  void _showWebFallbackDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF171C26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.info_outline_rounded, color: Color(0xFFF59E0B)),
            SizedBox(width: 10),
            Text('Faturamento Pro', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'A cobrança nativa via Google Play Store / App Store está ativa para dispositivos móveis.

No ambiente de testes web atual, você pode simular o desbloqueio PRO instantaneamente.',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isLoading = true);
              await ProAccessService().unlockProLifetime();
            },
            child: const Text('Simular Desbloqueio PRO'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRestore() async {
    setState(() => _isLoading = true);
    await InAppPurchaseService().restorePurchases();
    if (mounted) {
      setState(() => _isLoading = false);
      if (ProAccessService().isPro) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF10B981),
            content: Text('Acesso PRO restaurado com sucesso!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFEF4444),
            content: Text('Nenhuma compra anterior ativa encontrada.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF14171F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Crown Icon / Badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'Price Action Master PRO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.featureHighlighted != null
                  ? 'Desbloqueie "${widget.featureHighlighted}" e o arsenal operacional completo.'
                  : 'Desbloqueie o Playbook Operacional Completo e opere como os profissionais.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Benefits Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2433),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF2A344A),
                  width: 1,
                ),
              ),
              child: Column(
                children: const [
                  _BenefitRow(
                    icon: Icons.auto_graph_rounded,
                    title: '20 Estratégias Operacionais',
                    subtitle: 'Entry, stop, target e gestão tática passo a passo',
                  ),
                  Divider(color: Color(0xFF2A344A), height: 18),
                  _BenefitRow(
                    icon: Icons.shield_rounded,
                    title: 'Smart Money Concepts (SMC)',
                    subtitle: 'Order Block, Breaker Block e Liquidity Grab',
                  ),
                  Divider(color: Color(0xFF2A344A), height: 18),
                  _BenefitRow(
                    icon: Icons.checklist_rounded,
                    title: 'Checklist Pré-Trade Interativo',
                    subtitle: 'Valide critérios operacionais antes de cada ordem',
                  ),
                  Divider(color: Color(0xFF2A344A), height: 18),
                  _BenefitRow(
                    icon: Icons.block_rounded,
                    title: '100% Sem Anúncios',
                    subtitle: 'Foco total no aprendizado e nos gráficos',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Price Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFF59E0B).withOpacity(0.12),
                    const Color(0xFFD97706).withOpacity(0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'PAGAMENTO ÚNICO · LIFETIME',
                        style: TextStyle(
                          color: Color(0xFFF59E0B),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Sem mensalidades ou assinaturas',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: const [
                      Text(
                        'R\$ 49,90 ',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        InAppPurchaseService().formattedPrice,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Unlock Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleUnlock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : const Text(
                        'Desbloquear Acesso Vitalício',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),

            // Restore Purchases Button
            TextButton(
              onPressed: _isLoading ? null : _handleRestore,
              child: const Text(
                'Já comprou? Restaurar Acesso',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFFF59E0B)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

