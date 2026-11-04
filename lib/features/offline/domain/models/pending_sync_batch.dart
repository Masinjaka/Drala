class PendingSyncBatch {
  const PendingSyncBatch(
      {required this.id, required this.revision, required this.operations});
  final String id;
  final int revision;
  final List<Map<String, dynamic>> operations;
  Map<String, dynamic> toJson() =>
      {'id': id, 'revision': revision, 'operations': operations};
  factory PendingSyncBatch.fromJson(Map<String, dynamic> json) =>
      PendingSyncBatch(
          id: json['id'] as String,
          revision: (json['revision'] as num).toInt(),
          operations: (json['operations'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList());
}
