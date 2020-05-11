import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../data/version1/data.dart';

abstract class IEventLogPersistence
{
	Future<DataPage<SystemEventV1>> getPageByFilter(String correlationId, FilterParams filter, PagingParams paging);
	Future<SystemEventV1> getOneById(String correlationId, String id);
	Future<SystemEventV1> create(String correlationId, SystemEventV1 systemEvent);
	Future<SystemEventV1> update(String correlationId, SystemEventV1 systemEvent);
	Future<SystemEventV1> deleteById(String correlationId, String id);
}
