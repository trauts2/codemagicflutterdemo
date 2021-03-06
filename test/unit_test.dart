import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sonder/asset_loader.dart';
import 'package:sonder/slideshow/bloc/bloc.dart';

class MockSlideshowBloc extends MockBloc<SlideshowEvent, SlideshowBloc>
    implements SlideshowBloc {}

class MockAssetLoader extends Mock implements AssetLoader {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AssetLoader assetLoader;
  SlideshowBloc slideshowBloc;

  setUp(() {
    assetLoader = MockAssetLoader();
    slideshowBloc = SlideshowBloc(assetLoader);
  });

  blocTest(
    'bloc yields nothing on start',
    build: () async => slideshowBloc,
    wait: const Duration(seconds: 1),
    expect: [],
  );

  group('StartSlideshowEvent', () {
    final mockUint8List = Uint8List.fromList([0, 1, 2, 3]);
    final mockByteData = mockUint8List.buffer.asByteData();

    blocTest(
      'emits [ImageLoadedState]',
      build: () async {
        when(assetLoader.load(any)).thenAnswer((_) async => mockByteData);
        return SlideshowBloc(assetLoader);
      },
      act: (bloc) => bloc.add(StartSlideshowEvent()),
      expect: [ImageLoadedState(mockUint8List)],
    );
  });
}
