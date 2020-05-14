import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';

import '../data/version1/data.dart';
import 'IEventLogPersistence.dart';

class EventLogMemoryPersistence
    extends IdentifiableMemoryPersistence<SystemEventV1, String>
    implements IEventLogPersistence {
  EventLogMemoryPersistence() : super() {
    maxPageSize = 1000;
  }

  //TODO: Add comments and document code

  @override
  Future<DataPage<SystemEventV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging) async {
    return super.getPageByFilterEx(
        correlationId, this.composeFilter(filter), paging, null);
  }

  Function composeFilter(FilterParams filter) {
    filter = filter ?? FilterParams();

    var search = filter.getAsNullableString('search');
    var id = filter.getAsNullableString('id');
    var correlationId = filter.getAsNullableString('correlation_id');
    var source = filter.getAsNullableString('source');
    var type = filter.getAsNullableString('type');
    var minSeverity = filter.getAsNullableInteger('min_severity');
    var fromTime = filter.getAsNullableDateTime('from_time');
    var toTime = filter.getAsNullableDateTime('to_time');

    return (SystemEventV1 item) {
      if (search != null && !this.matchSearch(item, search)) return false;
      if (id != null && id != item.id) return false;
      if (correlationId != null && correlationId != item.correlation_id)
        return false;
      if (source != null && source != item.source) return false;
      if (type != null && type != item.type) return false;
      if (minSeverity != null && item.severity < minSeverity) return false;
      if (fromTime != null && item.time.isBefore(fromTime)) return false;
      if (toTime != null && (item.time == toTime || item.time.isAfter(toTime))) return false;
      return true;
    };
  }

  bool matchString(String value, String search) {
    if (value == null && search == null) return true;
    if (value == null || search == null) return false;
    return value.toLowerCase().indexOf(search) >= 0;
  }

  bool matchSearch(SystemEventV1 item, String search) {
    search = search.toLowerCase();
    if (this.matchString(item.source, search)) return true;
    if (this.matchString(item.message, search)) return true;
    // if (this.matchString(item.severity.toString(), search))
    //     return true;
    if (this.matchString(item.type, search)) return true;
    return false;
  }
}
