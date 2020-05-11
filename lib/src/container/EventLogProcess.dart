import '../build/EventLogServiceFactory.dart';
import 'package:pip_services3_container/pip_services3_container.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

class EventLogProcess extends ProcessContainer
{
	EventLogProcess()
		: super('eventlog', 'System event logging microservice')
	{
		factories.add(DefaultRpcFactory());
		factories.add(EventLogServiceFactory());
	}
}
