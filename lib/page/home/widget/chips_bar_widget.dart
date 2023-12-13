import 'package:drift_app_testble/page/home/cubit/home_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChipsBarWidget extends StatefulWidget {
  const ChipsBarWidget({super.key});

  @override
  State<ChipsBarWidget> createState() => _ChipsBarWidgetState();
}

class _ChipsBarWidgetState extends State<ChipsBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(builder: (context, state) {
      return SizedBox(
        height: kToolbarHeight,
        child: ListView(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
          scrollDirection: Axis.horizontal,
          children: [
            buildGroupChip(
              context,
              state.isFilteredByAll,
              'All',
              () => _updateFilter(FilterKind.all),
            ),
            const SizedBox(width: 8),
            buildGroupChip(
              context,
              state.isFilteredByCompleted,
              'Completed',
              () => _updateFilter(FilterKind.completed),
            ),
            const SizedBox(width: 8),
            buildGroupChip(
              context,
              state.isFilteredByIncomplete,
              'Incomplete',
              () => _updateFilter(FilterKind.incomplete),
            ),
          ],
        ),
      );
    });
  }

  void _updateFilter(FilterKind filter) {
    context.read<HomePageCubit>().updateFilter(
          filter: filter,
        );
  }

  Widget buildGroupChip(
    BuildContext context,
    bool checked,
    String label,
    Function() onSelect,
  ) {
    return InputChip(
      showCheckmark: checked,
      label: Text(label),
      selected: checked,
      onSelected: (_) => onSelect(),
      selectedColor: checked ? Theme.of(context).colorScheme.tertiary : null,
      labelStyle: checked
          ? TextStyle(color: Theme.of(context).colorScheme.onTertiary)
          : null,
      checkmarkColor: checked ? Theme.of(context).colorScheme.onTertiary : null,
    );
  }
}
