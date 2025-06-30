import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class VehicleForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;

  const VehicleForm({super.key, required this.onSubmit});

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final TextEditingController colorController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController nrRejestracyjnyController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController sittingCapacityController = TextEditingController();
  final TextEditingController cargoDimensionsController = TextEditingController();
  final TextEditingController maxLoadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Większy padding – zachowujemy 16.0, bo tak chciałeś w starym kodzie
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: colorController,
            decoration: const InputDecoration(
              labelText: AppStrings.color,
            ),
          ),
          TextField(
            controller: brandController,
            decoration: const InputDecoration(
              labelText: AppStrings.brand,
            ),
          ),
          TextField(
            controller: modelController,
            decoration: const InputDecoration(
              labelText: AppStrings.model,
            ),
          ),
          TextField(
            controller: nrRejestracyjnyController,
            decoration: const InputDecoration(
              labelText: AppStrings.registrationNumber,
            ),
          ),
          TextField(
            controller: typeController,
            decoration: const InputDecoration(
              labelText: AppStrings.vehicleType,
            ),
          ),
          TextField(
            controller: sittingCapacityController,
            decoration: const InputDecoration(
              labelText: AppStrings.sittingCapacity,
            ),
          ),
          TextField(
            controller: cargoDimensionsController,
            decoration: const InputDecoration(
              labelText: AppStrings.cargoDimensions,
            ),
          ),
          TextField(
            controller: maxLoadController,
            decoration: const InputDecoration(
              labelText: AppStrings.maxLoad,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onSubmit({
                'color': colorController.text,
                'brand': brandController.text,
                'model': modelController.text,
                'nrRejestracyjny': nrRejestracyjnyController.text,
                'type': typeController.text,
                'sittingCapacity': sittingCapacityController.text,
                'cargoDimensions': cargoDimensionsController.text,
                'maxLoad': maxLoadController.text,
              });
            },
            child: const Text(AppStrings.saveVehicle),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    colorController.dispose();
    brandController.dispose();
    modelController.dispose();
    nrRejestracyjnyController.dispose();
    typeController.dispose();
    sittingCapacityController.dispose();
    cargoDimensionsController.dispose();
    maxLoadController.dispose();
    super.dispose();
  }
}
