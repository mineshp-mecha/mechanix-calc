import 'package:equatable/equatable.dart';

class HistoryItem extends Equatable {
  final String expression;
  final String result;

  const HistoryItem({required this.expression, required this.result});

  @override
  List<Object> get props => [expression, result];
}

class CalculatorState extends Equatable {
  final String expression;
  final String result;
  final List<HistoryItem> history;

  const CalculatorState({
    this.expression = '',
    this.result = '0',
    this.history = const [],
  });

  CalculatorState copyWith({
    String? expression,
    String? result,
    List<HistoryItem>? history,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      history: history ?? this.history,
    );
  }

  @override
  List<Object> get props => [expression, result, history];
}
