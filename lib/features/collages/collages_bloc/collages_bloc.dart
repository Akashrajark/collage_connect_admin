import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'collages_event.dart';
part 'collages_state.dart';

class CollagesBloc extends Bloc<CollagesEvent, CollagesState> {
  CollagesBloc() : super(CollagesInitialState()) {
    on<CollagesEvent>((event, emit) async {
      try {
        emit(CollagesLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;

        SupabaseQueryBuilder table = Supabase.instance.client.from('collages');

        if (event is GetAllCollagesEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query = table.select('*');

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> collages = await query.order('name', ascending: true);

          emit(CollagesGetSuccessState(collages: collages));
        } else if (event is AddCollageEvent) {
          final response = await supabaseClient.auth.admin.createUser(
            AdminUserAttributes(
              email: event.collageDetails['email'],
              password: event.collageDetails['password'],
              emailConfirm: true,
              appMetadata: {"role": "collage"},
            ),
          );
          event.collageDetails['user_id'] = response.user!.id;
          event.collageDetails.remove('password');

          event.collageDetails['user_id'] = response.user?.id;
          event.collageDetails['image_url'] = await uploadFile(
            'collages/image',
            event.collageDetails['image'],
            event.collageDetails['image_name'],
          );
          event.collageDetails.remove('image');
          event.collageDetails.remove('image_name');

          await table.insert(event.collageDetails);

          emit(CollagesSuccessState());
        } else if (event is EditCollageEvent) {
          event.collageDetails.remove('email');
          event.collageDetails.remove('password');
          if (event.collageDetails['image'] != null) {
            event.collageDetails['image_url'] = await uploadFile(
              'collage/image',
              event.collageDetails['image'],
              event.collageDetails['image_name'],
            );
            event.collageDetails.remove('image');
            event.collageDetails.remove('image_name');
          }

          await table.update(event.collageDetails).eq('id', event.collageId);

          emit(CollagesSuccessState());
        } else if (event is DeleteCollageEvent) {
          await table.delete().eq('id', event.collageId);
          emit(CollagesSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(CollagesFailureState());
      }
    });
  }
}
