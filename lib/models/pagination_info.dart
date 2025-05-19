import 'package:equatable/equatable.dart';

class PaginationInfo extends Equatable {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  const PaginationInfo({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      count: json['count'] as int,
      pages: json['pages'] as int,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );
  }

  @override
  List<Object?> get props => [count, pages, next, prev];
}