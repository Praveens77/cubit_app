import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class Employee {
  final int id;
  final String name;
  final int salary;
  final int age;

  Employee({
    required this.id,
    required this.name,
    required this.salary,
    required this.age,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['employee_name'],
      salary: json['employee_salary'],
      age: json['employee_age'],
    );
  }
}

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeCubit()..fetchEmployees(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Employee Data'),
        ),
        body: const EmployeeList(),
      ),
    );
  }
}

class EmployeeCubit extends Cubit<List<Employee>> {
  EmployeeCubit() : super([]);

  void fetchEmployees() async {
    final response = await http
        .get(Uri.parse('https://dummy.restapiexample.com/api/v1/employees'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      final List<Employee> employees =
          data.map((e) => Employee.fromJson(e)).toList();
      emit(employees);
    } else {
      // Handle error
    }
  }
}

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, List<Employee>>(
      builder: (context, employees) {
        if (employees.isEmpty) {
          return const ShimmerLoading(); // Shimmer effect while loading data
        } else {
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return ListTile(
                title: Text(employee.name),
                subtitle:
                    Text('Salary: ${employee.salary}, Age: ${employee.age}'),
              );
            },
          );
        }
      },
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5, // Placeholder for loading effect
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              height: 20,
              width: 200,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
