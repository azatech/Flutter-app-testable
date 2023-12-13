extension DateUtils on DateTime {
  DateTime get pickerStartDate => DateTime(year - 5, 1, 1);
  DateTime get pickerEndDate => DateTime(year + 5, 12, 31);
}

