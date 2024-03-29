
class Game {
  final int id;
  final String name;
  final double? rating;
  final int ageRating;
  final String? image;
  final String? imageId;
  final String summary;
  final DateTime release;
  final List<Genre> genres;
  final List<Company> companies;
  final List<Platform> platforms;
  final Map<String, dynamic> rawString;

  Game({
    required this.id,
    required this.name,
    required this.image,
    required this.imageId,
    required this.ageRating,
    required this.rating,
    required this.summary,
    required this.release,
    required this.genres,
    required this.companies,
    required this.platforms,
    required this.rawString,
  });


  String developer() {
    var developer = companies.where((company) => company.developer);

    return (developer.isNotEmpty)? developer.first.name: "Developer Unlisted";
  }

  List<String> tags () {
    var tags = <String>[];
    tags.addAll(genreList());
    // tags.addAll(platformList());

    return tags;
  }

  List<String> genreList () {
    var genresList = <String>[];
    genres.forEach((genre) => genresList.add(genre.name));
    return genresList;
  }

  List<String> platformList () {
    var platformList = <String>[];
    platforms.forEach((platform) =>  platformList.add(platform.shortestName()));
    return platformList;
  }

  String stringAgeRating() {
    switch(ageRating) {
      case 6:
        return "RP";
      case 7:
        return "EC";
      case 8:
        return "E";
      case 9:
        return "E10";
      case 10:
        return "T";
      case 11:
        return "M";
      case 12:
        return "AO";
      default:
        return "N/A";
    }
  }

  /**
   * sizes are as follows:
   *
   * cover_small
   * screenshot_med
   * cover_big
   * logo_mid
   * screenshot_big
   * screenshot_huge
   * thumb
   * micro
   * 720p
   * 1080p
   *
   *
   *
   */
  // NOTE: I cant figure out where this is being called? If anywhere
  String getImageFromId(String size) {
    return "https://images.igdb.com/igdb/image/upload/t_$size/$imageId.jpg";
  }

  factory Game.fromJson(Map<String, dynamic> json) {

    var genres = List<Genre>.from(json["genres"]?.map((genre) => Genre.fromJson(genre)) ?? <Genre>[]);
    var companies = List<Company>.from(json["involved_companies"]?.map((company) => Company.fromJson(company)) ?? <Company>[]);
    var ageRating = json["age_ratings"]
        .where((areaRating) => (areaRating["category"] == 1))
        .toList().first["rating"];
    var platforms = List<Platform>.from(json["platforms"]?.map((platform) => Platform.fromJson(platform))?? <Platform>[]);

    return Game(
        id: json['id'],
        name: json["name"],
        image: json["cover"]?["url"],
        imageId: json["cover"]?["image_id"],
        summary: json["summary"] ?? "N/A",
        rating: json["aggregated_rating"],
        ageRating: ageRating,
        release: DateTime.fromMillisecondsSinceEpoch(json["first_release_date"] ?? 0), //default to base time if no time found
        genres: genres,
        companies: companies,
        platforms: platforms,
        rawString: json, // in theory this is what we need to pass to firestore
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json["id"], name: json["name"]);
  }

}

class Company {
  final int id;
  final String name;
  final bool developer;

  Company({required this.id, required this.name, required this.developer});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        id: json["company"]["id"],
        name: json["company"]["name"],
        developer: json["developer"]
    );
  }
}

class Platform {
  final int id;
  final String? abbr;
  final String name;
  final String? platformFamily;

  String shortestName() {

    return (abbr == null)? name: abbr!;
  }

  Platform({required this.id, required this.name, required this.abbr, required this.platformFamily});

  factory Platform.fromJson(Map<String, dynamic> json) {
    return Platform(
        id: json["id"],
        name: json["name"],
        abbr: json["abbreviation"],
        platformFamily: json["platform_family"]?["name"],
    );
  }
}
