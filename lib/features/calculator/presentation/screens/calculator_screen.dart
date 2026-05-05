import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/calculator_bloc.dart';
import '../../bloc/calculator_event.dart';
import '../../bloc/calculator_state.dart';
import '../widgets/calculator_button.dart';
import '../widgets/display_panel.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final bloc = context.read<CalculatorBloc>();
      final key = event.logicalKey;

      if (key == LogicalKeyboardKey.digit0 || key == LogicalKeyboardKey.numpad0)
        bloc.add(const NumberPressed('0'));
      else if (key == LogicalKeyboardKey.digit1 ||
          key == LogicalKeyboardKey.numpad1)
        bloc.add(const NumberPressed('1'));
      else if (key == LogicalKeyboardKey.digit2 ||
          key == LogicalKeyboardKey.numpad2)
        bloc.add(const NumberPressed('2'));
      else if (key == LogicalKeyboardKey.digit3 ||
          key == LogicalKeyboardKey.numpad3)
        bloc.add(const NumberPressed('3'));
      else if (key == LogicalKeyboardKey.digit4 ||
          key == LogicalKeyboardKey.numpad4)
        bloc.add(const NumberPressed('4'));
      else if (key == LogicalKeyboardKey.digit5 ||
          key == LogicalKeyboardKey.numpad5)
        bloc.add(const NumberPressed('5'));
      else if (key == LogicalKeyboardKey.digit6 ||
          key == LogicalKeyboardKey.numpad6)
        bloc.add(const NumberPressed('6'));
      else if (key == LogicalKeyboardKey.digit7 ||
          key == LogicalKeyboardKey.numpad7)
        bloc.add(const NumberPressed('7'));
      else if (key == LogicalKeyboardKey.digit8 ||
          key == LogicalKeyboardKey.numpad8)
        bloc.add(const NumberPressed('8'));
      else if (key == LogicalKeyboardKey.digit9 ||
          key == LogicalKeyboardKey.numpad9)
        bloc.add(const NumberPressed('9'));
      else if (key == LogicalKeyboardKey.period ||
          key == LogicalKeyboardKey.numpadDecimal)
        bloc.add(const NumberPressed('.'));
      else if (key == LogicalKeyboardKey.add ||
          key == LogicalKeyboardKey.numpadAdd ||
          key == LogicalKeyboardKey.equal &&
              HardwareKeyboard.instance.isShiftPressed)
        bloc.add(const OperatorPressed('+'));
      else if (key == LogicalKeyboardKey.minus ||
          key == LogicalKeyboardKey.numpadSubtract)
        bloc.add(const OperatorPressed('-'));
      else if (key == LogicalKeyboardKey.asterisk ||
          key == LogicalKeyboardKey.numpadMultiply)
        bloc.add(const OperatorPressed('×'));
      else if (key == LogicalKeyboardKey.slash ||
          key == LogicalKeyboardKey.numpadDivide)
        bloc.add(const OperatorPressed('÷'));
      else if (key == LogicalKeyboardKey.percent)
        bloc.add(PercentagePressed());
      else if (key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.numpadEnter)
        bloc.add(CalculateResult());
      else if (key == LogicalKeyboardKey.backspace)
        bloc.add(DeletePressed());
      else if (key == LogicalKeyboardKey.escape)
        bloc.add(ClearPressed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<CalculatorBloc, CalculatorState>(
                  builder: (context, state) {
                    return DisplayPanel(
                      expression: state.expression,
                      result: state.result,
                      history: state.history,
                    );
                  },
                ),
              ),
              Expanded(child: _buildButtons(context)),
              // _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildButtons(BuildContext context) {
  final List<List<String>> buttons = [
    ['AC', '+/-', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['⌫', '0', '.', '='],
  ];

  return Container(
    color: Colors.black,
    child: Column(
      children: buttons.map((row) {
        return Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Container(
            width: 540,
            height: 52,
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
            child: Row(
              children: row.asMap().entries.map((entry) {
                final index = entry.key;
                final text = entry.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : 4),
                    child: _buildButton(context, text),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

Widget _buildButton(BuildContext context, String text) {
  final bloc = context.read<CalculatorBloc>();
  Color color = const Color(0xFF1A1A1A);
  const operators = ['÷', '×', '-', '+', '='];
  const actions = ['AC', '+/-', '%'];

  if (operators.contains(text) || actions.contains(text)) {
    color = const Color(0xFF2C2C2C);
  }

  return CalculatorButton(
    text: text,
    icon: text == '⌫' ? Icons.backspace_outlined : null,
    color: color,
    onTap: () {
      if (text == 'AC') {
        bloc.add(ClearPressed());
      } else if (text == '⌫') {
        bloc.add(DeletePressed());
      } else if (text == '=') {
        bloc.add(CalculateResult());
      } else if (text == '+/-') {
        bloc.add(ToggleSignPressed());
      } else if (text == '%') {
        bloc.add(PercentagePressed());
      } else if (operators.contains(text)) {
        bloc.add(OperatorPressed(text));
      } else {
        bloc.add(NumberPressed(text));
      }
    },
  );
}

Widget _buildBottomNav() {
  return Container(
    height: 60,
    decoration: const BoxDecoration(
      color: Colors.black,
      border: Border(top: BorderSide(color: Color(0xFF1A1A1A), width: 1)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.grey),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.calculate, color: Colors.white, size: 20),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, color: Colors.grey),
        ),
      ],
    ),
  );
}
