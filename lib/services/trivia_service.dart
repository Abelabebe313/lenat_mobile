import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/services/graphql_service.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/models/trivia_model.dart';
import 'package:lenat_mobile/models/question_model.dart';
import 'package:lenat_mobile/app/service_locator.dart';

class TriviaService {
  static final _authService = locator<AuthService>();

  static Future<List<TriviaModel>> getAllTrivia() async {
    try {
      final client = await GraphQLService.getUnauthenticatedClient();
      const query = r'''
        query GetAllTrivia {
          game_trivia {
            created_at
            description
            id
            index
            name
            questions {
              id
            }
          }
        }
      ''';

      final result = await client.query(QueryOptions(document: gql(query)));

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Failed to fetch trivia data');
      }
      print('Trivia data: ${result.data}');

      final triviaList = result.data?['game_trivia'] as List<dynamic>?;
      if (triviaList != null) {
        return triviaList
            .map((trivia) => TriviaModel.fromJson(trivia))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error fetching trivia data: $e');
      rethrow;
    }
  }

  static Future<List<QuestionModel>> getTriviaQuestions(String triviaId) async {
    try {
      final client = await GraphQLService.getUnauthenticatedClient();
      const query = r'''
        query GetTriviaQuestion($triviaId: uuid!) {
          game_trivia(where: {id: {_eq: $triviaId}}) {
            questions {
              answer
              content
              explanation
              hint
              id
              options
              trivia_id
            }
          }
        }
      ''';

      final result = await client.query(
        QueryOptions(
          document: gql(query),
          variables: {'triviaId': triviaId},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Failed to fetch trivia questions');
      }
      print('Trivia questions data: ${result.data}');

      final triviaData = result.data?['game_trivia'] as List<dynamic>?;
      if (triviaData != null && triviaData.isNotEmpty) {
        final questionsData = triviaData.first['questions'] as List<dynamic>?;
        if (questionsData != null) {
          return questionsData
              .map((question) => QuestionModel.fromJson(question))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error fetching trivia questions: $e');
      rethrow;
    }
  }
}
