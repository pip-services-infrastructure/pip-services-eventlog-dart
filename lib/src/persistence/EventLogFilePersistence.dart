import 'package:pip_services3_data/pip_services3_data.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_eventlog/pip_services_eventlog.dart';

class EventLogFilePersistence extends EventLogMemoryPersistence
{
	JsonFilePersister<SystemEventV1> persister;

	EventLogFilePersistence([String path])
		: super()
	{
		persister = JsonFilePersister<SystemEventV1>(path);
		loader = persister;
		saver = persister;
	}

	@override
	void configure(ConfigParams config)
	{
		super.configure(config);
		persister.configure(config);
	}
}
