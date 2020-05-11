import 'package:pip_services_eventlog/pip_services_eventlog.dart';

void main(List<String> args)
{
	try
	{
    var proc = EventLogProcess();
		proc.configPath = './config/config.yml';
		proc.run(args);
	}
	catch (ex)
	{
		print(ex);
	}
}
