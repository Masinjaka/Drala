import 'dart:async';

import 'package:budgets/features/ai_entry/domain/errors/ai_entry_exception.dart';
import 'package:budgets/features/ai_entry/domain/models/ai_entry_result.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_ai_entry_repository.dart';

void main() {
  test('clears the pending skeleton when an AI request times out', () async {
    final repository = FakeAiEntryRepository()
      ..resultCompleter = Completer<AiEntryResult>();
    final viewModel = AiEntryViewModel(
      repository,
      DateTime(2026, 7, 17),
      submissionTimeout: const Duration(milliseconds: 10),
    );
    addTearDown(viewModel.dispose);

    final submission = viewModel.submit(
      'Nividy sakafo 24000 MGA aho',
      outputLanguage: 'mg',
    );
    expect(viewModel.isSubmitting, isTrue);

    await expectLater(
      submission,
      throwsA(
        isA<AiEntryException>()
            .having((error) => error.code, 'code', 'request_timeout'),
      ),
    );

    expect(repository.submittedOutputLanguage, 'mg');
    expect(viewModel.isSubmitting, isFalse);
  });
}
