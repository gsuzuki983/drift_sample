// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class UseCase extends DataClass implements Insertable<UseCase> {
  final int id;
  final String name;
  final int situationId;
  UseCase({required this.id, required this.name, required this.situationId});
  factory UseCase.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return UseCase(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      situationId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}situation_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['situation_id'] = Variable<int>(situationId);
    return map;
  }

  UseCasesCompanion toCompanion(bool nullToAbsent) {
    return UseCasesCompanion(
      id: Value(id),
      name: Value(name),
      situationId: Value(situationId),
    );
  }

  factory UseCase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UseCase(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      situationId: serializer.fromJson<int>(json['situationId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'situationId': serializer.toJson<int>(situationId),
    };
  }

  UseCase copyWith({int? id, String? name, int? situationId}) => UseCase(
        id: id ?? this.id,
        name: name ?? this.name,
        situationId: situationId ?? this.situationId,
      );
  @override
  String toString() {
    return (StringBuffer('UseCase(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('situationId: $situationId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, situationId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UseCase &&
          other.id == this.id &&
          other.name == this.name &&
          other.situationId == this.situationId);
}

class UseCasesCompanion extends UpdateCompanion<UseCase> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> situationId;
  const UseCasesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.situationId = const Value.absent(),
  });
  UseCasesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int situationId,
  })  : name = Value(name),
        situationId = Value(situationId);
  static Insertable<UseCase> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? situationId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (situationId != null) 'situation_id': situationId,
    });
  }

  UseCasesCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? situationId}) {
    return UseCasesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      situationId: situationId ?? this.situationId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (situationId.present) {
      map['situation_id'] = Variable<int>(situationId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UseCasesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('situationId: $situationId')
          ..write(')'))
        .toString();
  }
}

class $UseCasesTable extends UseCases with TableInfo<$UseCasesTable, UseCase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UseCasesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _situationIdMeta =
      const VerificationMeta('situationId');
  @override
  late final GeneratedColumn<int?> situationId = GeneratedColumn<int?>(
      'situation_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES situations(id)');
  @override
  List<GeneratedColumn> get $columns => [id, name, situationId];
  @override
  String get aliasedName => _alias ?? 'use_cases';
  @override
  String get actualTableName => 'use_cases';
  @override
  VerificationContext validateIntegrity(Insertable<UseCase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('situation_id')) {
      context.handle(
          _situationIdMeta,
          situationId.isAcceptableOrUnknown(
              data['situation_id']!, _situationIdMeta));
    } else if (isInserting) {
      context.missing(_situationIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UseCase map(Map<String, dynamic> data, {String? tablePrefix}) {
    return UseCase.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UseCasesTable createAlias(String alias) {
    return $UseCasesTable(attachedDatabase, alias);
  }
}

class InventoryItem extends DataClass implements Insertable<InventoryItem> {
  final int id;
  final String content;
  final String? description;
  final bool isChecked;
  final int useCaseId;
  final int situationId;
  InventoryItem(
      {required this.id,
      required this.content,
      this.description,
      required this.isChecked,
      required this.useCaseId,
      required this.situationId});
  factory InventoryItem.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return InventoryItem(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      content: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      isChecked: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_checked'])!,
      useCaseId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}use_case_id'])!,
      situationId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}situation_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String?>(description);
    }
    map['is_checked'] = Variable<bool>(isChecked);
    map['use_case_id'] = Variable<int>(useCaseId);
    map['situation_id'] = Variable<int>(situationId);
    return map;
  }

  InventoryItemsCompanion toCompanion(bool nullToAbsent) {
    return InventoryItemsCompanion(
      id: Value(id),
      content: Value(content),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isChecked: Value(isChecked),
      useCaseId: Value(useCaseId),
      situationId: Value(situationId),
    );
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryItem(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      description: serializer.fromJson<String?>(json['description']),
      isChecked: serializer.fromJson<bool>(json['isChecked']),
      useCaseId: serializer.fromJson<int>(json['useCaseId']),
      situationId: serializer.fromJson<int>(json['situationId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'description': serializer.toJson<String?>(description),
      'isChecked': serializer.toJson<bool>(isChecked),
      'useCaseId': serializer.toJson<int>(useCaseId),
      'situationId': serializer.toJson<int>(situationId),
    };
  }

  InventoryItem copyWith(
          {int? id,
          String? content,
          String? description,
          bool? isChecked,
          int? useCaseId,
          int? situationId}) =>
      InventoryItem(
        id: id ?? this.id,
        content: content ?? this.content,
        description: description ?? this.description,
        isChecked: isChecked ?? this.isChecked,
        useCaseId: useCaseId ?? this.useCaseId,
        situationId: situationId ?? this.situationId,
      );
  @override
  String toString() {
    return (StringBuffer('InventoryItem(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('description: $description, ')
          ..write('isChecked: $isChecked, ')
          ..write('useCaseId: $useCaseId, ')
          ..write('situationId: $situationId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, content, description, isChecked, useCaseId, situationId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryItem &&
          other.id == this.id &&
          other.content == this.content &&
          other.description == this.description &&
          other.isChecked == this.isChecked &&
          other.useCaseId == this.useCaseId &&
          other.situationId == this.situationId);
}

class InventoryItemsCompanion extends UpdateCompanion<InventoryItem> {
  final Value<int> id;
  final Value<String> content;
  final Value<String?> description;
  final Value<bool> isChecked;
  final Value<int> useCaseId;
  final Value<int> situationId;
  const InventoryItemsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.description = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.useCaseId = const Value.absent(),
    this.situationId = const Value.absent(),
  });
  InventoryItemsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    this.description = const Value.absent(),
    this.isChecked = const Value.absent(),
    required int useCaseId,
    required int situationId,
  })  : content = Value(content),
        useCaseId = Value(useCaseId),
        situationId = Value(situationId);
  static Insertable<InventoryItem> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<String?>? description,
    Expression<bool>? isChecked,
    Expression<int>? useCaseId,
    Expression<int>? situationId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (description != null) 'description': description,
      if (isChecked != null) 'is_checked': isChecked,
      if (useCaseId != null) 'use_case_id': useCaseId,
      if (situationId != null) 'situation_id': situationId,
    });
  }

  InventoryItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? content,
      Value<String?>? description,
      Value<bool>? isChecked,
      Value<int>? useCaseId,
      Value<int>? situationId}) {
    return InventoryItemsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      description: description ?? this.description,
      isChecked: isChecked ?? this.isChecked,
      useCaseId: useCaseId ?? this.useCaseId,
      situationId: situationId ?? this.situationId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (description.present) {
      map['description'] = Variable<String?>(description.value);
    }
    if (isChecked.present) {
      map['is_checked'] = Variable<bool>(isChecked.value);
    }
    if (useCaseId.present) {
      map['use_case_id'] = Variable<int>(useCaseId.value);
    }
    if (situationId.present) {
      map['situation_id'] = Variable<int>(situationId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItemsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('description: $description, ')
          ..write('isChecked: $isChecked, ')
          ..write('useCaseId: $useCaseId, ')
          ..write('situationId: $situationId')
          ..write(')'))
        .toString();
  }
}

class $InventoryItemsTable extends InventoryItems
    with TableInfo<$InventoryItemsTable, InventoryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryItemsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  @override
  late final GeneratedColumn<String?> content = GeneratedColumn<String?>(
      'content', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: const StringType(),
      requiredDuringInsert: false);
  final VerificationMeta _isCheckedMeta = const VerificationMeta('isChecked');
  @override
  late final GeneratedColumn<bool?> isChecked = GeneratedColumn<bool?>(
      'is_checked', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_checked IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _useCaseIdMeta = const VerificationMeta('useCaseId');
  @override
  late final GeneratedColumn<int?> useCaseId = GeneratedColumn<int?>(
      'use_case_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES useCases(id)');
  final VerificationMeta _situationIdMeta =
      const VerificationMeta('situationId');
  @override
  late final GeneratedColumn<int?> situationId = GeneratedColumn<int?>(
      'situation_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES situations(id)');
  @override
  List<GeneratedColumn> get $columns =>
      [id, content, description, isChecked, useCaseId, situationId];
  @override
  String get aliasedName => _alias ?? 'inventory_items';
  @override
  String get actualTableName => 'inventory_items';
  @override
  VerificationContext validateIntegrity(Insertable<InventoryItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('is_checked')) {
      context.handle(_isCheckedMeta,
          isChecked.isAcceptableOrUnknown(data['is_checked']!, _isCheckedMeta));
    }
    if (data.containsKey('use_case_id')) {
      context.handle(
          _useCaseIdMeta,
          useCaseId.isAcceptableOrUnknown(
              data['use_case_id']!, _useCaseIdMeta));
    } else if (isInserting) {
      context.missing(_useCaseIdMeta);
    }
    if (data.containsKey('situation_id')) {
      context.handle(
          _situationIdMeta,
          situationId.isAcceptableOrUnknown(
              data['situation_id']!, _situationIdMeta));
    } else if (isInserting) {
      context.missing(_situationIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    return InventoryItem.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $InventoryItemsTable createAlias(String alias) {
    return $InventoryItemsTable(attachedDatabase, alias);
  }
}

class Situation extends DataClass implements Insertable<Situation> {
  final int id;
  final String name;
  Situation({required this.id, required this.name});
  factory Situation.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Situation(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  SituationsCompanion toCompanion(bool nullToAbsent) {
    return SituationsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Situation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Situation(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Situation copyWith({int? id, String? name}) => Situation(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Situation(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Situation && other.id == this.id && other.name == this.name);
}

class SituationsCompanion extends UpdateCompanion<Situation> {
  final Value<int> id;
  final Value<String> name;
  const SituationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  SituationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Situation> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  SituationsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return SituationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SituationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $SituationsTable extends Situations
    with TableInfo<$SituationsTable, Situation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SituationsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: const StringType(),
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'situations';
  @override
  String get actualTableName => 'situations';
  @override
  VerificationContext validateIntegrity(Insertable<Situation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Situation map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Situation.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $SituationsTable createAlias(String alias) {
    return $SituationsTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $UseCasesTable useCases = $UseCasesTable(this);
  late final $InventoryItemsTable inventoryItems = $InventoryItemsTable(this);
  late final $SituationsTable situations = $SituationsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [useCases, inventoryItems, situations];
}
