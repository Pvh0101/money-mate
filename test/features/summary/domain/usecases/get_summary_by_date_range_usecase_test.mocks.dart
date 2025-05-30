// Mocks generated by Mockito 5.4.5 from annotations
// in money_mate/test/features/summary/domain/usecases/get_summary_by_date_range_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:money_mate/core/errors/failures.dart' as _i5;
import 'package:money_mate/features/summary/domain/entities/summary_data.dart'
    as _i6;
import 'package:money_mate/features/summary/domain/entities/time_range.dart'
    as _i7;
import 'package:money_mate/features/summary/domain/repositories/summary_repository.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SummaryRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSummaryRepository extends _i1.Mock implements _i3.SummaryRepository {
  MockSummaryRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.SummaryData>> getSummaryByTimeRange(
    _i7.TimeRange? timeRange, {
    String? userId,
    DateTime? referenceDate,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSummaryByTimeRange,
          [timeRange],
          {
            #userId: userId,
            #referenceDate: referenceDate,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.SummaryData>>.value(
            _FakeEither_0<_i5.Failure, _i6.SummaryData>(
          this,
          Invocation.method(
            #getSummaryByTimeRange,
            [timeRange],
            {
              #userId: userId,
              #referenceDate: referenceDate,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.SummaryData>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.SummaryData>> getSummaryByDateRange(
    DateTime? startDate,
    DateTime? endDate, {
    String? userId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSummaryByDateRange,
          [
            startDate,
            endDate,
          ],
          {#userId: userId},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.SummaryData>>.value(
            _FakeEither_0<_i5.Failure, _i6.SummaryData>(
          this,
          Invocation.method(
            #getSummaryByDateRange,
            [
              startDate,
              endDate,
            ],
            {#userId: userId},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.SummaryData>>);
}
