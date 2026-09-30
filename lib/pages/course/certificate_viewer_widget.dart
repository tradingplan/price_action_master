import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/backend/local_data_manager.dart';
import 'package:price_action_master/backend/schema/platform_course_models.dart';

class CertificateViewerWidget extends StatelessWidget {
  final PlatformCertificate certificate;
  final String courseTitle;

  const CertificateViewerWidget({
    super.key,
    required this.certificate,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isValid = LocalDataManager.verifyCertificate(certificate);

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.close_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 28.0,
          ),
        ),
        title: Text(
          'Certificado de Conclusão',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Certificado Container (Moldura de Luxo)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color(0xFFF59E0B), // Ouro/Dourado
                    width: 3.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withAlpha(40),
                      blurRadius: 20.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
                child: Column(
                  children: [
                    // Selo Superior
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF59E0B).withAlpha(30),
                        border: Border.all(color: const Color(0xFFF59E0B), width: 2.0),
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Color(0xFFF59E0B),
                        size: 36.0,
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    const Text(
                      'PRICE ACTION MASTER',
                      style: TextStyle(
                        color: Color(0xFFF59E0B),
                        letterSpacing: 2.5,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    const Text(
                      'CERTIFICADO DE MESTRIA',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(color: Color(0xFF334155), thickness: 1),
                    const SizedBox(height: 14.0),
                    const Text(
                      'Certificamos que o trader',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12.0),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      certificate.studentName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'concluiu com êxito todos os módulos e requisitos do curso:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      courseTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Estatísticas de Conquista
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat(context, 'XP Conquistado', '+${certificate.metadata.xpEarned} XP', Icons.stars),
                        _buildStat(context, 'Emissão', certificate.issuedAt.split('T').first, Icons.calendar_today),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const Divider(color: Color(0xFF334155), thickness: 1),
                    const SizedBox(height: 12.0),

                    // Hash Criptográfico Anti-Fraude
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isValid ? Icons.verified_user : Icons.warning,
                          color: isValid ? FlutterFlowTheme.of(context).success : FlutterFlowTheme.of(context).error,
                          size: 16.0,
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          isValid ? 'Validação Criptográfica SHA-256 Offline' : 'Assinatura Inválida',
                          style: TextStyle(
                            color: isValid ? FlutterFlowTheme.of(context).success : FlutterFlowTheme.of(context).error,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    SelectableText(
                      certificate.verificationHash,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontFamily: 'monospace',
                        fontSize: 8.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24.0),

              // Botão de Compartilhar / Concluir
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: FlutterFlowTheme.of(context).success,
                      content: const Text(
                        'Hash de verificação copiado para a área de transferência!',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.share, size: 18.0, color: Colors.black),
                label: const Text(
                  'Compartilhar Conquista',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  minimumSize: const Size(double.infinity, 48.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFF59E0B), size: 14.0),
            const SizedBox(width: 4.0),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2.0),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 10.0),
        ),
      ],
    );
  }
}
