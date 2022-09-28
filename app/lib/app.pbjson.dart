///
//  Generated code. Do not modify.
//  source: app.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use knownDevicesStateDescriptor instead')
const KnownDevicesState$json = const {
  '1': 'KnownDevicesState',
  '2': const [
    const {'1': 'devices', '3': 1, '4': 3, '5': 11, '6': '.KnownDevice', '10': 'devices'},
  ],
};

/// Descriptor for `KnownDevicesState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List knownDevicesStateDescriptor = $convert.base64Decode('ChFLbm93bkRldmljZXNTdGF0ZRImCgdkZXZpY2VzGAEgAygLMgwuS25vd25EZXZpY2VSB2RldmljZXM=');
@$core.Deprecated('Use knownDeviceDescriptor instead')
const KnownDevice$json = const {
  '1': 'KnownDevice',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'remoteId', '3': 2, '4': 1, '5': 9, '10': 'remoteId'},
    const {'1': 'remoteName', '3': 3, '4': 1, '5': 9, '10': 'remoteName'},
  ],
};

/// Descriptor for `KnownDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List knownDeviceDescriptor = $convert.base64Decode('CgtLbm93bkRldmljZRISCgRuYW1lGAEgASgJUgRuYW1lEhoKCHJlbW90ZUlkGAIgASgJUghyZW1vdGVJZBIeCgpyZW1vdGVOYW1lGAMgASgJUgpyZW1vdGVOYW1l');
