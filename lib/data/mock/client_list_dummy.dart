import 'package:ag_broker/domain/entities/client_list_model.dart';

ClientListModel getMockClientListModel() {
  return ClientListModel(
    status: 1,
    message: 'Mock clients',
    data: [
      Datum(userId: 501, name: 'Ravi Kumar', phone: '9876543210'),
      Datum(userId: 502, name: 'Priya Sharma', phone: '9123456780'),
      Datum(userId: 503, name: 'Sandeep Singh', phone: '9988776655'),
    ],
  );
}
