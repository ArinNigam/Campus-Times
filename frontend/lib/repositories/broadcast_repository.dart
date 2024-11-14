import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:campus_times/models/broadcast_schema.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final broadcastRepositoryProvider =
    Provider<BroadcastRepository>((_) => BroadcastRepository());

class BroadcastRepository {
  final _client = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BACKEND_DOMAIN']!,
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );
  final Logger _logger = Logger();

  Future<List<Broadcast>> fetchBroadcasts() async {
    try {
      final response = await _client.get('/broadcasts');
      List<Broadcast> broadcasts =
          (response.data as List).map((e) => Broadcast.fromJson(e)).toList();
      return broadcasts;
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }
}
