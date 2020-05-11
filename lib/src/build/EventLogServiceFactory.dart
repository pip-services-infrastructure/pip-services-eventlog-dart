import '../persistence/EventLogMemoryPersistence.dart';
import '../persistence/EventLogFilePersistence.dart';
import '../persistence/EventLogMongoDbPersistence.dart';
import '../logic/EventLogController.dart';
import '../services/version1/EventLogHttpServiceV1.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

class EventLogServiceFactory extends Factory
{
	//static final Descriptor = Descriptor('pip-services-eventlog', 'factory', 'service', 'default', '1.0');
	static final MemoryPersistenceDescriptor = Descriptor('pip-services-eventlog', 'persistence', 'memory', '*', '1.0');
	static final FilePersistenceDescriptor = Descriptor('pip-services-eventlog', 'persistence', 'file', '*', '1.0');
	static final MongoDbPersistenceDescriptor = Descriptor('pip-services-eventlog', 'persistence', 'mongodb', '*', '1.0');
	static final ControllerDescriptor = Descriptor('pip-services-eventlog', 'controller', 'default', '*', '1.0');
	static final HttpServiceDescriptor = Descriptor('pip-services-eventlog', 'service', 'http', '*', '1.0');

	EventLogServiceFactory()
		: super()
	{
		registerAsType(EventLogServiceFactory.MemoryPersistenceDescriptor, EventLogMemoryPersistence);
		registerAsType(EventLogServiceFactory.FilePersistenceDescriptor, EventLogFilePersistence);
		registerAsType(EventLogServiceFactory.MongoDbPersistenceDescriptor, EventLogMongoDbPersistence);
		registerAsType(EventLogServiceFactory.ControllerDescriptor, EventLogController);
		registerAsType(EventLogServiceFactory.HttpServiceDescriptor, EventLogHttpServiceV1);
	}
}
