# EventLog Microservice

This is a system event logging microservice from Pip.Services library. 
It logs important system events like starts and stops of servers,
upgrades to a new version, fatal system errors or key business transactions.

The microservice currently supports the following deployment options:
* Deployment platforms: Standalone Process
* External APIs: HTTP/REST
* Persistence: Memory, Flat Files, MongoDB

This microservice has no dependencies on other microservices.

<a name="links"></a> Quick Links:

* [Download Links](doc/Downloads.md)
* [Development Guide](doc/Development.md)
* [Configuration Guide](doc/Configuration.md)
* [Deployment Guide](doc/Deployment.md)
* Client SDKs
  - [Node.js SDK](https://github.com/pip-services/pip-clients-eventlog-dart)
* Communication Protocols
  - [HTTP Version 1](doc/HttpProtocolV1.md)
  - [Seneca Version 1](doc/SenecaProtocolV1.md)

##  Contract

Logical contract of the microservice is presented below. For physical implementation (HTTP/REST, Thrift, Seneca, Lambda, etc.),
please, refer to documentation of the specific protocol.

```dart
class SystemEventV1 implements IStringIdentifiable
{
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

	void fromJson(Map<String, dynamic> json);
	Map<String, dynamic> toJson();
}

class EventLogTypeV1
{
	static final String Restart = "restart";
	static final String Failure = "failure";
	static final String Warning = "warning";
	static final String Transaction = "transaction";
	static final String Other = "other";
}

class EventLogSeverityV1
{
	static final Critical = 0;
	static final Important = 500;
	static final Informational = 1000;
}

abstract class IEventLogClientV1
{
	Future<DataPage<SystemEventV1>> getEvents(String correlationId, FilterParams filter, PagingParams paging);
	Future<SystemEventV1> logEvent(String correlationId, SystemEventV1 event);
}
```

## Download

Right now the only way to get the microservice is to check it out directly from github repository
```bash
git clone git@github.com:pip-services-infrastructure/pip-services-eventlog-dart.git
```

Pip.Service team is working to implement packaging and make stable releases available for your 
as zip downloadable archieves.

## Run

Add **config.json** file to the root of the microservice folder and set configuration parameters.
As the starting point you can use example configuration from **config.example.yml** file. 

Example of microservice configuration
```yaml
- descriptor: "pip-services-container:container-info:default:default:1.0"
  name: "pip-services-eventlog"
  description: "EventLog microservice"

- descriptor: "pip-services-commons:logger:console:default:1.0"
  level: "trace"

- descriptor: "pip-services-eventlog:persistence:file:default:1.0"
  path: "./data/eventlog.json"

- descriptor: "pip-services-eventlog:controller:default:default:1.0"

- descriptor: "pip-services-eventlog:service:http:default:1.0"
  connection:
    protocol: "http"
    host: "0.0.0.0"
    port: 8080
```
 
For more information on the microservice configuration see [Configuration Guide](Configuration.md).

Start the microservice using the command:
```bash
dart ./bin/run.dart
```

## Use

The easiest way to work with the microservice is to use client SDK. 
The complete list of available client SDKs for different languages is listed in the [Quick Links](#links)

If you use dart, then get references to the required libraries:
- Pip.Services3.Commons : https://github.com/pip-services3-dart/pip-services3-commons-dart
- Pip.Services3.Rpc: https://github.com/pip-services3-dart/pip-services3-rpc-dart

Add **pip-services3-commons-dart** and **pip_clients_eventlog** packages
```dart
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_clients_eventlog/pip_clients_eventlog.dart';

```

Define client configuration parameters that match configuration of the microservice external API
```dart
// Client configuration
var httpConfig = ConfigParams.fromTuples(
	"connection.protocol", "http",
	"connection.host", "localhost",
	"connection.port", 8080
);
```

Instantiate the client and open connection to the microservice
```dart
// Create the client instance
var client = EventLogHttpClientV1();

// Configure the client
client.configure(httpConfig);

// Connect to the microservice
try{
  await client.open(null)
}catch() {
  // Error handling...
}       
// Work with the microservice
// ...
```

Now the client is ready to perform operations
```dart
// Log system event
try {
    var event = await client.logEvent('123', SystemEventV1.fromMap({
        type: 'restart',
        source: 'server1',
        message: 'Restarted server'
    }));
    // Do something with the returned event...
} catch(err) {
    // Error handling...     
}
```

```dart
var now = DateTime.now();

// Get the list system events
client.getEvents(
    null, 
    FilterParams.fromTuples([
        "from_time", now.subtract(new Duration(days: 1)),
        "to_time", now,
        "source", 'server1'
    ]),
    PagingParams(0, 10));
);
```    

## Acknowledgements

This microservice was created and currently maintained by *Sergey Seroukhov*.

