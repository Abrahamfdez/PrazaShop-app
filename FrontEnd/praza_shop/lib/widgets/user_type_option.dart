import 'package:flutter/material.dart';

/// Widget genérico para representar una opción de tipo de usuario (Cliente/Negocio).
class UserTypeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const UserTypeOption({
    Key? key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.color = const Color(0xFF10A75A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = color.withOpacity(0.08);
    final borderColor = color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? borderColor : Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? borderColor : Colors.grey),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: selected ? borderColor : Colors.grey)),
          ],
        ),
      ),
    );
  }
}
