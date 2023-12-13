import 'package:drift/drift.dart';

/// Example
/// final boolValue = EmployeeCompanion(true.drift ....);
///
extension DriftCompanion<T> on Object {
  Value drift<T>() => Value(this);
}
