import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/repositories/service_request_repository.dart';
import '../../../domain/models/grafik/impl/service_request_element.dart';
import '../../auth/auth_cubit.dart';
import '../../auth/screen/no_access_screen.dart';
import '../../../shared/app_drawer.dart';
import '../../../shared/responsive/responsive_layout.dart';
import 'service_request_details_screen.dart';

class ServiceRequestListScreen extends StatelessWidget {
  const ServiceRequestListScreen({super.key});

  Stream<List<ServiceRequestElement>> _openRequests(ServiceRequestRepository repo) {
    return repo
        .watchServiceRequests()
        .map((list) => list.where((r) => !r.closed).toList());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;
    final hasPermission =
        user?.effectivePermissions['canViewServiceTasks'] ?? false;
    if (user == null || !hasPermission) {
      return const NoAccessScreen();
    }

    final repo = GetIt.I<ServiceRequestRepository>();

    return ResponsiveScaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Zlecenia serwisowe'),
      ),
      body: StreamBuilder<List<ServiceRequestElement>>(
        stream: _openRequests(repo),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('B\u0142\u0105d danych\n${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final requests = snapshot.data!;
          if (requests.isEmpty) {
            return const Center(child: Text('Brak otwartych zg\u0142osze\u0144'));
          }
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return ListTile(
                title: Text(req.orderNumber.isEmpty
                    ? '(brak numeru)'
                    : req.orderNumber),
                subtitle: Text(req.description),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ServiceRequestDetailsScreen(request: req),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

