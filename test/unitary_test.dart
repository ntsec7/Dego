import 'package:flutter_test/flutter_test.dart';
import 'package:dego/funciones/check.dart';
import 'package:dego/models/decision.dart';
import 'package:dego/funciones/functions.dart';
import 'package:dego/models/option.dart';

void main(){

  //EMAIL
  group('Check Email', () {

    final validator = CheckEmail();

    test('Check empty email', () {
      expect(validator.check(''), 'Campo obligatorio');
    });

    test('Check email without @', () {
      expect(validator.check('juangmail'), 'Introduce un email válido');
    });

    test('Check email with @ at the beginning', () {
      expect(validator.check('@juangmail'), 'Introduce un email válido');
    });

    test('Check email with @ at the end', () {
      expect(validator.check('juangmail@'), 'Introduce un email válido');
    });

    test('Check email with more than one @', () {
      expect(validator.check('jua@n@gmail'), 'Introduce un email válido');
    });

    test('Check email without .', () {
      expect(validator.check('juan@gmailcom'), 'Introduce un email válido');
    });

    test('Check email without other characters between @ and .', () {
      expect(validator.check('juan@.gmail'), 'Introduce un email válido');
    });

    test('Check correct email', () {
      expect(validator.check('juan@gmail.com'), isNull);
    });

  });

  //Username
  group('Check Username', () {

    final validator = CheckUsername();

    test('Check empty username', () {
      expect(validator.check(''), 'Campo obligatorio');
    });

    test('Check username with @', () {
      expect(validator.check('@juan'), "El nombre de usuario no puede contener '@' ");
    });

    test('Check correct username', () {
      expect(validator.check('juan'), isNull);
    });

  });

  //Password
  group('Check Password', () {

    final validator = CheckPassword();

    test('Check empty password', () {
      expect(validator.check(''), null);
    });

    test('Check length (8 characters)', () {
      final result = validator.check('1234');
      expect(result, contains('- 8 caracteres'));
    });

    test('Check lower case character', () {
      final result = validator.check('AAAAAAAAAAAA');
      expect(result, contains('- Un carácter en minúscula'));
    });

    test('Check upper case character', () {
      final result = validator.check('bbbbbbbb');
      expect(result, contains('- Un carácter en mayúscula'));
    });
  
    test('Check number', () {
      final result = validator.check('pocoyo');
      expect(result, contains('- Un número'));
    });

    test('Check special character', () {
      final result = validator.check('pocoyo19');
      expect(result, contains('- Un carácter especial'));
    });

    test('Check correct password', () {
      expect(validator.check('FrayPericoYSuBorrico_14'), isNull);
    });

  });

  // MODEL: DECISION
  group('Check Decision Model', (){

    test('Decision.fromMap creates correct object', () {

      final map = {
        'id': '1',
        'id_creator': 'user1',
        'id_group': 'group1',
        'title': 'Película',
        'state': 'vote',
        'options_date': '2026-07-08T12:00:00Z',
        'vote_date': '2026-07-09T18:00:00Z',
        'type': 'ranking',
        'votes': true,
      };

      final decision = Decision.fromMap(map);

      expect(decision.id, '1');
      expect(decision.id_creator, 'user1');
      expect(decision.id_group, 'group1');
      expect(decision.title, 'Película');

      expect(decision.state, DecisionState.vote);
      expect(decision.type, DecisionType.ranking);
      expect(decision.options_date!.toUtc(),DateTime.parse('2026-07-08T12:00:00Z'),);
      expect(decision.vote_date!.toUtc(),DateTime.parse('2026-07-09T18:00:00Z'),);

      expect(decision.votes, true);
    });

    test('State and Type by defect', () {

      final decision = Decision.fromMap({
        'id':'1',
        'id_creator':'u',
        'state':'inventado',
        'type':'otro',
        'votes':false,
      });

      expect(decision.state, DecisionState.draft);
      expect(decision.type, DecisionType.simple);

    });

    test('Optional fields are null by defect', () {

      final decision = Decision.fromMap({
        'id':'1',
        'id_creator':'u',
        'state':'draft',
        'type':'simple',
        'votes':false,
      });

      expect(decision.id_group, isNull);
      expect(decision.options_date, isNull);
      expect(decision.vote_date, isNull);

    });    

    test('Decision.toMap is correct', (){
      
      final decision = Decision(
        id:'1',
        id_creator:'user',
        id_group:'g',
        title:'Película',
        state:DecisionState.vote,
        type:DecisionType.ranking,
        votes:true,
      );

      final map = decision.toMap();

      expect(map['id'], '1');
      expect(map['id_creator'], 'user');
      expect(map['title'], 'Película');
      expect(map['state'], 'vote');
      expect(map['type'], 'ranking');
      expect(map['votes'], true);

    });

  });

  //GETWINNERS
  group('Test function getWinners', (){

    test('Returns winner options', () {

      final options = [
        Option(id: '1', num_votes: 8, id_decision:'1', id_creator:'1', title:'title', type:OptionType.standard),
        Option(id: '2', num_votes: 5, id_decision:'1', id_creator:'1', title:'title', type:OptionType.standard),
        Option(id: '3', num_votes: 8, id_decision:'1', id_creator:'1', title:'title', type:OptionType.standard),
      ];

      final winners = getWinners(options, 8);

      expect(winners, ['1', '3']);
    });

  });

}