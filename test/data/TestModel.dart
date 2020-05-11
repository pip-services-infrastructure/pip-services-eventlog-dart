import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_eventlog/pip_services_eventlog.dart';

class TestModel
{
	static SystemEventV1 createSystemEvent()
	{
		var systemEvent = SystemEventV1();
		systemEvent.fromJson(
		{
			'id' : IdGenerator.nextLong(),
			'time' : RandomDateTime.nextDateTime(new DateTime(2010, 1, 1), DateTime.now()).toIso8601String(),
			'correlation_id' : IdGenerator.nextLong(),
			'source' : IdGenerator.nextLong(),
			'type' : RandomArray.pick([ EventLogTypeV1.Failure, EventLogTypeV1.Other, EventLogTypeV1.Restart, 
        EventLogTypeV1.Transaction, EventLogTypeV1.Warning ]),
			'severity' : RandomArray.pick([ EventLogSeverityV1.Critical, EventLogSeverityV1.Important, EventLogSeverityV1.Informational ]),
			'message' : RandomText.text(10, 1000),
			'details' : StringValueMap(),
		}
		);
		return systemEvent;
	}

	static void assertEqual(SystemEventV1 expected, SystemEventV1 actual)
	{
		expect(expected, isNotNull);
		expect(actual, isNotNull);
		expect(actual.id, expected.id);
		expect(actual.time, expected.time);
		expect(actual.correlation_id, expected.correlation_id);
		expect(actual.source, expected.source);
		expect(actual.type, expected.type);
		expect(actual.severity, expected.severity);
		expect(actual.message, expected.message);
		expect(actual.details, expected.details);
	}

}
