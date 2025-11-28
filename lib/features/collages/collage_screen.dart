import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/collages/collage_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import '../../common_widget/custom_alert_dialog.dart';
import '../../common_widget/custom_button.dart';
import '../../common_widget/custom_search.dart';
import '../../util/check_login.dart';
import '../../util/format_function.dart';
import 'add_collage.dart';
import 'collages_bloc/collages_bloc.dart';

class CollageScreen extends StatefulWidget {
  const CollageScreen({super.key});

  @override
  State<CollageScreen> createState() => _CollageScreenState();
}

class _CollageScreenState extends State<CollageScreen> {
  final CollagesBloc _collagesBloc = CollagesBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _collages = [];

  @override
  void initState() {
    checkLogin(context);
    getCollages();
    super.initState();
  }

  void getCollages() {
    _collagesBloc.add(GetAllCollagesEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _collagesBloc,
      child: BlocConsumer<CollagesBloc, CollagesState>(
        listener: (context, state) {
          if (state is CollagesFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getCollages();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is CollagesGetSuccessState) {
            _collages = state.collages;
            Logger().w(_collages);
            setState(() {});
          } else if (state is CollagesSuccessState) {
            getCollages();
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
                          'Collages',
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
                              getCollages();
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomButton(
                          inverse: true,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => BlocProvider.value(
                                value: _collagesBloc,
                                child: AddCollage(),
                              ),
                            );
                          },
                          label: 'Add Collage',
                          iconData: Icons.add,
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state is CollagesLoadingState)
                      const Center(child: CircularProgressIndicator())
                    else if (state is CollagesGetSuccessState && _collages.isEmpty)
                      const Center(child: Text('No collage found'))
                    else if (state is CollagesGetSuccessState && _collages.isNotEmpty)
                      SizedBox(
                        height: 500,
                        child: DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 600,
                          columns: const [
                            DataColumn2(label: Text('Collage Name'), size: ColumnSize.L),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('email')),
                            DataColumn(label: Text('Details'), numeric: true),
                          ],
                          rows: List.generate(
                            _collages.length,
                            (index) => DataRow(cells: [
                              DataCell(Text(
                                formatValue(_collages[index]['name']),
                              )),
                              DataCell(Text(formatValue(_collages[index]['phone']))),
                              DataCell(Text(formatValue(_collages[index]['email']))),
                              DataCell(Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BlocProvider.value(
                                          value: _collagesBloc,
                                          child: AddCollage(
                                            collageDetails: _collages[index],
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BlocProvider.value(
                                          value: _collagesBloc,
                                          child: CustomAlertDialog(
                                            title: 'Delete Collage',
                                            description: 'Are you sure you want to delete this collage?',
                                            secondaryButton: 'Cancel',
                                            onSecondaryPressed: () {
                                              Navigator.pop(context);
                                            },
                                            primaryButton: 'Delete',
                                            onPrimaryPressed: () {
                                              _collagesBloc.add(DeleteCollageEvent(collageId: _collages[index]['id']));
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  TextButton(
                                    child: const Text('View Details'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => CollageDetails(
                                          collage: _collages[index],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )),
                            ]),
                          ),
                        ),
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
