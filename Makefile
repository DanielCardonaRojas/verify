test:
	dart test

publish:
	dart pub publish

# Install test_coverage package globally
coverage:
	dart test
	test_coverage
	lcov --remove coverage/lcov.info 'lib/*/*.freezed.dart' 'lib/*/*.g.dart' 'lib/*/*.part.dart' 'lib/generated/*.dart' 'lib/generated/*/*.dart'
