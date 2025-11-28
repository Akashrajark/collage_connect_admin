import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/student/student_detail_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_search.dart';
import '../../util/check_login.dart';
import '../../util/format_function.dart';
import 'students_bloc/students_bloc.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final StudentsBloc _studentsBloc = StudentsBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _students = [];

  @override
  void initState() {
    checkLogin(context);
    getStudents();
    super.initState();
  }

  void getStudents() {
    _studentsBloc.add(GetAllStudentsEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _studentsBloc,
      child: BlocConsumer<StudentsBloc, StudentsState>(
        listener: (context, state) {
          if (state is StudentsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getStudents();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is StudentsGetSuccessState) {
            _students = state.students;
            Logger().w(_students);
            setState(() {});
          } else if (state is StudentsSuccessState) {
            getStudents();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Students',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 300,
                          child: CustomSearch(
                            onSearch: (p0) {
                              params['query'] = p0;
                              getStudents();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state is StudentsLoadingState)
                      const Center(child: CircularProgressIndicator())
                    else if (state is StudentsGetSuccessState && _students.isEmpty)
                      const Center(child: Text('No students found'))
                    else if (state is StudentsGetSuccessState && _students.isNotEmpty)
                      SizedBox(
                        height: 500,
                        child: DataTable2(
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            minWidth: 600,
                            columns: const [
                              DataColumn2(label: Text('User Id'), size: ColumnSize.L),
                              DataColumn(label: Text('Student name')),
                              DataColumn(label: Text('Reg. No.')),
                              DataColumn(label: Text('Details'), numeric: true),
                            ],
                            rows: List.generate(
                              _students.length,
                              (index) => DataRow(cells: [
                                DataCell(Text(
                                  formatValue(_students[index]['id']),
                                )),
                                DataCell(Text(formatValue(_students[index]['name']))),
                                DataCell(Text(formatValue(_students[index]['reg_no']))),
                                DataCell(Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      child: const Text('View Details'),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => StudentDetailDialog(
                                                  student: _students[index],
                                                ));
                                      },
                                    ),
                                  ],
                                )),
                              ]),
                            )),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
