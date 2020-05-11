import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

class EventLogHttpServiceV1 extends CommandableHttpService
{
	EventLogHttpServiceV1()
		: super('v1/eventlog')
	{
		dependencyResolver.put('controller', Descriptor('pip-services-eventlog', 'controller', 'default', '*', '1.0'));
	}
}
