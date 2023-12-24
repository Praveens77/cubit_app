import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'employee_controller.dart';
import 'employee_detail.dart'; // New employee detail screen
import 'employee_model.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeCubit()..fetchEmployees(),
      child: Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: const Text(
            'CUBIT EMPLOYEES',
            style: TextStyle(
              color: Color.fromARGB(255, 218, 253, 255),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
        ),
        body: const EmployeeList(),
      ),
    );
  }
}

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, List<Employee>>(
      builder: (context, employees) {
        if (employees.isEmpty) {
          // State: loading data
          return const ShimmerLoading();
        } else {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return EmployeeTile(employee: employee);
              },
            ),
          );
        }
      },
    );
  }
}

class EmployeeTile extends StatelessWidget {
  final Employee employee;

  const EmployeeTile({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeDetailScreen(employee: employee),
            ),
          );
        },
        child: Card(
          color: const Color.fromARGB(255, 218, 253, 255),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.person,
                color: Color.fromARGB(255, 218, 253, 255),
              ),
            ),
            title: Text(
              employee.name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'View Details',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black54,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
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
          return Card(
            color: Colors.black,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
              title: Container(
                height: 20,
                width: 200,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 15,
                width: 100,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
