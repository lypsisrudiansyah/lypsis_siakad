import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lypsis_siakad/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class IdParams extends Equatable {
  final String id;
  const IdParams({required this.id});
  @override
  List<Object?> get props => [id];
}

class SearchParams extends Equatable {
  final String query;
  final String? category; // Opsional: untuk filter kategori
  final DateTime? startDate; // Opsional: untuk filter tanggal
  final DateTime? endDate; // Opsional: untuk filter tanggal

  const SearchParams({
    required this.query,
    this.category,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [query, category, startDate, endDate];
}