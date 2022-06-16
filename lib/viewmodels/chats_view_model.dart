import 'package:chat/chat.dart';
import 'package:my_chat_app/data/datasources/datasource_contract.dart';
import 'package:my_chat_app/models/local_message.dart';
import 'package:my_chat_app/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {

  final IDataSource _dataSource;

  ChatsViewModel(this._dataSource) : super(_dataSource);

  Future<void> receiveMessages(Message message) async {
    /// creating _localMessage object for received message object
    LocalMessage _localMessage = LocalMessage(
        chatId: message.from,
        message: message,
        receipt: ReceiptStatus.delivered
    );
    await addMessage(_localMessage);

  }
}