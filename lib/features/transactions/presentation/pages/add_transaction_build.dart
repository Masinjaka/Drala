part of 'add_transaction.dart';

extension _TransactionCreationPageStateBuild on _TransactionCreationPageState {
  Widget _buildFormContent(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(body: Center(child: AppLoader()));
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _buildBody(),
      bottomNavigationBar: _buildAddButton(),
    );
  }
}
