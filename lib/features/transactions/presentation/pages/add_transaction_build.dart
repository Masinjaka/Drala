part of 'add_transaction.dart';

extension _TransactionCreationPageStateBuild on _TransactionCreationPageState {
  Widget _buildFormContent(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
          body: Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor)));
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _buildBody(),
      bottomNavigationBar: _buildAddButton(),
    );
  }
}
