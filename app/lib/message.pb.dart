///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

enum Command_Msg {
  progress, 
  move, 
  reset, 
  notSet
}

class Command extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Command_Msg> _Command_MsgByTag = {
    1 : Command_Msg.progress,
    2 : Command_Msg.move,
    3 : Command_Msg.reset,
    0 : Command_Msg.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Command', createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<ProgressCommand>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'progress', subBuilder: ProgressCommand.create)
    ..aOM<MoveMotorCommand>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'move', subBuilder: MoveMotorCommand.create)
    ..aOM<ResetMotorPositionCommand>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'reset', subBuilder: ResetMotorPositionCommand.create)
    ..hasRequiredFields = false
  ;

  Command._() : super();
  factory Command({
    ProgressCommand? progress,
    MoveMotorCommand? move,
    ResetMotorPositionCommand? reset,
  }) {
    final _result = create();
    if (progress != null) {
      _result.progress = progress;
    }
    if (move != null) {
      _result.move = move;
    }
    if (reset != null) {
      _result.reset = reset;
    }
    return _result;
  }
  factory Command.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Command.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Command clone() => Command()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Command copyWith(void Function(Command) updates) => super.copyWith((message) => updates(message as Command)) as Command; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Command create() => Command._();
  Command createEmptyInstance() => create();
  static $pb.PbList<Command> createRepeated() => $pb.PbList<Command>();
  @$core.pragma('dart2js:noInline')
  static Command getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Command>(create);
  static Command? _defaultInstance;

  Command_Msg whichMsg() => _Command_MsgByTag[$_whichOneof(0)]!;
  void clearMsg() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ProgressCommand get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress(ProgressCommand v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => clearField(1);
  @$pb.TagNumber(1)
  ProgressCommand ensureProgress() => $_ensure(0);

  @$pb.TagNumber(2)
  MoveMotorCommand get move => $_getN(1);
  @$pb.TagNumber(2)
  set move(MoveMotorCommand v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMove() => $_has(1);
  @$pb.TagNumber(2)
  void clearMove() => clearField(2);
  @$pb.TagNumber(2)
  MoveMotorCommand ensureMove() => $_ensure(1);

  @$pb.TagNumber(3)
  ResetMotorPositionCommand get reset => $_getN(2);
  @$pb.TagNumber(3)
  set reset(ResetMotorPositionCommand v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasReset() => $_has(2);
  @$pb.TagNumber(3)
  void clearReset() => clearField(3);
  @$pb.TagNumber(3)
  ResetMotorPositionCommand ensureReset() => $_ensure(2);
}

class ProgressCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ProgressCommand', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'progress', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  ProgressCommand._() : super();
  factory ProgressCommand({
    $core.double? progress,
  }) {
    final _result = create();
    if (progress != null) {
      _result.progress = progress;
    }
    return _result;
  }
  factory ProgressCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProgressCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProgressCommand clone() => ProgressCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProgressCommand copyWith(void Function(ProgressCommand) updates) => super.copyWith((message) => updates(message as ProgressCommand)) as ProgressCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProgressCommand create() => ProgressCommand._();
  ProgressCommand createEmptyInstance() => create();
  static $pb.PbList<ProgressCommand> createRepeated() => $pb.PbList<ProgressCommand>();
  @$core.pragma('dart2js:noInline')
  static ProgressCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProgressCommand>(create);
  static ProgressCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => clearField(1);
}

class MoveMotorCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MoveMotorCommand', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'target', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  MoveMotorCommand._() : super();
  factory MoveMotorCommand({
    $core.int? target,
  }) {
    final _result = create();
    if (target != null) {
      _result.target = target;
    }
    return _result;
  }
  factory MoveMotorCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MoveMotorCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MoveMotorCommand clone() => MoveMotorCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MoveMotorCommand copyWith(void Function(MoveMotorCommand) updates) => super.copyWith((message) => updates(message as MoveMotorCommand)) as MoveMotorCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MoveMotorCommand create() => MoveMotorCommand._();
  MoveMotorCommand createEmptyInstance() => create();
  static $pb.PbList<MoveMotorCommand> createRepeated() => $pb.PbList<MoveMotorCommand>();
  @$core.pragma('dart2js:noInline')
  static MoveMotorCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MoveMotorCommand>(create);
  static MoveMotorCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get target => $_getIZ(0);
  @$pb.TagNumber(1)
  set target($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => clearField(1);
}

class ResetMotorPositionCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ResetMotorPositionCommand', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'motorIndex', $pb.PbFieldType.O3, protoName: 'motorIndex')
    ..hasRequiredFields = false
  ;

  ResetMotorPositionCommand._() : super();
  factory ResetMotorPositionCommand({
    $core.int? motorIndex,
  }) {
    final _result = create();
    if (motorIndex != null) {
      _result.motorIndex = motorIndex;
    }
    return _result;
  }
  factory ResetMotorPositionCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResetMotorPositionCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResetMotorPositionCommand clone() => ResetMotorPositionCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResetMotorPositionCommand copyWith(void Function(ResetMotorPositionCommand) updates) => super.copyWith((message) => updates(message as ResetMotorPositionCommand)) as ResetMotorPositionCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ResetMotorPositionCommand create() => ResetMotorPositionCommand._();
  ResetMotorPositionCommand createEmptyInstance() => create();
  static $pb.PbList<ResetMotorPositionCommand> createRepeated() => $pb.PbList<ResetMotorPositionCommand>();
  @$core.pragma('dart2js:noInline')
  static ResetMotorPositionCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResetMotorPositionCommand>(create);
  static ResetMotorPositionCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get motorIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set motorIndex($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMotorIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearMotorIndex() => clearField(1);
}

class MotorStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MotorStatus', createEmptyInstance: create)
    ..p<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.K3)
    ..hasRequiredFields = false
  ;

  MotorStatus._() : super();
  factory MotorStatus({
    $core.Iterable<$core.int>? status,
  }) {
    final _result = create();
    if (status != null) {
      _result.status.addAll(status);
    }
    return _result;
  }
  factory MotorStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MotorStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MotorStatus clone() => MotorStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MotorStatus copyWith(void Function(MotorStatus) updates) => super.copyWith((message) => updates(message as MotorStatus)) as MotorStatus; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MotorStatus create() => MotorStatus._();
  MotorStatus createEmptyInstance() => create();
  static $pb.PbList<MotorStatus> createRepeated() => $pb.PbList<MotorStatus>();
  @$core.pragma('dart2js:noInline')
  static MotorStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MotorStatus>(create);
  static MotorStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get status => $_getList(0);
}

