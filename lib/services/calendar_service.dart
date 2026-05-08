import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import '../screens/calendar/calendar_data.dart';

class CalendarService {
  CalendarService._();
  static final CalendarService instance = CalendarService._();

  final Dio _dio = DioClient.instance;

  Future<List<CourseModel>> fetchSeances({
    required DateTime from,
    required DateTime to,
  }) async {
    final fromStr = _fmt(from);
    final toStr = _fmt(to);

    final response = await _dio.get(
      '/seances?date=gte.$fromStr&date=lte.$toStr',
      queryParameters: {
        'select':
            'id,date,start_time,end_time,type,is_exam,matieres(name,code),users(first_name,last_name),salles(name)',
        'status': 'eq.publié',
        'order': 'date.asc,start_time.asc',
      },
    );

    final data = response.data as List<dynamic>;
    return data
        .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
