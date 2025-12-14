import 'package:calculator/core/constants.dart';
import 'package:calculator/features/calculator/domain/services/equation_controller_service.dart';
import 'package:calculator/features/calculator/domain/services/equation_provider.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String char;
  final VoidCallback? onPress;
  final Icon? icon;

  const Button({super.key, required this.char, this.onPress, this.icon});

  @override
  Widget build(BuildContext context) {
    final TextEditingController equation = _getEquationController(context);

    final EquationControllerService equationControllerService =
        EquationControllerService();

    return GestureDetector(
      onLongPressStart: icon != null
          ? (_) => equationControllerService.startDeleting(equation)
          : (_) => equationControllerService.startInserting(equation, char),
      onLongPressEnd: icon != null
          ? (_) => equationControllerService.stopDeleting()
          : (_) => equationControllerService.stopInserting(),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            double.tryParse(char) != null
                ? GREY
                : char == 'C'
                ? Colors.red
                : (icon != null || char == '=' || char == '.')
                ? BLUE
                : GREEN,
          ),
        ),
        onPressed:
            onPress ??
            () => icon == null
                ? equationControllerService.insertEquation(equation, char)
                : equationControllerService.deleteAtCursor(equation),
        child:
            icon ??
            Text(
              char,
              style: TextStyle(
                fontSize: 30,
                color: (char == '=' || char == '.') ? WHITE : WHITE,
                fontWeight: FontWeight.w900,
              ),
            ),
      ),
    );
  }

  TextEditingController _getEquationController(BuildContext context) =>
      EquationProvider.of(context)?.equation ?? TextEditingController();
}
