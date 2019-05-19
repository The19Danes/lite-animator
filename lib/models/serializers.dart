library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:lite_animator/models/touch_location.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'models.dart';

part 'serializers.g.dart';

@SerializersFor([
  Stroke,
  TouchLocation,
])
final Serializers serializers = (_$serializers.toBuilder()
  ..addBuilderFactory(  // add this builder factory
      FullType(BuiltList,  [ FullType(Stroke)]),
          () => ListBuilder<Stroke>())
  ..addBuilderFactory(
      FullType(BuiltList,  [ FullType(BuiltList, [FullType(Stroke)] )]),
          () => ListBuilder<BuiltList<Stroke>>())
  ..addPlugin(StandardJsonPlugin()))
    .build();