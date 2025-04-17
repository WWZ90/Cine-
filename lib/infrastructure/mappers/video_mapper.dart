import 'package:cinemania/domain/entities/video.dart' as domain;
import 'package:cinemania/infrastructure/models/video/video_videodb.dart' as model;

class VideoMapper {
  static domain.Video videoToEntity(model.VideoVideoDB video) => domain.Video(
    id: video.id,
    key: video.key,
    name: video.name,
    site: _mapSite(video.site),
    type: _mapType(video.type),
    iso6391: _mapIso6391(video.iso6391),
    iso31661: _mapIso31661(video.iso31661),
    size: video.size,
    official: video.official,
    publishedAt: video.publishedAt,
  );

  static domain.Site _mapSite(model.Site site) {
    switch (site) {
      case model.Site.YOU_TUBE:
        return domain.Site.YOU_TUBE;
    }
  }

  static domain.Type _mapType(model.Type type) {
    switch (type) {
      case model.Type.BEHIND_THE_SCENES:
        return domain.Type.BEHIND_THE_SCENES;
      case model.Type.CLIP:
        return domain.Type.CLIP;
      case model.Type.FEATURETTE:
        return domain.Type.FEATURETTE;
      case model.Type.TEASER:
        return domain.Type.TEASER;
      case model.Type.TRAILER:
        return domain.Type.TRAILER;
    }
  }

  static domain.Iso6391 _mapIso6391(model.Iso6391 iso) {
    switch (iso) {
      case model.Iso6391.EN:
        return domain.Iso6391.EN;
    }
  }

  static domain.Iso31661 _mapIso31661(model.Iso31661 iso) {
    switch (iso) {
      case model.Iso31661.US:
        return domain.Iso31661.US;
    }
  }
}
