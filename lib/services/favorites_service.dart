import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

class FavoritesService {
  static const String _key = 'favorite_events';
  final _logger = Logger('FavoritesService');

  Future<Set<String>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_key);
      if (favoritesJson == null) return {};

      final List<dynamic> favoritesList = json.decode(favoritesJson);
      return Set<String>.from(favoritesList);
    } catch (error) {
      _logger.severe('Erro ao carregar favoritos', error);
      return {};
    }
  }

  Future<bool> toggleFavorite(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      if (favorites.contains(eventId)) {
        favorites.remove(eventId);
      } else {
        favorites.add(eventId);
      }

      await prefs.setString(_key, json.encode(favorites.toList()));
      return true;
    } catch (error) {
      _logger.severe('Erro ao salvar favorito', error);
      return false;
    }
  }
}
