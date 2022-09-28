///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use commandDescriptor instead')
const Command$json = const {
  '1': 'Command',
  '2': const [
    const {'1': 'progress', '3': 1, '4': 1, '5': 11, '6': '.ProgressCommand', '9': 0, '10': 'progress'},
    const {'1': 'move', '3': 2, '4': 1, '5': 11, '6': '.MoveMotorCommand', '9': 0, '10': 'move'},
    const {'1': 'reset', '3': 3, '4': 1, '5': 11, '6': '.ResetMotorPositionCommand', '9': 0, '10': 'reset'},
  ],
  '8': const [
    const {'1': 'msg'},
  ],
};

/// Descriptor for `Command`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandDescriptor = $convert.base64Decode('CgdDb21tYW5kEi4KCHByb2dyZXNzGAEgASgLMhAuUHJvZ3Jlc3NDb21tYW5kSABSCHByb2dyZXNzEicKBG1vdmUYAiABKAsyES5Nb3ZlTW90b3JDb21tYW5kSABSBG1vdmUSMgoFcmVzZXQYAyABKAsyGi5SZXNldE1vdG9yUG9zaXRpb25Db21tYW5kSABSBXJlc2V0QgUKA21zZw==');
@$core.Deprecated('Use progressCommandDescriptor instead')
const ProgressCommand$json = const {
  '1': 'ProgressCommand',
  '2': const [
    const {'1': 'progress', '3': 1, '4': 1, '5': 2, '10': 'progress'},
  ],
};

/// Descriptor for `ProgressCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List progressCommandDescriptor = $convert.base64Decode('Cg9Qcm9ncmVzc0NvbW1hbmQSGgoIcHJvZ3Jlc3MYASABKAJSCHByb2dyZXNz');
@$core.Deprecated('Use moveMotorCommandDescriptor instead')
const MoveMotorCommand$json = const {
  '1': 'MoveMotorCommand',
  '2': const [
    const {'1': 'target', '3': 1, '4': 1, '5': 5, '10': 'target'},
  ],
};

/// Descriptor for `MoveMotorCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveMotorCommandDescriptor = $convert.base64Decode('ChBNb3ZlTW90b3JDb21tYW5kEhYKBnRhcmdldBgBIAEoBVIGdGFyZ2V0');
@$core.Deprecated('Use resetMotorPositionCommandDescriptor instead')
const ResetMotorPositionCommand$json = const {
  '1': 'ResetMotorPositionCommand',
  '2': const [
    const {'1': 'motorIndex', '3': 1, '4': 1, '5': 5, '10': 'motorIndex'},
  ],
};

/// Descriptor for `ResetMotorPositionCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetMotorPositionCommandDescriptor = $convert.base64Decode('ChlSZXNldE1vdG9yUG9zaXRpb25Db21tYW5kEh4KCm1vdG9ySW5kZXgYASABKAVSCm1vdG9ySW5kZXg=');
