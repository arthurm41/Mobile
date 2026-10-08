import 'package:flutter/material.dart';

Future<bool> confirmarExclusao(BuildContext context, String nome) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Excluir local?'),
      content: Text('Deseja remover "$nome"? Esta ação não poderá ser desfeita.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => Navigator.pop(context, true),
          label: const Text('Excluir'),
        ),
      ],
    ),
  );

  return result ?? false;
}
