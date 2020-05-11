import 'package:pip_services3_commons/pip_services3_commons.dart';

class SystemEventV1 implements IStringIdentifiable
{
  @override
	String id;
	DateTime time;
	String correlation_id;
	String source;
	String type;
	int severity;
	String message;
	StringValueMap details;

	SystemEventV1();

	SystemEventV1.from(this.id, this.time, this.correlation_id, this.source, this.type, this.severity, this.message, this.details);

	void fromJson(Map<String, dynamic> json)
	{
		id = json['id'];
		time = DateTime.tryParse(json['time']);
		correlation_id = json['correlation_id'];
		source = json['source'];
		type = json['type'];
		severity = json['severity'];
		message = json['message'];
		details = StringValueMap.fromJson(json['details']);
	}

	Map<String, dynamic> toJson()
	{
		return <String, dynamic>
		{
			'id': id,
			'time': time.toIso8601String(),
			'correlation_id': correlation_id,
			'source': source,
			'type': type,
			'severity': severity,
			'message': message,
			'details': details,
		};
	}

}
