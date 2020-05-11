import 'package:pip_services3_commons/pip_services3_commons.dart';

class SystemEventV1Schema extends ObjectSchema
{
	SystemEventV1Schema()
	{
		withRequiredProperty('id', TypeCode.String);
		withRequiredProperty('time', TypeCode.DateTime);
		withRequiredProperty('correlation_id', TypeCode.String);
		withRequiredProperty('source', TypeCode.String);
		withRequiredProperty('type', TypeCode.String);
		withRequiredProperty('severity', TypeCode.Long);
		withRequiredProperty('message', TypeCode.String);
		withRequiredProperty('details', TypeCode.Map);
	}
}
