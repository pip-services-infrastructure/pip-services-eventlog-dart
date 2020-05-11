import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_eventlog/pip_services_eventlog.dart';

import '../data/TestModel.dart';

final EVENT1 = TestModel.createSystemEvent();
final EVENT2 = TestModel.createSystemEvent();
final EVENT3 = TestModel.createSystemEvent();

class EventLogPersistenceFixture {
  IEventLogPersistence _persistence;

  EventLogPersistenceFixture(IEventLogPersistence persistence) {
    expect(persistence, isNotNull);
    _persistence = persistence;
  }

  void _testCreateEventLog() async {
    // Create the first event
    var event = await _persistence.create(null, EVENT1);
    TestModel.assertEqual(EVENT1, event);

    // Create the second event
    event = await _persistence.create(null, EVENT2);
    TestModel.assertEqual(EVENT2, event);

    // Create the third event
    event = await _persistence.create(null, EVENT3);
    TestModel.assertEqual(EVENT3, event);
  }

  void testCrudOperations() async {
    SystemEventV1 event1;

    // Create items
    await _testCreateEventLog();

    // Get all EventLog
    var page = await _persistence.getPageByFilter(null, FilterParams(), PagingParams());
    expect(page, isNotNull);
    expect(page.data.length, 3);

    event1 = page.data[0];

    // Update the event
    event1.message = 'ABC';

    var event = await _persistence.update(null, event1);
    expect(event, isNotNull);
    expect(event1.id, event.id);
    expect('ABC', event.message);

    // Delete the event
    event = await _persistence.deleteById(null, event1.id);
    expect(event, isNotNull);
    expect(event1.id, event.id);

    // Try to get deleted event
    event = await _persistence.getOneById(null, event1.id);
    expect(event, isNull);
  }

  void testGetWithFilters() async {
    // Create items
    await _testCreateEventLog();

    // Filter by id
    var page = await _persistence.getPageByFilter(null, 
      FilterParams.fromTuples(['id', EVENT1.id]), PagingParams());
    expect(page.data.length, 1);
  }
}
