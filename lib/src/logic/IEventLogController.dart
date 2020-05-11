import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../src/data/version1/data.dart';

abstract class IEventLogController
{
  Future<DataPage<SystemEventV1>> getEvents(String correlationId, FilterParams filter, PagingParams paging);
	Future<SystemEventV1> logEvent(String correlationId, SystemEventV1 event);
}
