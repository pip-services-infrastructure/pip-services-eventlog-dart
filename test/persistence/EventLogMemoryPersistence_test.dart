
import 'package:pip_services_eventlog/pip_services_eventlog.dart';
import 'package:test/test.dart';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import  'EventLogPersistenceFixture.dart';

void main(){
group('EventLogMemoryPersistence', ()  {
    EventLogMemoryPersistence persistence ;
    EventLogPersistenceFixture fixture;

    setUp(() async {
        persistence =  EventLogMemoryPersistence();
        persistence.configure( ConfigParams());

        fixture =  EventLogPersistenceFixture(persistence);

        await persistence.open(null);
    });

    tearDown(() async {
        await persistence.close(null);
    });

    test('CRUD Operations', () async {
        await fixture.testCrudOperations();
    });

    test('Get with Filters', () async {
        await fixture.testGetWithFilters();
    });

});
}