///
//  Generated code. Do not modify.
//  source: app.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class KnownDevicesState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'KnownDevicesState', createEmptyInstance: create)
    ..pc<KnownDevice>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'devices', $pb.PbFieldType.PM, subBuilder: KnownDevice.create)
    ..hasRequiredFields = false
  ;

  KnownDevicesState._() : super();
  factory KnownDevicesState({
    $core.Iterable<KnownDevice>? devices,
  }) {
    final _result = create();
    if (devices != null) {
      _result.devices.addAll(devices);
    }
    return _result;
  }
  factory KnownDevicesState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KnownDevicesState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  KnownDevicesState clone() => KnownDevicesState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  KnownDevicesState copyWith(void Function(KnownDevicesState) updates) => super.copyWith((message) => updates(message as KnownDevicesState)) as KnownDevicesState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static KnownDevicesState create() => KnownDevicesState._();
  KnownDevicesState createEmptyInstance() => create();
  static $pb.PbList<KnownDevicesState> createRepeated() => $pb.PbList<KnownDevicesState>();
  @$core.pragma('dart2js:noInline')
  static KnownDevicesState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KnownDevicesState>(create);
  static KnownDevicesState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<KnownDevice> get devices => $_getList(0);
}

class KnownDevice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'KnownDevice', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'remoteId', protoName: 'remoteId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'remoteName', protoName: 'remoteName')
    ..hasRequiredFields = false
  ;

  KnownDevice._() : super();
  factory KnownDevice({
    $core.String? name,
    $core.String? remoteId,
    $core.String? remoteName,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (remoteId != null) {
      _result.remoteId = remoteId;
    }
    if (remoteName != null) {
      _result.remoteName = remoteName;
    }
    return _result;
  }
  factory KnownDevice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory KnownDevice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  KnownDevice clone() => KnownDevice()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  KnownDevice copyWith(void Function(KnownDevice) updates) => super.copyWith((message) => updates(message as KnownDevice)) as KnownDevice; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static KnownDevice create() => KnownDevice._();
  KnownDevice createEmptyInstance() => create();
  static $pb.PbList<KnownDevice> createRepeated() => $pb.PbList<KnownDevice>();
  @$core.pragma('dart2js:noInline')
  static KnownDevice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KnownDevice>(create);
  static KnownDevice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get remoteId => $_getSZ(1);
  @$pb.TagNumber(2)
  set remoteId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRemoteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemoteId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get remoteName => $_getSZ(2);
  @$pb.TagNumber(3)
  set remoteName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRemoteName() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemoteName() => clearField(3);
}

