class AuthorDetails {
    final String name;
    final String username;
    final String? avatarPath;
    final double? rating;

    AuthorDetails({
        required this.name,
        required this.username,
        required this.avatarPath,
        required this.rating,
    });

    factory AuthorDetails.fromJson(Map<String, dynamic> json) => AuthorDetails(
        name: json["name"],
        username: json["username"],
        avatarPath: json["avatar_path"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "avatar_path": avatarPath,
        "rating": rating,
    };
}
