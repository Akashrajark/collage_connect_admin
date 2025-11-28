part of 'collages_bloc.dart';

@immutable
sealed class CollagesEvent {}

class GetAllCollagesEvent extends CollagesEvent {
  final Map<String, dynamic> params;

  GetAllCollagesEvent({required this.params});
}

class AddCollageEvent extends CollagesEvent {
  final Map<String, dynamic> collageDetails;

  AddCollageEvent({required this.collageDetails});
}

class EditCollageEvent extends CollagesEvent {
  final Map<String, dynamic> collageDetails;
  final int collageId;

  EditCollageEvent({
    required this.collageDetails,
    required this.collageId,
  });
}

class DeleteCollageEvent extends CollagesEvent {
  final int collageId;

  DeleteCollageEvent({required this.collageId});
}
