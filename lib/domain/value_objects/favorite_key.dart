class FavoriteKey {
  final int id;
  final String type; // 'Movie' - 'TVShow' - 'Person'
  const FavoriteKey(this.id, this.type);

  @override
  bool operator ==(Object other) =>
      other is FavoriteKey && other.id == id && other.type == type;

  @override
  int get hashCode => Object.hash(id, type);
}
