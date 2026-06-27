// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ScheduleItemsTable extends ScheduleItems
    with TableInfo<$ScheduleItemsTable, ScheduleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
      'start_time', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 5, maxTextLength: 5),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
      'end_time', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 5, maxTextLength: 5),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _scheduleModeMeta =
      const VerificationMeta('scheduleMode');
  @override
  late final GeneratedColumn<String> scheduleMode = GeneratedColumn<String>(
      'schedule_mode', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _enableNotificationMeta =
      const VerificationMeta('enableNotification');
  @override
  late final GeneratedColumn<bool> enableNotification = GeneratedColumn<bool>(
      'enable_notification', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("enable_notification" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notifyBeforeMinutesMeta =
      const VerificationMeta('notifyBeforeMinutes');
  @override
  late final GeneratedColumn<int> notifyBeforeMinutes = GeneratedColumn<int>(
      'notify_before_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reminderTypeMeta =
      const VerificationMeta('reminderType');
  @override
  late final GeneratedColumn<String> reminderType = GeneratedColumn<String>(
      'reminder_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('notification'));
  static const VerificationMeta _reminderOffsetMinutesMeta =
      const VerificationMeta('reminderOffsetMinutes');
  @override
  late final GeneratedColumn<int> reminderOffsetMinutes = GeneratedColumn<int>(
      'reminder_offset_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _alarmSoundMeta =
      const VerificationMeta('alarmSound');
  @override
  late final GeneratedColumn<String> alarmSound = GeneratedColumn<String>(
      'alarm_sound', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _vibrateMeta =
      const VerificationMeta('vibrate');
  @override
  late final GeneratedColumn<bool> vibrate = GeneratedColumn<bool>(
      'vibrate', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("vibrate" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _enableAlarmMeta =
      const VerificationMeta('enableAlarm');
  @override
  late final GeneratedColumn<bool> enableAlarm = GeneratedColumn<bool>(
      'enable_alarm', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("enable_alarm" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        startTime,
        endTime,
        category,
        scheduleMode,
        isActive,
        enableNotification,
        notifyBeforeMinutes,
        reminderType,
        reminderOffsetMinutes,
        alarmSound,
        vibrate,
        enableAlarm,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_items';
  @override
  VerificationContext validateIntegrity(Insertable<ScheduleItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('schedule_mode')) {
      context.handle(
          _scheduleModeMeta,
          scheduleMode.isAcceptableOrUnknown(
              data['schedule_mode']!, _scheduleModeMeta));
    } else if (isInserting) {
      context.missing(_scheduleModeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('enable_notification')) {
      context.handle(
          _enableNotificationMeta,
          enableNotification.isAcceptableOrUnknown(
              data['enable_notification']!, _enableNotificationMeta));
    }
    if (data.containsKey('notify_before_minutes')) {
      context.handle(
          _notifyBeforeMinutesMeta,
          notifyBeforeMinutes.isAcceptableOrUnknown(
              data['notify_before_minutes']!, _notifyBeforeMinutesMeta));
    }
    if (data.containsKey('reminder_type')) {
      context.handle(
          _reminderTypeMeta,
          reminderType.isAcceptableOrUnknown(
              data['reminder_type']!, _reminderTypeMeta));
    }
    if (data.containsKey('reminder_offset_minutes')) {
      context.handle(
          _reminderOffsetMinutesMeta,
          reminderOffsetMinutes.isAcceptableOrUnknown(
              data['reminder_offset_minutes']!, _reminderOffsetMinutesMeta));
    }
    if (data.containsKey('alarm_sound')) {
      context.handle(
          _alarmSoundMeta,
          alarmSound.isAcceptableOrUnknown(
              data['alarm_sound']!, _alarmSoundMeta));
    }
    if (data.containsKey('vibrate')) {
      context.handle(_vibrateMeta,
          vibrate.isAcceptableOrUnknown(data['vibrate']!, _vibrateMeta));
    }
    if (data.containsKey('enable_alarm')) {
      context.handle(
          _enableAlarmMeta,
          enableAlarm.isAcceptableOrUnknown(
              data['enable_alarm']!, _enableAlarmMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_time'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      scheduleMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_mode'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      enableNotification: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}enable_notification'])!,
      notifyBeforeMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}notify_before_minutes'])!,
      reminderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_type'])!,
      reminderOffsetMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}reminder_offset_minutes'])!,
      alarmSound: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alarm_sound'])!,
      vibrate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}vibrate'])!,
      enableAlarm: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enable_alarm'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ScheduleItemsTable createAlias(String alias) {
    return $ScheduleItemsTable(attachedDatabase, alias);
  }
}

class ScheduleItem extends DataClass implements Insertable<ScheduleItem> {
  final int id;
  final String title;
  final String? description;
  final String startTime;
  final String endTime;
  final String category;
  final String scheduleMode;
  final bool isActive;
  final bool enableNotification;
  final int notifyBeforeMinutes;
  final String reminderType;
  final int reminderOffsetMinutes;
  final String alarmSound;
  final bool vibrate;
  final bool enableAlarm;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ScheduleItem(
      {required this.id,
      required this.title,
      this.description,
      required this.startTime,
      required this.endTime,
      required this.category,
      required this.scheduleMode,
      required this.isActive,
      required this.enableNotification,
      required this.notifyBeforeMinutes,
      required this.reminderType,
      required this.reminderOffsetMinutes,
      required this.alarmSound,
      required this.vibrate,
      required this.enableAlarm,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    map['category'] = Variable<String>(category);
    map['schedule_mode'] = Variable<String>(scheduleMode);
    map['is_active'] = Variable<bool>(isActive);
    map['enable_notification'] = Variable<bool>(enableNotification);
    map['notify_before_minutes'] = Variable<int>(notifyBeforeMinutes);
    map['reminder_type'] = Variable<String>(reminderType);
    map['reminder_offset_minutes'] = Variable<int>(reminderOffsetMinutes);
    map['alarm_sound'] = Variable<String>(alarmSound);
    map['vibrate'] = Variable<bool>(vibrate);
    map['enable_alarm'] = Variable<bool>(enableAlarm);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ScheduleItemsCompanion toCompanion(bool nullToAbsent) {
    return ScheduleItemsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startTime: Value(startTime),
      endTime: Value(endTime),
      category: Value(category),
      scheduleMode: Value(scheduleMode),
      isActive: Value(isActive),
      enableNotification: Value(enableNotification),
      notifyBeforeMinutes: Value(notifyBeforeMinutes),
      reminderType: Value(reminderType),
      reminderOffsetMinutes: Value(reminderOffsetMinutes),
      alarmSound: Value(alarmSound),
      vibrate: Value(vibrate),
      enableAlarm: Value(enableAlarm),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ScheduleItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      category: serializer.fromJson<String>(json['category']),
      scheduleMode: serializer.fromJson<String>(json['scheduleMode']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      enableNotification: serializer.fromJson<bool>(json['enableNotification']),
      notifyBeforeMinutes:
          serializer.fromJson<int>(json['notifyBeforeMinutes']),
      reminderType: serializer.fromJson<String>(json['reminderType']),
      reminderOffsetMinutes:
          serializer.fromJson<int>(json['reminderOffsetMinutes']),
      alarmSound: serializer.fromJson<String>(json['alarmSound']),
      vibrate: serializer.fromJson<bool>(json['vibrate']),
      enableAlarm: serializer.fromJson<bool>(json['enableAlarm']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'category': serializer.toJson<String>(category),
      'scheduleMode': serializer.toJson<String>(scheduleMode),
      'isActive': serializer.toJson<bool>(isActive),
      'enableNotification': serializer.toJson<bool>(enableNotification),
      'notifyBeforeMinutes': serializer.toJson<int>(notifyBeforeMinutes),
      'reminderType': serializer.toJson<String>(reminderType),
      'reminderOffsetMinutes': serializer.toJson<int>(reminderOffsetMinutes),
      'alarmSound': serializer.toJson<String>(alarmSound),
      'vibrate': serializer.toJson<bool>(vibrate),
      'enableAlarm': serializer.toJson<bool>(enableAlarm),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ScheduleItem copyWith(
          {int? id,
          String? title,
          Value<String?> description = const Value.absent(),
          String? startTime,
          String? endTime,
          String? category,
          String? scheduleMode,
          bool? isActive,
          bool? enableNotification,
          int? notifyBeforeMinutes,
          String? reminderType,
          int? reminderOffsetMinutes,
          String? alarmSound,
          bool? vibrate,
          bool? enableAlarm,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ScheduleItem(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        category: category ?? this.category,
        scheduleMode: scheduleMode ?? this.scheduleMode,
        isActive: isActive ?? this.isActive,
        enableNotification: enableNotification ?? this.enableNotification,
        notifyBeforeMinutes: notifyBeforeMinutes ?? this.notifyBeforeMinutes,
        reminderType: reminderType ?? this.reminderType,
        reminderOffsetMinutes:
            reminderOffsetMinutes ?? this.reminderOffsetMinutes,
        alarmSound: alarmSound ?? this.alarmSound,
        vibrate: vibrate ?? this.vibrate,
        enableAlarm: enableAlarm ?? this.enableAlarm,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ScheduleItem copyWithCompanion(ScheduleItemsCompanion data) {
    return ScheduleItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      category: data.category.present ? data.category.value : this.category,
      scheduleMode: data.scheduleMode.present
          ? data.scheduleMode.value
          : this.scheduleMode,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      enableNotification: data.enableNotification.present
          ? data.enableNotification.value
          : this.enableNotification,
      notifyBeforeMinutes: data.notifyBeforeMinutes.present
          ? data.notifyBeforeMinutes.value
          : this.notifyBeforeMinutes,
      reminderType: data.reminderType.present
          ? data.reminderType.value
          : this.reminderType,
      reminderOffsetMinutes: data.reminderOffsetMinutes.present
          ? data.reminderOffsetMinutes.value
          : this.reminderOffsetMinutes,
      alarmSound:
          data.alarmSound.present ? data.alarmSound.value : this.alarmSound,
      vibrate: data.vibrate.present ? data.vibrate.value : this.vibrate,
      enableAlarm:
          data.enableAlarm.present ? data.enableAlarm.value : this.enableAlarm,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('category: $category, ')
          ..write('scheduleMode: $scheduleMode, ')
          ..write('isActive: $isActive, ')
          ..write('enableNotification: $enableNotification, ')
          ..write('notifyBeforeMinutes: $notifyBeforeMinutes, ')
          ..write('reminderType: $reminderType, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes, ')
          ..write('alarmSound: $alarmSound, ')
          ..write('vibrate: $vibrate, ')
          ..write('enableAlarm: $enableAlarm, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      description,
      startTime,
      endTime,
      category,
      scheduleMode,
      isActive,
      enableNotification,
      notifyBeforeMinutes,
      reminderType,
      reminderOffsetMinutes,
      alarmSound,
      vibrate,
      enableAlarm,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.category == this.category &&
          other.scheduleMode == this.scheduleMode &&
          other.isActive == this.isActive &&
          other.enableNotification == this.enableNotification &&
          other.notifyBeforeMinutes == this.notifyBeforeMinutes &&
          other.reminderType == this.reminderType &&
          other.reminderOffsetMinutes == this.reminderOffsetMinutes &&
          other.alarmSound == this.alarmSound &&
          other.vibrate == this.vibrate &&
          other.enableAlarm == this.enableAlarm &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ScheduleItemsCompanion extends UpdateCompanion<ScheduleItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<String> category;
  final Value<String> scheduleMode;
  final Value<bool> isActive;
  final Value<bool> enableNotification;
  final Value<int> notifyBeforeMinutes;
  final Value<String> reminderType;
  final Value<int> reminderOffsetMinutes;
  final Value<String> alarmSound;
  final Value<bool> vibrate;
  final Value<bool> enableAlarm;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ScheduleItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.category = const Value.absent(),
    this.scheduleMode = const Value.absent(),
    this.isActive = const Value.absent(),
    this.enableNotification = const Value.absent(),
    this.notifyBeforeMinutes = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
    this.alarmSound = const Value.absent(),
    this.vibrate = const Value.absent(),
    this.enableAlarm = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ScheduleItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String startTime,
    required String endTime,
    required String category,
    required String scheduleMode,
    this.isActive = const Value.absent(),
    this.enableNotification = const Value.absent(),
    this.notifyBeforeMinutes = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
    this.alarmSound = const Value.absent(),
    this.vibrate = const Value.absent(),
    this.enableAlarm = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : title = Value(title),
        startTime = Value(startTime),
        endTime = Value(endTime),
        category = Value(category),
        scheduleMode = Value(scheduleMode);
  static Insertable<ScheduleItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? category,
    Expression<String>? scheduleMode,
    Expression<bool>? isActive,
    Expression<bool>? enableNotification,
    Expression<int>? notifyBeforeMinutes,
    Expression<String>? reminderType,
    Expression<int>? reminderOffsetMinutes,
    Expression<String>? alarmSound,
    Expression<bool>? vibrate,
    Expression<bool>? enableAlarm,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (category != null) 'category': category,
      if (scheduleMode != null) 'schedule_mode': scheduleMode,
      if (isActive != null) 'is_active': isActive,
      if (enableNotification != null) 'enable_notification': enableNotification,
      if (notifyBeforeMinutes != null)
        'notify_before_minutes': notifyBeforeMinutes,
      if (reminderType != null) 'reminder_type': reminderType,
      if (reminderOffsetMinutes != null)
        'reminder_offset_minutes': reminderOffsetMinutes,
      if (alarmSound != null) 'alarm_sound': alarmSound,
      if (vibrate != null) 'vibrate': vibrate,
      if (enableAlarm != null) 'enable_alarm': enableAlarm,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ScheduleItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? startTime,
      Value<String>? endTime,
      Value<String>? category,
      Value<String>? scheduleMode,
      Value<bool>? isActive,
      Value<bool>? enableNotification,
      Value<int>? notifyBeforeMinutes,
      Value<String>? reminderType,
      Value<int>? reminderOffsetMinutes,
      Value<String>? alarmSound,
      Value<bool>? vibrate,
      Value<bool>? enableAlarm,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ScheduleItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      scheduleMode: scheduleMode ?? this.scheduleMode,
      isActive: isActive ?? this.isActive,
      enableNotification: enableNotification ?? this.enableNotification,
      notifyBeforeMinutes: notifyBeforeMinutes ?? this.notifyBeforeMinutes,
      reminderType: reminderType ?? this.reminderType,
      reminderOffsetMinutes:
          reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      alarmSound: alarmSound ?? this.alarmSound,
      vibrate: vibrate ?? this.vibrate,
      enableAlarm: enableAlarm ?? this.enableAlarm,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (scheduleMode.present) {
      map['schedule_mode'] = Variable<String>(scheduleMode.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (enableNotification.present) {
      map['enable_notification'] = Variable<bool>(enableNotification.value);
    }
    if (notifyBeforeMinutes.present) {
      map['notify_before_minutes'] = Variable<int>(notifyBeforeMinutes.value);
    }
    if (reminderType.present) {
      map['reminder_type'] = Variable<String>(reminderType.value);
    }
    if (reminderOffsetMinutes.present) {
      map['reminder_offset_minutes'] =
          Variable<int>(reminderOffsetMinutes.value);
    }
    if (alarmSound.present) {
      map['alarm_sound'] = Variable<String>(alarmSound.value);
    }
    if (vibrate.present) {
      map['vibrate'] = Variable<bool>(vibrate.value);
    }
    if (enableAlarm.present) {
      map['enable_alarm'] = Variable<bool>(enableAlarm.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('category: $category, ')
          ..write('scheduleMode: $scheduleMode, ')
          ..write('isActive: $isActive, ')
          ..write('enableNotification: $enableNotification, ')
          ..write('notifyBeforeMinutes: $notifyBeforeMinutes, ')
          ..write('reminderType: $reminderType, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes, ')
          ..write('alarmSound: $alarmSound, ')
          ..write('vibrate: $vibrate, ')
          ..write('enableAlarm: $enableAlarm, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyChecklistsTable extends DailyChecklists
    with TableInfo<$DailyChecklistsTable, DailyChecklist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyChecklistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _scheduleItemIdMeta =
      const VerificationMeta('scheduleItemId');
  @override
  late final GeneratedColumn<int> scheduleItemId = GeneratedColumn<int>(
      'schedule_item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES schedule_items (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 10, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _scheduleModeMeta =
      const VerificationMeta('scheduleMode');
  @override
  late final GeneratedColumn<String> scheduleMode = GeneratedColumn<String>(
      'schedule_mode', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
      'is_done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_done" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _snapshotTitleMeta =
      const VerificationMeta('snapshotTitle');
  @override
  late final GeneratedColumn<String> snapshotTitle = GeneratedColumn<String>(
      'snapshot_title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _snapshotDescriptionMeta =
      const VerificationMeta('snapshotDescription');
  @override
  late final GeneratedColumn<String> snapshotDescription =
      GeneratedColumn<String>('snapshot_description', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _snapshotStartTimeMeta =
      const VerificationMeta('snapshotStartTime');
  @override
  late final GeneratedColumn<String> snapshotStartTime =
      GeneratedColumn<String>('snapshot_start_time', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
              minTextLength: 5, maxTextLength: 5),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _snapshotEndTimeMeta =
      const VerificationMeta('snapshotEndTime');
  @override
  late final GeneratedColumn<String> snapshotEndTime = GeneratedColumn<String>(
      'snapshot_end_time', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 5, maxTextLength: 5),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _snapshotCategoryMeta =
      const VerificationMeta('snapshotCategory');
  @override
  late final GeneratedColumn<String> snapshotCategory = GeneratedColumn<String>(
      'snapshot_category', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        scheduleItemId,
        date,
        scheduleMode,
        isDone,
        note,
        completedAt,
        snapshotTitle,
        snapshotDescription,
        snapshotStartTime,
        snapshotEndTime,
        snapshotCategory,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_checklists';
  @override
  VerificationContext validateIntegrity(Insertable<DailyChecklist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('schedule_item_id')) {
      context.handle(
          _scheduleItemIdMeta,
          scheduleItemId.isAcceptableOrUnknown(
              data['schedule_item_id']!, _scheduleItemIdMeta));
    } else if (isInserting) {
      context.missing(_scheduleItemIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('schedule_mode')) {
      context.handle(
          _scheduleModeMeta,
          scheduleMode.isAcceptableOrUnknown(
              data['schedule_mode']!, _scheduleModeMeta));
    } else if (isInserting) {
      context.missing(_scheduleModeMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(_isDoneMeta,
          isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('snapshot_title')) {
      context.handle(
          _snapshotTitleMeta,
          snapshotTitle.isAcceptableOrUnknown(
              data['snapshot_title']!, _snapshotTitleMeta));
    } else if (isInserting) {
      context.missing(_snapshotTitleMeta);
    }
    if (data.containsKey('snapshot_description')) {
      context.handle(
          _snapshotDescriptionMeta,
          snapshotDescription.isAcceptableOrUnknown(
              data['snapshot_description']!, _snapshotDescriptionMeta));
    }
    if (data.containsKey('snapshot_start_time')) {
      context.handle(
          _snapshotStartTimeMeta,
          snapshotStartTime.isAcceptableOrUnknown(
              data['snapshot_start_time']!, _snapshotStartTimeMeta));
    } else if (isInserting) {
      context.missing(_snapshotStartTimeMeta);
    }
    if (data.containsKey('snapshot_end_time')) {
      context.handle(
          _snapshotEndTimeMeta,
          snapshotEndTime.isAcceptableOrUnknown(
              data['snapshot_end_time']!, _snapshotEndTimeMeta));
    } else if (isInserting) {
      context.missing(_snapshotEndTimeMeta);
    }
    if (data.containsKey('snapshot_category')) {
      context.handle(
          _snapshotCategoryMeta,
          snapshotCategory.isAcceptableOrUnknown(
              data['snapshot_category']!, _snapshotCategoryMeta));
    } else if (isInserting) {
      context.missing(_snapshotCategoryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyChecklist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyChecklist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      scheduleItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}schedule_item_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      scheduleMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_mode'])!,
      isDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_done'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      snapshotTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_title'])!,
      snapshotDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}snapshot_description']),
      snapshotStartTime: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}snapshot_start_time'])!,
      snapshotEndTime: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}snapshot_end_time'])!,
      snapshotCategory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}snapshot_category'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DailyChecklistsTable createAlias(String alias) {
    return $DailyChecklistsTable(attachedDatabase, alias);
  }
}

class DailyChecklist extends DataClass implements Insertable<DailyChecklist> {
  final int id;
  final int scheduleItemId;
  final String date;
  final String scheduleMode;
  final bool isDone;
  final String? note;
  final DateTime? completedAt;
  final String snapshotTitle;
  final String? snapshotDescription;
  final String snapshotStartTime;
  final String snapshotEndTime;
  final String snapshotCategory;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyChecklist(
      {required this.id,
      required this.scheduleItemId,
      required this.date,
      required this.scheduleMode,
      required this.isDone,
      this.note,
      this.completedAt,
      required this.snapshotTitle,
      this.snapshotDescription,
      required this.snapshotStartTime,
      required this.snapshotEndTime,
      required this.snapshotCategory,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['schedule_item_id'] = Variable<int>(scheduleItemId);
    map['date'] = Variable<String>(date);
    map['schedule_mode'] = Variable<String>(scheduleMode);
    map['is_done'] = Variable<bool>(isDone);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['snapshot_title'] = Variable<String>(snapshotTitle);
    if (!nullToAbsent || snapshotDescription != null) {
      map['snapshot_description'] = Variable<String>(snapshotDescription);
    }
    map['snapshot_start_time'] = Variable<String>(snapshotStartTime);
    map['snapshot_end_time'] = Variable<String>(snapshotEndTime);
    map['snapshot_category'] = Variable<String>(snapshotCategory);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyChecklistsCompanion toCompanion(bool nullToAbsent) {
    return DailyChecklistsCompanion(
      id: Value(id),
      scheduleItemId: Value(scheduleItemId),
      date: Value(date),
      scheduleMode: Value(scheduleMode),
      isDone: Value(isDone),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      snapshotTitle: Value(snapshotTitle),
      snapshotDescription: snapshotDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(snapshotDescription),
      snapshotStartTime: Value(snapshotStartTime),
      snapshotEndTime: Value(snapshotEndTime),
      snapshotCategory: Value(snapshotCategory),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyChecklist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyChecklist(
      id: serializer.fromJson<int>(json['id']),
      scheduleItemId: serializer.fromJson<int>(json['scheduleItemId']),
      date: serializer.fromJson<String>(json['date']),
      scheduleMode: serializer.fromJson<String>(json['scheduleMode']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      note: serializer.fromJson<String?>(json['note']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      snapshotTitle: serializer.fromJson<String>(json['snapshotTitle']),
      snapshotDescription:
          serializer.fromJson<String?>(json['snapshotDescription']),
      snapshotStartTime: serializer.fromJson<String>(json['snapshotStartTime']),
      snapshotEndTime: serializer.fromJson<String>(json['snapshotEndTime']),
      snapshotCategory: serializer.fromJson<String>(json['snapshotCategory']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scheduleItemId': serializer.toJson<int>(scheduleItemId),
      'date': serializer.toJson<String>(date),
      'scheduleMode': serializer.toJson<String>(scheduleMode),
      'isDone': serializer.toJson<bool>(isDone),
      'note': serializer.toJson<String?>(note),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'snapshotTitle': serializer.toJson<String>(snapshotTitle),
      'snapshotDescription': serializer.toJson<String?>(snapshotDescription),
      'snapshotStartTime': serializer.toJson<String>(snapshotStartTime),
      'snapshotEndTime': serializer.toJson<String>(snapshotEndTime),
      'snapshotCategory': serializer.toJson<String>(snapshotCategory),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyChecklist copyWith(
          {int? id,
          int? scheduleItemId,
          String? date,
          String? scheduleMode,
          bool? isDone,
          Value<String?> note = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent(),
          String? snapshotTitle,
          Value<String?> snapshotDescription = const Value.absent(),
          String? snapshotStartTime,
          String? snapshotEndTime,
          String? snapshotCategory,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DailyChecklist(
        id: id ?? this.id,
        scheduleItemId: scheduleItemId ?? this.scheduleItemId,
        date: date ?? this.date,
        scheduleMode: scheduleMode ?? this.scheduleMode,
        isDone: isDone ?? this.isDone,
        note: note.present ? note.value : this.note,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        snapshotTitle: snapshotTitle ?? this.snapshotTitle,
        snapshotDescription: snapshotDescription.present
            ? snapshotDescription.value
            : this.snapshotDescription,
        snapshotStartTime: snapshotStartTime ?? this.snapshotStartTime,
        snapshotEndTime: snapshotEndTime ?? this.snapshotEndTime,
        snapshotCategory: snapshotCategory ?? this.snapshotCategory,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DailyChecklist copyWithCompanion(DailyChecklistsCompanion data) {
    return DailyChecklist(
      id: data.id.present ? data.id.value : this.id,
      scheduleItemId: data.scheduleItemId.present
          ? data.scheduleItemId.value
          : this.scheduleItemId,
      date: data.date.present ? data.date.value : this.date,
      scheduleMode: data.scheduleMode.present
          ? data.scheduleMode.value
          : this.scheduleMode,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      note: data.note.present ? data.note.value : this.note,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      snapshotTitle: data.snapshotTitle.present
          ? data.snapshotTitle.value
          : this.snapshotTitle,
      snapshotDescription: data.snapshotDescription.present
          ? data.snapshotDescription.value
          : this.snapshotDescription,
      snapshotStartTime: data.snapshotStartTime.present
          ? data.snapshotStartTime.value
          : this.snapshotStartTime,
      snapshotEndTime: data.snapshotEndTime.present
          ? data.snapshotEndTime.value
          : this.snapshotEndTime,
      snapshotCategory: data.snapshotCategory.present
          ? data.snapshotCategory.value
          : this.snapshotCategory,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyChecklist(')
          ..write('id: $id, ')
          ..write('scheduleItemId: $scheduleItemId, ')
          ..write('date: $date, ')
          ..write('scheduleMode: $scheduleMode, ')
          ..write('isDone: $isDone, ')
          ..write('note: $note, ')
          ..write('completedAt: $completedAt, ')
          ..write('snapshotTitle: $snapshotTitle, ')
          ..write('snapshotDescription: $snapshotDescription, ')
          ..write('snapshotStartTime: $snapshotStartTime, ')
          ..write('snapshotEndTime: $snapshotEndTime, ')
          ..write('snapshotCategory: $snapshotCategory, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      scheduleItemId,
      date,
      scheduleMode,
      isDone,
      note,
      completedAt,
      snapshotTitle,
      snapshotDescription,
      snapshotStartTime,
      snapshotEndTime,
      snapshotCategory,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyChecklist &&
          other.id == this.id &&
          other.scheduleItemId == this.scheduleItemId &&
          other.date == this.date &&
          other.scheduleMode == this.scheduleMode &&
          other.isDone == this.isDone &&
          other.note == this.note &&
          other.completedAt == this.completedAt &&
          other.snapshotTitle == this.snapshotTitle &&
          other.snapshotDescription == this.snapshotDescription &&
          other.snapshotStartTime == this.snapshotStartTime &&
          other.snapshotEndTime == this.snapshotEndTime &&
          other.snapshotCategory == this.snapshotCategory &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyChecklistsCompanion extends UpdateCompanion<DailyChecklist> {
  final Value<int> id;
  final Value<int> scheduleItemId;
  final Value<String> date;
  final Value<String> scheduleMode;
  final Value<bool> isDone;
  final Value<String?> note;
  final Value<DateTime?> completedAt;
  final Value<String> snapshotTitle;
  final Value<String?> snapshotDescription;
  final Value<String> snapshotStartTime;
  final Value<String> snapshotEndTime;
  final Value<String> snapshotCategory;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DailyChecklistsCompanion({
    this.id = const Value.absent(),
    this.scheduleItemId = const Value.absent(),
    this.date = const Value.absent(),
    this.scheduleMode = const Value.absent(),
    this.isDone = const Value.absent(),
    this.note = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.snapshotTitle = const Value.absent(),
    this.snapshotDescription = const Value.absent(),
    this.snapshotStartTime = const Value.absent(),
    this.snapshotEndTime = const Value.absent(),
    this.snapshotCategory = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyChecklistsCompanion.insert({
    this.id = const Value.absent(),
    required int scheduleItemId,
    required String date,
    required String scheduleMode,
    this.isDone = const Value.absent(),
    this.note = const Value.absent(),
    this.completedAt = const Value.absent(),
    required String snapshotTitle,
    this.snapshotDescription = const Value.absent(),
    required String snapshotStartTime,
    required String snapshotEndTime,
    required String snapshotCategory,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : scheduleItemId = Value(scheduleItemId),
        date = Value(date),
        scheduleMode = Value(scheduleMode),
        snapshotTitle = Value(snapshotTitle),
        snapshotStartTime = Value(snapshotStartTime),
        snapshotEndTime = Value(snapshotEndTime),
        snapshotCategory = Value(snapshotCategory);
  static Insertable<DailyChecklist> custom({
    Expression<int>? id,
    Expression<int>? scheduleItemId,
    Expression<String>? date,
    Expression<String>? scheduleMode,
    Expression<bool>? isDone,
    Expression<String>? note,
    Expression<DateTime>? completedAt,
    Expression<String>? snapshotTitle,
    Expression<String>? snapshotDescription,
    Expression<String>? snapshotStartTime,
    Expression<String>? snapshotEndTime,
    Expression<String>? snapshotCategory,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleItemId != null) 'schedule_item_id': scheduleItemId,
      if (date != null) 'date': date,
      if (scheduleMode != null) 'schedule_mode': scheduleMode,
      if (isDone != null) 'is_done': isDone,
      if (note != null) 'note': note,
      if (completedAt != null) 'completed_at': completedAt,
      if (snapshotTitle != null) 'snapshot_title': snapshotTitle,
      if (snapshotDescription != null)
        'snapshot_description': snapshotDescription,
      if (snapshotStartTime != null) 'snapshot_start_time': snapshotStartTime,
      if (snapshotEndTime != null) 'snapshot_end_time': snapshotEndTime,
      if (snapshotCategory != null) 'snapshot_category': snapshotCategory,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyChecklistsCompanion copyWith(
      {Value<int>? id,
      Value<int>? scheduleItemId,
      Value<String>? date,
      Value<String>? scheduleMode,
      Value<bool>? isDone,
      Value<String?>? note,
      Value<DateTime?>? completedAt,
      Value<String>? snapshotTitle,
      Value<String?>? snapshotDescription,
      Value<String>? snapshotStartTime,
      Value<String>? snapshotEndTime,
      Value<String>? snapshotCategory,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return DailyChecklistsCompanion(
      id: id ?? this.id,
      scheduleItemId: scheduleItemId ?? this.scheduleItemId,
      date: date ?? this.date,
      scheduleMode: scheduleMode ?? this.scheduleMode,
      isDone: isDone ?? this.isDone,
      note: note ?? this.note,
      completedAt: completedAt ?? this.completedAt,
      snapshotTitle: snapshotTitle ?? this.snapshotTitle,
      snapshotDescription: snapshotDescription ?? this.snapshotDescription,
      snapshotStartTime: snapshotStartTime ?? this.snapshotStartTime,
      snapshotEndTime: snapshotEndTime ?? this.snapshotEndTime,
      snapshotCategory: snapshotCategory ?? this.snapshotCategory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scheduleItemId.present) {
      map['schedule_item_id'] = Variable<int>(scheduleItemId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (scheduleMode.present) {
      map['schedule_mode'] = Variable<String>(scheduleMode.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (snapshotTitle.present) {
      map['snapshot_title'] = Variable<String>(snapshotTitle.value);
    }
    if (snapshotDescription.present) {
      map['snapshot_description'] = Variable<String>(snapshotDescription.value);
    }
    if (snapshotStartTime.present) {
      map['snapshot_start_time'] = Variable<String>(snapshotStartTime.value);
    }
    if (snapshotEndTime.present) {
      map['snapshot_end_time'] = Variable<String>(snapshotEndTime.value);
    }
    if (snapshotCategory.present) {
      map['snapshot_category'] = Variable<String>(snapshotCategory.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyChecklistsCompanion(')
          ..write('id: $id, ')
          ..write('scheduleItemId: $scheduleItemId, ')
          ..write('date: $date, ')
          ..write('scheduleMode: $scheduleMode, ')
          ..write('isDone: $isDone, ')
          ..write('note: $note, ')
          ..write('completedAt: $completedAt, ')
          ..write('snapshotTitle: $snapshotTitle, ')
          ..write('snapshotDescription: $snapshotDescription, ')
          ..write('snapshotStartTime: $snapshotStartTime, ')
          ..write('snapshotEndTime: $snapshotEndTime, ')
          ..write('snapshotCategory: $snapshotCategory, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyModesTable extends DailyModes
    with TableInfo<$DailyModesTable, DailyMode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyModesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 10, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _scheduleModeMeta =
      const VerificationMeta('scheduleMode');
  @override
  late final GeneratedColumn<String> scheduleMode = GeneratedColumn<String>(
      'schedule_mode', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, scheduleMode, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_modes';
  @override
  VerificationContext validateIntegrity(Insertable<DailyMode> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('schedule_mode')) {
      context.handle(
          _scheduleModeMeta,
          scheduleMode.isAcceptableOrUnknown(
              data['schedule_mode']!, _scheduleModeMeta));
    } else if (isInserting) {
      context.missing(_scheduleModeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyMode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyMode(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      scheduleMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_mode'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DailyModesTable createAlias(String alias) {
    return $DailyModesTable(attachedDatabase, alias);
  }
}

class DailyMode extends DataClass implements Insertable<DailyMode> {
  final int id;
  final String date;
  final String scheduleMode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyMode(
      {required this.id,
      required this.date,
      required this.scheduleMode,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['schedule_mode'] = Variable<String>(scheduleMode);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyModesCompanion toCompanion(bool nullToAbsent) {
    return DailyModesCompanion(
      id: Value(id),
      date: Value(date),
      scheduleMode: Value(scheduleMode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyMode.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyMode(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      scheduleMode: serializer.fromJson<String>(json['scheduleMode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'scheduleMode': serializer.toJson<String>(scheduleMode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyMode copyWith(
          {int? id,
          String? date,
          String? scheduleMode,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DailyMode(
        id: id ?? this.id,
        date: date ?? this.date,
        scheduleMode: scheduleMode ?? this.scheduleMode,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DailyMode copyWithCompanion(DailyModesCompanion data) {
    return DailyMode(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      scheduleMode: data.scheduleMode.present
          ? data.scheduleMode.value
          : this.scheduleMode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyMode(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('scheduleMode: $scheduleMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, scheduleMode, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyMode &&
          other.id == this.id &&
          other.date == this.date &&
          other.scheduleMode == this.scheduleMode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyModesCompanion extends UpdateCompanion<DailyMode> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> scheduleMode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DailyModesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.scheduleMode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyModesCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String scheduleMode,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : date = Value(date),
        scheduleMode = Value(scheduleMode);
  static Insertable<DailyMode> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? scheduleMode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (scheduleMode != null) 'schedule_mode': scheduleMode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyModesCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<String>? scheduleMode,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return DailyModesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      scheduleMode: scheduleMode ?? this.scheduleMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (scheduleMode.present) {
      map['schedule_mode'] = Variable<String>(scheduleMode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyModesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('scheduleMode: $scheduleMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, key, value, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String key;
  final String value;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AppSetting(
      {required this.id,
      required this.key,
      required this.value,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith(
          {int? id,
          String? key,
          String? value,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      AppSetting(
        id: id ?? this.id,
        key: key ?? this.key,
        value: value ?? this.value,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? key,
      Value<String>? value,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScheduleItemsTable scheduleItems = $ScheduleItemsTable(this);
  late final $DailyChecklistsTable dailyChecklists =
      $DailyChecklistsTable(this);
  late final $DailyModesTable dailyModes = $DailyModesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [scheduleItems, dailyChecklists, dailyModes, appSettings];
}

typedef $$ScheduleItemsTableCreateCompanionBuilder = ScheduleItemsCompanion
    Function({
  Value<int> id,
  required String title,
  Value<String?> description,
  required String startTime,
  required String endTime,
  required String category,
  required String scheduleMode,
  Value<bool> isActive,
  Value<bool> enableNotification,
  Value<int> notifyBeforeMinutes,
  Value<String> reminderType,
  Value<int> reminderOffsetMinutes,
  Value<String> alarmSound,
  Value<bool> vibrate,
  Value<bool> enableAlarm,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ScheduleItemsTableUpdateCompanionBuilder = ScheduleItemsCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String?> description,
  Value<String> startTime,
  Value<String> endTime,
  Value<String> category,
  Value<String> scheduleMode,
  Value<bool> isActive,
  Value<bool> enableNotification,
  Value<int> notifyBeforeMinutes,
  Value<String> reminderType,
  Value<int> reminderOffsetMinutes,
  Value<String> alarmSound,
  Value<bool> vibrate,
  Value<bool> enableAlarm,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ScheduleItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ScheduleItemsTable, ScheduleItem> {
  $$ScheduleItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DailyChecklistsTable, List<DailyChecklist>>
      _dailyChecklistsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.dailyChecklists,
              aliasName:
                  'schedule_items__id__daily_checklists__schedule_item_id');

  $$DailyChecklistsTableProcessedTableManager get dailyChecklistsRefs {
    final manager = $$DailyChecklistsTableTableManager(
            $_db, $_db.dailyChecklists)
        .filter((f) => f.scheduleItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_dailyChecklistsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ScheduleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleItemsTable> {
  $$ScheduleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleMode => $composableBuilder(
      column: $table.scheduleMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enableNotification => $composableBuilder(
      column: $table.enableNotification,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notifyBeforeMinutes => $composableBuilder(
      column: $table.notifyBeforeMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderType => $composableBuilder(
      column: $table.reminderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderOffsetMinutes => $composableBuilder(
      column: $table.reminderOffsetMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alarmSound => $composableBuilder(
      column: $table.alarmSound, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get vibrate => $composableBuilder(
      column: $table.vibrate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enableAlarm => $composableBuilder(
      column: $table.enableAlarm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> dailyChecklistsRefs(
      Expression<bool> Function($$DailyChecklistsTableFilterComposer f) f) {
    final $$DailyChecklistsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dailyChecklists,
        getReferencedColumn: (t) => t.scheduleItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyChecklistsTableFilterComposer(
              $db: $db,
              $table: $db.dailyChecklists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ScheduleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleItemsTable> {
  $$ScheduleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleMode => $composableBuilder(
      column: $table.scheduleMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enableNotification => $composableBuilder(
      column: $table.enableNotification,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notifyBeforeMinutes => $composableBuilder(
      column: $table.notifyBeforeMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderType => $composableBuilder(
      column: $table.reminderType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderOffsetMinutes => $composableBuilder(
      column: $table.reminderOffsetMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alarmSound => $composableBuilder(
      column: $table.alarmSound, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get vibrate => $composableBuilder(
      column: $table.vibrate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enableAlarm => $composableBuilder(
      column: $table.enableAlarm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ScheduleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleItemsTable> {
  $$ScheduleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get scheduleMode => $composableBuilder(
      column: $table.scheduleMode, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get enableNotification => $composableBuilder(
      column: $table.enableNotification, builder: (column) => column);

  GeneratedColumn<int> get notifyBeforeMinutes => $composableBuilder(
      column: $table.notifyBeforeMinutes, builder: (column) => column);

  GeneratedColumn<String> get reminderType => $composableBuilder(
      column: $table.reminderType, builder: (column) => column);

  GeneratedColumn<int> get reminderOffsetMinutes => $composableBuilder(
      column: $table.reminderOffsetMinutes, builder: (column) => column);

  GeneratedColumn<String> get alarmSound => $composableBuilder(
      column: $table.alarmSound, builder: (column) => column);

  GeneratedColumn<bool> get vibrate =>
      $composableBuilder(column: $table.vibrate, builder: (column) => column);

  GeneratedColumn<bool> get enableAlarm => $composableBuilder(
      column: $table.enableAlarm, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> dailyChecklistsRefs<T extends Object>(
      Expression<T> Function($$DailyChecklistsTableAnnotationComposer a) f) {
    final $$DailyChecklistsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dailyChecklists,
        getReferencedColumn: (t) => t.scheduleItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyChecklistsTableAnnotationComposer(
              $db: $db,
              $table: $db.dailyChecklists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ScheduleItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScheduleItemsTable,
    ScheduleItem,
    $$ScheduleItemsTableFilterComposer,
    $$ScheduleItemsTableOrderingComposer,
    $$ScheduleItemsTableAnnotationComposer,
    $$ScheduleItemsTableCreateCompanionBuilder,
    $$ScheduleItemsTableUpdateCompanionBuilder,
    (ScheduleItem, $$ScheduleItemsTableReferences),
    ScheduleItem,
    PrefetchHooks Function({bool dailyChecklistsRefs})> {
  $$ScheduleItemsTableTableManager(_$AppDatabase db, $ScheduleItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> startTime = const Value.absent(),
            Value<String> endTime = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> scheduleMode = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> enableNotification = const Value.absent(),
            Value<int> notifyBeforeMinutes = const Value.absent(),
            Value<String> reminderType = const Value.absent(),
            Value<int> reminderOffsetMinutes = const Value.absent(),
            Value<String> alarmSound = const Value.absent(),
            Value<bool> vibrate = const Value.absent(),
            Value<bool> enableAlarm = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ScheduleItemsCompanion(
            id: id,
            title: title,
            description: description,
            startTime: startTime,
            endTime: endTime,
            category: category,
            scheduleMode: scheduleMode,
            isActive: isActive,
            enableNotification: enableNotification,
            notifyBeforeMinutes: notifyBeforeMinutes,
            reminderType: reminderType,
            reminderOffsetMinutes: reminderOffsetMinutes,
            alarmSound: alarmSound,
            vibrate: vibrate,
            enableAlarm: enableAlarm,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            required String startTime,
            required String endTime,
            required String category,
            required String scheduleMode,
            Value<bool> isActive = const Value.absent(),
            Value<bool> enableNotification = const Value.absent(),
            Value<int> notifyBeforeMinutes = const Value.absent(),
            Value<String> reminderType = const Value.absent(),
            Value<int> reminderOffsetMinutes = const Value.absent(),
            Value<String> alarmSound = const Value.absent(),
            Value<bool> vibrate = const Value.absent(),
            Value<bool> enableAlarm = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ScheduleItemsCompanion.insert(
            id: id,
            title: title,
            description: description,
            startTime: startTime,
            endTime: endTime,
            category: category,
            scheduleMode: scheduleMode,
            isActive: isActive,
            enableNotification: enableNotification,
            notifyBeforeMinutes: notifyBeforeMinutes,
            reminderType: reminderType,
            reminderOffsetMinutes: reminderOffsetMinutes,
            alarmSound: alarmSound,
            vibrate: vibrate,
            enableAlarm: enableAlarm,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ScheduleItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({dailyChecklistsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dailyChecklistsRefs) db.dailyChecklists
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dailyChecklistsRefs)
                    await $_getPrefetchedData<ScheduleItem, $ScheduleItemsTable, DailyChecklist>(
                        currentTable: table,
                        referencedTable: $$ScheduleItemsTableReferences
                            ._dailyChecklistsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ScheduleItemsTableReferences(db, table, p0)
                                .dailyChecklistsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.scheduleItemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ScheduleItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScheduleItemsTable,
    ScheduleItem,
    $$ScheduleItemsTableFilterComposer,
    $$ScheduleItemsTableOrderingComposer,
    $$ScheduleItemsTableAnnotationComposer,
    $$ScheduleItemsTableCreateCompanionBuilder,
    $$ScheduleItemsTableUpdateCompanionBuilder,
    (ScheduleItem, $$ScheduleItemsTableReferences),
    ScheduleItem,
    PrefetchHooks Function({bool dailyChecklistsRefs})>;
typedef $$DailyChecklistsTableCreateCompanionBuilder = DailyChecklistsCompanion
    Function({
  Value<int> id,
  required int scheduleItemId,
  required String date,
  required String scheduleMode,
  Value<bool> isDone,
  Value<String?> note,
  Value<DateTime?> completedAt,
  required String snapshotTitle,
  Value<String?> snapshotDescription,
  required String snapshotStartTime,
  required String snapshotEndTime,
  required String snapshotCategory,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$DailyChecklistsTableUpdateCompanionBuilder = DailyChecklistsCompanion
    Function({
  Value<int> id,
  Value<int> scheduleItemId,
  Value<String> date,
  Value<String> scheduleMode,
  Value<bool> isDone,
  Value<String?> note,
  Value<DateTime?> completedAt,
  Value<String> snapshotTitle,
  Value<String?> snapshotDescription,
  Value<String> snapshotStartTime,
  Value<String> snapshotEndTime,
  Value<String> snapshotCategory,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$DailyChecklistsTableReferences extends BaseReferences<
    _$AppDatabase, $DailyChecklistsTable, DailyChecklist> {
  $$DailyChecklistsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ScheduleItemsTable _scheduleItemIdTable(_$AppDatabase db) => db
      .scheduleItems
      .createAlias('daily_checklists__schedule_item_id__schedule_items__id');

  $$ScheduleItemsTableProcessedTableManager get scheduleItemId {
    final $_column = $_itemColumn<int>('schedule_item_id')!;

    final manager = $$ScheduleItemsTableTableManager($_db, $_db.scheduleItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DailyChecklistsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyChecklistsTable> {
  $$DailyChecklistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleMode => $composableBuilder(
      column: $table.scheduleMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotTitle => $composableBuilder(
      column: $table.snapshotTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotDescription => $composableBuilder(
      column: $table.snapshotDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotStartTime => $composableBuilder(
      column: $table.snapshotStartTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotEndTime => $composableBuilder(
      column: $table.snapshotEndTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotCategory => $composableBuilder(
      column: $table.snapshotCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ScheduleItemsTableFilterComposer get scheduleItemId {
    final $$ScheduleItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheduleItemId,
        referencedTable: $db.scheduleItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ScheduleItemsTableFilterComposer(
              $db: $db,
              $table: $db.scheduleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyChecklistsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyChecklistsTable> {
  $$DailyChecklistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleMode => $composableBuilder(
      column: $table.scheduleMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotTitle => $composableBuilder(
      column: $table.snapshotTitle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotDescription => $composableBuilder(
      column: $table.snapshotDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotStartTime => $composableBuilder(
      column: $table.snapshotStartTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotEndTime => $composableBuilder(
      column: $table.snapshotEndTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotCategory => $composableBuilder(
      column: $table.snapshotCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ScheduleItemsTableOrderingComposer get scheduleItemId {
    final $$ScheduleItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheduleItemId,
        referencedTable: $db.scheduleItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ScheduleItemsTableOrderingComposer(
              $db: $db,
              $table: $db.scheduleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyChecklistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyChecklistsTable> {
  $$DailyChecklistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get scheduleMode => $composableBuilder(
      column: $table.scheduleMode, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get snapshotTitle => $composableBuilder(
      column: $table.snapshotTitle, builder: (column) => column);

  GeneratedColumn<String> get snapshotDescription => $composableBuilder(
      column: $table.snapshotDescription, builder: (column) => column);

  GeneratedColumn<String> get snapshotStartTime => $composableBuilder(
      column: $table.snapshotStartTime, builder: (column) => column);

  GeneratedColumn<String> get snapshotEndTime => $composableBuilder(
      column: $table.snapshotEndTime, builder: (column) => column);

  GeneratedColumn<String> get snapshotCategory => $composableBuilder(
      column: $table.snapshotCategory, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ScheduleItemsTableAnnotationComposer get scheduleItemId {
    final $$ScheduleItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheduleItemId,
        referencedTable: $db.scheduleItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ScheduleItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.scheduleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyChecklistsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyChecklistsTable,
    DailyChecklist,
    $$DailyChecklistsTableFilterComposer,
    $$DailyChecklistsTableOrderingComposer,
    $$DailyChecklistsTableAnnotationComposer,
    $$DailyChecklistsTableCreateCompanionBuilder,
    $$DailyChecklistsTableUpdateCompanionBuilder,
    (DailyChecklist, $$DailyChecklistsTableReferences),
    DailyChecklist,
    PrefetchHooks Function({bool scheduleItemId})> {
  $$DailyChecklistsTableTableManager(
      _$AppDatabase db, $DailyChecklistsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyChecklistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyChecklistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyChecklistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> scheduleItemId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> scheduleMode = const Value.absent(),
            Value<bool> isDone = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String> snapshotTitle = const Value.absent(),
            Value<String?> snapshotDescription = const Value.absent(),
            Value<String> snapshotStartTime = const Value.absent(),
            Value<String> snapshotEndTime = const Value.absent(),
            Value<String> snapshotCategory = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DailyChecklistsCompanion(
            id: id,
            scheduleItemId: scheduleItemId,
            date: date,
            scheduleMode: scheduleMode,
            isDone: isDone,
            note: note,
            completedAt: completedAt,
            snapshotTitle: snapshotTitle,
            snapshotDescription: snapshotDescription,
            snapshotStartTime: snapshotStartTime,
            snapshotEndTime: snapshotEndTime,
            snapshotCategory: snapshotCategory,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int scheduleItemId,
            required String date,
            required String scheduleMode,
            Value<bool> isDone = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            required String snapshotTitle,
            Value<String?> snapshotDescription = const Value.absent(),
            required String snapshotStartTime,
            required String snapshotEndTime,
            required String snapshotCategory,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DailyChecklistsCompanion.insert(
            id: id,
            scheduleItemId: scheduleItemId,
            date: date,
            scheduleMode: scheduleMode,
            isDone: isDone,
            note: note,
            completedAt: completedAt,
            snapshotTitle: snapshotTitle,
            snapshotDescription: snapshotDescription,
            snapshotStartTime: snapshotStartTime,
            snapshotEndTime: snapshotEndTime,
            snapshotCategory: snapshotCategory,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DailyChecklistsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({scheduleItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (scheduleItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.scheduleItemId,
                    referencedTable: $$DailyChecklistsTableReferences
                        ._scheduleItemIdTable(db),
                    referencedColumn: $$DailyChecklistsTableReferences
                        ._scheduleItemIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DailyChecklistsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyChecklistsTable,
    DailyChecklist,
    $$DailyChecklistsTableFilterComposer,
    $$DailyChecklistsTableOrderingComposer,
    $$DailyChecklistsTableAnnotationComposer,
    $$DailyChecklistsTableCreateCompanionBuilder,
    $$DailyChecklistsTableUpdateCompanionBuilder,
    (DailyChecklist, $$DailyChecklistsTableReferences),
    DailyChecklist,
    PrefetchHooks Function({bool scheduleItemId})>;
typedef $$DailyModesTableCreateCompanionBuilder = DailyModesCompanion Function({
  Value<int> id,
  required String date,
  required String scheduleMode,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$DailyModesTableUpdateCompanionBuilder = DailyModesCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<String> scheduleMode,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$DailyModesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyModesTable> {
  $$DailyModesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleMode => $composableBuilder(
      column: $table.scheduleMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DailyModesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyModesTable> {
  $$DailyModesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleMode => $composableBuilder(
      column: $table.scheduleMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DailyModesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyModesTable> {
  $$DailyModesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get scheduleMode => $composableBuilder(
      column: $table.scheduleMode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyModesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyModesTable,
    DailyMode,
    $$DailyModesTableFilterComposer,
    $$DailyModesTableOrderingComposer,
    $$DailyModesTableAnnotationComposer,
    $$DailyModesTableCreateCompanionBuilder,
    $$DailyModesTableUpdateCompanionBuilder,
    (DailyMode, BaseReferences<_$AppDatabase, $DailyModesTable, DailyMode>),
    DailyMode,
    PrefetchHooks Function()> {
  $$DailyModesTableTableManager(_$AppDatabase db, $DailyModesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyModesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyModesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyModesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> scheduleMode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DailyModesCompanion(
            id: id,
            date: date,
            scheduleMode: scheduleMode,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String date,
            required String scheduleMode,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DailyModesCompanion.insert(
            id: id,
            date: date,
            scheduleMode: scheduleMode,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyModesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyModesTable,
    DailyMode,
    $$DailyModesTableFilterComposer,
    $$DailyModesTableOrderingComposer,
    $$DailyModesTableAnnotationComposer,
    $$DailyModesTableCreateCompanionBuilder,
    $$DailyModesTableUpdateCompanionBuilder,
    (DailyMode, BaseReferences<_$AppDatabase, $DailyModesTable, DailyMode>),
    DailyMode,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  required String key,
  required String value,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<int> id,
  Value<String> key,
  Value<String> value,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            id: id,
            key: key,
            value: value,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String key,
            required String value,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            id: id,
            key: key,
            value: value,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScheduleItemsTableTableManager get scheduleItems =>
      $$ScheduleItemsTableTableManager(_db, _db.scheduleItems);
  $$DailyChecklistsTableTableManager get dailyChecklists =>
      $$DailyChecklistsTableTableManager(_db, _db.dailyChecklists);
  $$DailyModesTableTableManager get dailyModes =>
      $$DailyModesTableTableManager(_db, _db.dailyModes);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
