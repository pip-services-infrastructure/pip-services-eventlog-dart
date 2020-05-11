import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_eventlog/pip_services_eventlog.dart';
import '../data/TestModel.dart';

void main() {
  group('EventLogController', () {
    EventLogMemoryPersistence _persistence;
    EventLogController _controller;

    setUp(() async {
      _persistence = EventLogMemoryPersistence();
      _persistence.configure(ConfigParams());

      _controller = EventLogController();
      _controller.configure(ConfigParams());

      var references = References.fromTuples([
        Descriptor('pip-services-eventlog', 'persistence', 'memory', 'default', '1.0'), _persistence,
        Descriptor('pip-services-eventlog', 'controller', 'default', 'default', '1.0'), _controller
      ]);

      _controller.setReferences(references);

      await _persistence.open(null);
    });

    tearDown(() async {
      await _persistence.close(null);
    });

    test('Create Event', () async {
      // arrange
      var event = TestModel.createSystemEvent();

      // act
      var result = await _controller.logEvent(null, event);

      // assert
      TestModel.assertEqual(event, result);
    });

    test('Get Events', () async {
      // arrange
      await _controller.logEvent(null, TestModel.createSystemEvent());
      await _controller.logEvent(null, TestModel.createSystemEvent());

      // act
      var result = await _controller.getEvents(null, null, null);

      // assert
      expect(result, isNotNull);
      expect(2, result.data.length);
    });
  });
}
