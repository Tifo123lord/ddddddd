
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/data/country_data.dart';
import 'package:flutter_app/data/country_leaders.dart';

void main() {
  group('Country leaders', () {
    test('every playable nation has a complete leadership roster', () {
      for (final country in CountryData.build()) {
        final leaders = CountryLeaders.of(country.id);

        expect(
          leaders,
          isNotEmpty,
          reason: 'No leadership roster found for ${country.id}',
        );

        final roles = leaders.map((leader) => leader.role).toSet();

        expect(
          roles,
          contains(LeaderRole.headOfState),
          reason: 'Missing head of state for ${country.id}',
        );

        expect(
          roles,
          contains(LeaderRole.foreignMinister),
          reason: 'Missing foreign minister for ${country.id}',
        );

        expect(
          roles,
          contains(LeaderRole.defenceMinister),
          reason: 'Missing defence minister for ${country.id}',
        );

        expect(
          roles,
          contains(LeaderRole.chiefOfDefence),
          reason: 'Missing chief of defence for ${country.id}',
        );

        expect(
          CountryLeaders.paramount(country.id),
          isNotNull,
          reason: 'Missing paramount leader for ${country.id}',
        );

        for (final leader in leaders) {
          expect(
            leader.nameEn.trim(),
            isNotEmpty,
            reason: 'Empty English name for ${country.id}',
          );

          expect(
            leader.nameFa.trim(),
            isNotEmpty,
            reason: 'Empty Persian name for ${country.id}',
          );

          expect(
            leader.titleFa.trim(),
            isNotEmpty,
            reason: 'Empty Persian title for ${leader.nameEn}',
          );

          if (leader.since != null) {
            expect(
              leader.sinceDate,
              isNotNull,
              reason: 'Invalid since date for ${leader.nameEn}: '
                  '${leader.since}',
            );
          }
        }
      }
    });

    test('every referenced portrait is bundled', () {
      final missingPortraits = CountryLeaders.allPortraits
          .where((path) => !File(path).existsSync())
          .toList();

      if (missingPortraits.isNotEmpty) {
        print('\n===== MISSING LEADER PORTRAITS =====');

        for (final path in missingPortraits) {
          print('MISSING: $path');
        }

        print('===== END MISSING PORTRAITS =====\n');
      }

      expect(
        missingPortraits,
        isEmpty,
        reason: 'The following leader portrait files are missing:\n'
            '${missingPortraits.join('\n')}',
      );
    });

    test('Iran lists the Supreme Leader as paramount', () {
      final leader = CountryLeaders.paramount('ir');

      expect(leader, isNotNull);
      expect(leader!.role, LeaderRole.supremeLeader);
    });
  });
}
