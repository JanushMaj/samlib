import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../data/repositories/app_user_repository.dart';
import '../../data/repositories/grafik_element_repository.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/grafik/impl/supply_run_element.dart';
import '../../domain/services/i_supply_repository.dart';
import '../auth/auth_cubit.dart';
import '../auth/screen/no_access_screen.dart';
import 'cubit/supply_run_planning_cubit.dart';
import 'cubit/supply_run_planning_state.dart';
import '../../shared/app_drawer.dart';
import '../../shared/responsive/responsive_layout.dart';
import '../../theme/app_tokens.dart';

class SupplyRunApprovalScreen extends StatelessWidget {
  const SupplyRunApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;
    if (user == null ||
        (user.role != UserRole.kierownik &&
            user.role != UserRole.kierownikProdukcji &&
            user.role != UserRole.admin)) {
      return const NoAccessScreen();
    }

    return BlocProvider(
      create: (_) => SupplyRunPlanningCubit(
        GetIt.I<ISupplyRepository>(),
        GetIt.I<GrafikElementRepository>(),
      ),
      child: const _SupplyRunApprovalView(),
    );
  }
}

class _SupplyRunApprovalView extends StatelessWidget {
  const _SupplyRunApprovalView();

  Stream<List<SupplyRunElement>> _openRunsStream(
      GrafikElementRepository repo) {
    final start = DateTime.now().subtract(const Duration(days: 30));
    final end = DateTime.now().add(const Duration(days: 30));
    return repo
        .getElementsWithinRange(
          start: start,
          end: end,
          types: ['SupplyRunElement'],
        )
        .map(
          (list) => list
              .whereType<SupplyRunElement>()
              .where(
                (e) => !e.closed && e.endDateTime.isBefore(DateTime.now()),
              )
              .toList(),
        );
  }

  String _format(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d.$m $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<GrafikElementRepository>();
    final userRepo = GetIt.I<AppUserRepository>();

    return BlocListener<SupplyRunPlanningCubit, SupplyRunPlanningState>(
      listener: (context, state) {
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trasa zatwierdzona')),
          );
        } else if (state.errorMsg != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Błąd: ${state.errorMsg}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: ResponsiveScaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Zatwierdź trasy zaopatrzenia'),
        ),
        body: StreamBuilder<List<SupplyRunElement>>(
          stream: _openRunsStream(repo),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Błąd danych\n${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final runs = snapshot.data!;
            if (runs.isEmpty) {
              return const Center(child: Text('Brak otwartych tras'));
            }
            return ListView.builder(
              itemCount: runs.length,
              itemBuilder: (context, index) {
                final run = runs[index];
                return FutureBuilder(
                  future: userRepo.getUser(run.addedByUserId),
                  builder: (context, AsyncSnapshot<AppUser?> userSnap) {
                    final author = userSnap.data?.fullName ?? run.addedByUserId;
                    return ListTile(
                      title: Text(
                        run.routeDescription.isEmpty
                            ? '(brak opisu)'
                            : run.routeDescription,
                      ),
                      subtitle: Text(
                        '$author\n${_format(run.startDateTime)} - ${_format(run.endDateTime)}',
                      ),
                      isThreeLine: true,
                      trailing: TextButton(
                        onPressed: () {
                          final id = repo.generateNewTaskId();
                          context
                              .read<SupplyRunPlanningCubit>()
                              .closeSupplyRun(run, orderId: id);
                        },
                        child: const Text('Zatwierdź'),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
