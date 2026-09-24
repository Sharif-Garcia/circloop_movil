import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  bool _mostrarContrasena = false;

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(authProvider.notifier)
        .iniciarSesion(
          _correoController.text.trim(),
          _contrasenaController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AsyncValue>(authProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.recycling,
                    size: AppSizes.iconXl,
                    color: AppColors.primary,
                  ),

                  const SizedBox(height: AppSizes.lg),

                  Text(
                    'CIRCLOOP',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: AppSizes.sm),

                  Text(
                    'Sistema de Devolución y Recompensa',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: AppSizes.xl),

                  TextFormField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.correo,
                    decoration: const InputDecoration(
                      labelText: 'Correo institucional',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),

                  const SizedBox(height: AppSizes.md),

                  TextFormField(
                    controller: _contrasenaController,
                    obscureText: !_mostrarContrasena,
                    validator: Validators.contrasena,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _mostrarContrasena = !_mostrarContrasena;
                          });
                        },
                        icon: Icon(
                          _mostrarContrasena
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.lg),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: authState.isLoading ? null : _iniciarSesion,
                      child: authState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Iniciar sesión'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
