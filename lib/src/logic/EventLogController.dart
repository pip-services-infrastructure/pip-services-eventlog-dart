import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../data/version1/data.dart';
import '../persistence/IEventLogPersistence.dart';
import 'EventLogCommandSet.dart';
import 'IEventLogController.dart';

class EventLogController implements IEventLogController, IConfigurable, IReferenceable, ICommandable
{
	IEventLogPersistence _persistence;
	EventLogCommandSet _commandSet;

	EventLogController()
	{
	}

	@override
	void configure(ConfigParams config)
	{
	}

	@override
	void setReferences(IReferences references)
	{
	    _persistence = references.getOneRequired<IEventLogPersistence >(
	        Descriptor('pip-services-eventlog', 'persistence', '*', '*', '1.0'));
	}

	@override
	CommandSet getCommandSet()
	{
	    _commandSet ??= EventLogCommandSet(this);
	    return _commandSet;
	}

	@override
	Future<DataPage<SystemEventV1>> getEvents(String correlationId, FilterParams filter, PagingParams paging) {
	    return _persistence.getPageByFilter(correlationId, filter, paging);
	}

	@override
	Future<SystemEventV1> logEvent(String correlationId, SystemEventV1 event) {
      event.severity = event.severity ?? EventLogSeverityV1.Informational;
      event.time = event.time ?? DateTime.now();

	    return _persistence.create(correlationId, event);
	}
}
