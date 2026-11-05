import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store_bloc.dart';
import '../bloc/store_state.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../ui/common.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({
    super.key,
    required this.authService,
    this.onGuestPreview,
  });

  final AuthService authService;
  final VoidCallback? onGuestPreview;

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Masukkan email dan password admin terlebih dahulu.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await widget.authService.signIn(email: email, password: password);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AuthService.friendlyError(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Bp.mobile(context);

    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        final store = state.store;
        final pal = store.palette;

        return Scaffold(
          backgroundColor: pal.surface,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: mobile ? 20 : 32,
                  vertical: 28,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: PillButton(
                          label: 'Kembali ke Etalase',
                          icon: Icons.arrow_back_rounded,
                          bg: pal.surfaceContainer,
                          hoverBg: pal.surfaceHigh,
                          fg: pal.primary,
                          fontSize: 12.5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(mobile ? 24 : 32),
                        decoration: BoxDecoration(
                          color: pal.surfaceLowest,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: pal.outlineVariant.withValues(alpha: 0.45),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: pal.primary.withValues(alpha: 0.06),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: pal.primary,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Icon(
                                      store.logoIcon,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PORTAL PENGELOLA GERAI',
                                          style: Txt.sans(
                                            10.5,
                                            weight: FontWeight.w800,
                                            color: pal.secondary,
                                            spacing: 1.1,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          store.name,
                                          style: Txt.sans(
                                            13,
                                            weight: FontWeight.w600,
                                            color: pal.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              Text(
                                'Masuk ke Panel Admin',
                                style: Txt.serif(
                                  mobile ? 26 : 30,
                                  weight: FontWeight.w500,
                                  color: pal.primary,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Gunakan akun pengelola resmi untuk mengubah menu, stok cepat, status buka/tutup, dan banner promo secara live.',
                                style: Txt.sans(
                                  13.5,
                                  color: pal.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              if (_error != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE4E6),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFDA4AF),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: Color(0xFFBE123C),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _error!,
                                          style: Txt.sans(
                                            12.5,
                                            weight: FontWeight.w600,
                                            color: const Color(0xFF9F1239),
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                              ],
                              Text(
                                'Email Admin',
                                style: Txt.sans(
                                  12.5,
                                  weight: FontWeight.w700,
                                  color: pal.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _LoginInput(
                                controller: _emailCtrl,
                                pal: pal,
                                hint: 'admin@tokoanda.com',
                                icon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                onSubmitted: (_) => _submit(),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Password',
                                style: Txt.sans(
                                  12.5,
                                  weight: FontWeight.w700,
                                  color: pal.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _LoginInput(
                                controller: _passwordCtrl,
                                pal: pal,
                                hint: '••••••••',
                                icon: Icons.lock_outline_rounded,
                                obscureText: _obscure,
                                autofillHints: const [AutofillHints.password],
                                onSubmitted: (_) => _submit(),
                                suffix: IconButton(
                                  tooltip: _obscure
                                      ? 'Tampilkan password'
                                      : 'Sembunyikan password',
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                    color: pal.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              PillButton(
                                label: _loading
                                    ? 'Memverifikasi Akses...'
                                    : 'Masuk sebagai Admin',
                                icon: _loading
                                    ? Icons.hourglass_top_rounded
                                    : Icons.verified_user_outlined,
                                bg: pal.primary,
                                hoverBg: pal.primaryContainer,
                                fg: Colors.white,
                                fontSize: 13.5,
                                shadow: true,
                                expand: true,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 14),
                                onTap: _loading ? null : _submit,
                              ),
                              if (AppConfig.canUseGuestPreview &&
                                  widget.onGuestPreview != null) ...[
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: pal.outlineVariant
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        'ATAU KHUSUS DEMO',
                                        style: Txt.sans(
                                          10,
                                          weight: FontWeight.w700,
                                          color: pal.outline,
                                          spacing: 0.9,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: pal.outlineVariant
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                PillButton(
                                  label: 'Lihat Simulasi Panel Admin (Tamu)',
                                  icon: Icons.visibility_outlined,
                                  bg: pal.surfaceLow,
                                  hoverBg: pal.surfaceContainer,
                                  fg: pal.primary,
                                  border: pal.outlineVariant,
                                  fontSize: 12.5,
                                  expand: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  onTap: widget.onGuestPreview,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Mode tamu hanya mengubah tampilan di browser Anda sendiri dan tidak mengubah database server.',
                                  textAlign: TextAlign.center,
                                  style: Txt.sans(
                                    11.5,
                                    color: pal.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoginInput extends StatelessWidget {
  const _LoginInput({
    required this.controller,
    required this.pal,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.onSubmitted,
    this.suffix,
  });

  final TextEditingController controller;
  final StorePalette pal;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: pal.surfaceLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        onSubmitted: onSubmitted,
        style: Txt.sans(13.5, color: pal.primary, weight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 18, color: pal.onSurfaceVariant),
          suffixIcon: suffix,
          hintText: hint,
          hintStyle: Txt.sans(13, color: pal.outline),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}
