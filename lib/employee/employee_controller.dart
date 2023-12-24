import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'employee_model.dart';

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
      // Handle any error
      debugPrint("Exception occurred !!");
    }
  }
}
