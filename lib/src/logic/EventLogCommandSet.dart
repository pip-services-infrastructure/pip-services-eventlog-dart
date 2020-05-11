import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../src/data/version1/data.dart';
import 'logic.dart';

class EventLogCommandSet extends CommandSet
{
	IEventLogController _controller;

	EventLogCommandSet(IEventLogController controller)
	{
		_controller = controller;

		addCommand(_makeGetEventsCommand());
		addCommand(_makeLogEventCommand());
	}

	ICommand _makeGetEventsCommand()
	{
	    return Command(
	        'get_events',
	        ObjectSchema(true)
	            .withOptionalProperty('filter', FilterParamsSchema())
	            .withOptionalProperty('paging', PagingParamsSchema()),
	        (String correlationId, Parameters args)
	        {
	            var filter = FilterParams.fromValue(args.get('filter'));
	            var paging = PagingParams.fromValue(args.get('paging'));
	            return _controller.getEvents(correlationId, filter, paging);
	        });
	}

	ICommand _makeLogEventCommand()
	{
	    return Command(
	        'log_event',
	        new ObjectSchema(true)
            .withOptionalProperty('eventlog', new SystemEventV1Schema())
            .withOptionalProperty('event', new SystemEventV1Schema()),
	        (String correlationId, Parameters args)
	        {
            SystemEventV1 event = SystemEventV1();
        			event.fromJson(args.get("event"));
	            return _controller.logEvent(correlationId, event);
	        });
	}
}
