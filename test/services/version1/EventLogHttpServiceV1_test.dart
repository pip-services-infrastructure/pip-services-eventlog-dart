import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_eventlog/pip_services_eventlog.dart';

import '../../data/TestModel.dart';

final EVENT1 = TestModel.createSystemEvent();
final EVENT2 = TestModel.createSystemEvent();

var httpConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3000
]);

void main() {
  group('EventLogHttpServiceV1', () {
    EventLogMemoryPersistence persistence;
    EventLogController controller;
    EventLogHttpServiceV1 service;
    http.Client rest;
    String url;

    setUp(() async {
      url = 'http://localhost:3000';
      rest = http.Client();

      persistence = EventLogMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = EventLogController();
      controller.configure(ConfigParams());

      service = EventLogHttpServiceV1();
      service.configure(httpConfig);

      var references = References.fromTuples([
        Descriptor('pip-services-eventlog', 'persistence', 'memory', 'default', '1.0'),
        persistence,
        Descriptor('pip-services-eventlog', 'controller', 'default', 'default', '1.0'),
        controller,
        Descriptor('pip-services-eventlog', 'service', 'http', 'default', '1.0'),
        service
      ]);

      controller.setReferences(references);
      service.setReferences(references);

      await persistence.open(null);
      await service.open(null);
    });

    tearDown(() async {
      await service.close(null);
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      // Create the first event
      var resp = await rest.post(url + '/v1/eventlog/log_event',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'event': EVENT1}));
      var event = SystemEventV1();
      event.fromJson(json.decode(resp.body));
      TestModel.assertEqual(EVENT1, event);

      // Create the second event
      resp = await rest.post(url + '/v1/eventlog/log_event',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'event': EVENT2}));
      event = SystemEventV1();
      event.fromJson(json.decode(resp.body));
      TestModel.assertEqual(EVENT2, event);

      // Get all events
      resp = await rest.post(url + '/v1/eventlog/get_events',
          headers: {'Content-Type': 'application/json'},
          body: json
              .encode({'filter': FilterParams(), 'paging': PagingParams()}));
      var page = DataPage<SystemEventV1>.fromJson(json.decode(resp.body),
          (item) {
        var event = SystemEventV1();
        event.fromJson(item);
        return event;
      });
      expect(page, isNotNull);
      expect(page.data.length, 2);
    });
  });
}
