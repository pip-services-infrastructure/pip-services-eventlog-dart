import 'dart:async';
import 'package:pip_services3_mongodb/pip_services3_mongodb.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_eventlog/pip_services_eventlog.dart';

class EventLogMongoDbPersistence extends IdentifiableMongoDbPersistence<SystemEventV1, String> implements IEventLogPersistence
{
	EventLogMongoDbPersistence()
		: super('system_events')
	{
		maxPageSize = 1000;
	}

	@override
	Future<DataPage<SystemEventV1>> getPageByFilter(String correlationId, FilterParams filter, PagingParams paging) async 
	{
		return super.getPageByFilterEx(correlationId, composeFilter(filter), paging, null);
	}

	dynamic composeFilter(FilterParams filter)
	{
      filter = filter ?? FilterParams();

            var criteria = [];

        var search = filter.getAsNullableString('search');
        if (search != null) {
            var searchRegex = new RegExp(search, caseSensitive: false);
            var searchCriteria = [];
            searchCriteria.add({ 'source': { r'$regex': searchRegex } });
            searchCriteria.add({ 'type': { r'$regex': searchRegex } });
            searchCriteria.add({ 'message': { r'$regex': searchRegex } });
            criteria.add({ r'$or': searchCriteria });
        }

        var id = filter.getAsNullableString('id');
        if (id != null)
            criteria.add({ '_id': id });

        var correlationId = filter.getAsNullableString('correlation_id');
        if (correlationId != null)
            criteria.add({ 'correlation_id': correlationId });

        var source = filter.getAsNullableString('source');
        if (source != null)
            criteria.add({ 'source': source });

        var type = filter.getAsNullableString('type');
        if (type != null)
            criteria.add({ 'type': type });

        var minSeverity = filter.getAsNullableInteger('min_severity');
        if (minSeverity != null)
            criteria.add({ 'severity': { r'$gte': minSeverity } });

        var fromTime = filter.getAsNullableDateTime('from_time');
        if (fromTime != null)
            criteria.add({ 'time': { r'$gte': fromTime } });

        var toTime = filter.getAsNullableDateTime('to_time');
        if (toTime != null)
            criteria.add({ 'time': { r'$lt': toTime } });

		return criteria.isNotEmpty ? {r'$and': criteria} : null;
	}
}
