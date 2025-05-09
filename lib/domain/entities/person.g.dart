// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPersonCollection on Isar {
  IsarCollection<Person> get persons => this.collection();
}

const PersonSchema = CollectionSchema(
  name: r'Person',
  id: 7854610480646705599,
  properties: {
    r'adult': PropertySchema(
      id: 0,
      name: r'adult',
      type: IsarType.bool,
    ),
    r'gender': PropertySchema(
      id: 1,
      name: r'gender',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.long,
    ),
    r'knownForDepartment': PropertySchema(
      id: 3,
      name: r'knownForDepartment',
      type: IsarType.byte,
      enumMap: _PersonknownForDepartmentEnumValueMap,
    ),
    r'mediaType': PropertySchema(
      id: 4,
      name: r'mediaType',
      type: IsarType.byte,
      enumMap: _PersonmediaTypeEnumValueMap,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'originalName': PropertySchema(
      id: 6,
      name: r'originalName',
      type: IsarType.string,
    ),
    r'popularity': PropertySchema(
      id: 7,
      name: r'popularity',
      type: IsarType.double,
    ),
    r'profilePath': PropertySchema(
      id: 8,
      name: r'profilePath',
      type: IsarType.string,
    ),
    r'uniqueID': PropertySchema(
      id: 9,
      name: r'uniqueID',
      type: IsarType.string,
    )
  },
  estimateSize: _personEstimateSize,
  serialize: _personSerialize,
  deserialize: _personDeserialize,
  deserializeProp: _personDeserializeProp,
  idName: r'isarPersonId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _personGetId,
  getLinks: _personGetLinks,
  attach: _personAttach,
  version: '3.1.8',
);

int _personEstimateSize(
  Person object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.originalName.length * 3;
  {
    final value = object.profilePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.uniqueID;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _personSerialize(
  Person object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.adult);
  writer.writeLong(offsets[1], object.gender);
  writer.writeLong(offsets[2], object.id);
  writer.writeByte(offsets[3], object.knownForDepartment.index);
  writer.writeByte(offsets[4], object.mediaType.index);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.originalName);
  writer.writeDouble(offsets[7], object.popularity);
  writer.writeString(offsets[8], object.profilePath);
  writer.writeString(offsets[9], object.uniqueID);
}

Person _personDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Person(
    adult: reader.readBool(offsets[0]),
    gender: reader.readLong(offsets[1]),
    id: reader.readLong(offsets[2]),
    knownForDepartment: _PersonknownForDepartmentValueEnumMap[
            reader.readByteOrNull(offsets[3])] ??
        KnownForDepartment.ACTING,
    mediaType:
        _PersonmediaTypeValueEnumMap[reader.readByteOrNull(offsets[4])] ??
            MediaType.PERSON,
    name: reader.readString(offsets[5]),
    originalName: reader.readString(offsets[6]),
    popularity: reader.readDouble(offsets[7]),
    profilePath: reader.readStringOrNull(offsets[8]),
  );
  object.isarPersonId = id;
  object.uniqueID = reader.readStringOrNull(offsets[9]);
  return object;
}

P _personDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (_PersonknownForDepartmentValueEnumMap[
              reader.readByteOrNull(offset)] ??
          KnownForDepartment.ACTING) as P;
    case 4:
      return (_PersonmediaTypeValueEnumMap[reader.readByteOrNull(offset)] ??
          MediaType.PERSON) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PersonknownForDepartmentEnumValueMap = {
  'ACTING': 0,
  'DIRECTING': 1,
  'SOUND': 2,
  'WRITING': 3,
};
const _PersonknownForDepartmentValueEnumMap = {
  0: KnownForDepartment.ACTING,
  1: KnownForDepartment.DIRECTING,
  2: KnownForDepartment.SOUND,
  3: KnownForDepartment.WRITING,
};
const _PersonmediaTypeEnumValueMap = {
  'PERSON': 0,
};
const _PersonmediaTypeValueEnumMap = {
  0: MediaType.PERSON,
};

Id _personGetId(Person object) {
  return object.isarPersonId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _personGetLinks(Person object) {
  return [];
}

void _personAttach(IsarCollection<dynamic> col, Id id, Person object) {
  object.isarPersonId = id;
}

extension PersonQueryWhereSort on QueryBuilder<Person, Person, QWhere> {
  QueryBuilder<Person, Person, QAfterWhere> anyIsarPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PersonQueryWhere on QueryBuilder<Person, Person, QWhereClause> {
  QueryBuilder<Person, Person, QAfterWhereClause> isarPersonIdEqualTo(
      Id isarPersonId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarPersonId,
        upper: isarPersonId,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> isarPersonIdNotEqualTo(
      Id isarPersonId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarPersonId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(
                  lower: isarPersonId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(
                  lower: isarPersonId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarPersonId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> isarPersonIdGreaterThan(
      Id isarPersonId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarPersonId, includeLower: include),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> isarPersonIdLessThan(
      Id isarPersonId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarPersonId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> isarPersonIdBetween(
    Id lowerIsarPersonId,
    Id upperIsarPersonId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarPersonId,
        includeLower: includeLower,
        upper: upperIsarPersonId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PersonQueryFilter on QueryBuilder<Person, Person, QFilterCondition> {
  QueryBuilder<Person, Person, QAfterFilterCondition> adultEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adult',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> genderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> genderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gender',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> genderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gender',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> genderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> isarPersonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarPersonId',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> isarPersonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarPersonId',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> isarPersonIdEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> isarPersonIdGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> isarPersonIdLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarPersonId',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> isarPersonIdBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarPersonId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> knownForDepartmentEqualTo(
      KnownForDepartment value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'knownForDepartment',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
      knownForDepartmentGreaterThan(
    KnownForDepartment value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'knownForDepartment',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
      knownForDepartmentLessThan(
    KnownForDepartment value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'knownForDepartment',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> knownForDepartmentBetween(
    KnownForDepartment lower,
    KnownForDepartment upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'knownForDepartment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> mediaTypeEqualTo(
      MediaType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> mediaTypeGreaterThan(
    MediaType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaType',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> mediaTypeLessThan(
    MediaType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaType',
        value: value,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> mediaTypeBetween(
    MediaType lower,
    MediaType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> originalNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> originalNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> originalNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> originalNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> originalNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> originalNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> originalNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> originalNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> originalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalName',
        value: '',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> originalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalName',
        value: '',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> popularityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'popularity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> popularityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'popularity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> popularityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'popularity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> popularityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'popularity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'profilePath',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'profilePath',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profilePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profilePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profilePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> profilePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profilePath',
        value: '',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'uniqueID',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'uniqueID',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uniqueID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uniqueID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uniqueID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uniqueID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uniqueID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uniqueID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uniqueID',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uniqueID',
        value: '',
      ));
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> uniqueIDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uniqueID',
        value: '',
      ));
    });
  }
}

extension PersonQueryObject on QueryBuilder<Person, Person, QFilterCondition> {}

extension PersonQueryLinks on QueryBuilder<Person, Person, QFilterCondition> {}

extension PersonQuerySortBy on QueryBuilder<Person, Person, QSortBy> {
  QueryBuilder<Person, Person, QAfterSortBy> sortByAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adult', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByAdultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adult', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByKnownForDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByKnownForDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByOriginalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByOriginalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByPopularityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByProfilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByProfilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByUniqueID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueID', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByUniqueIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueID', Sort.desc);
    });
  }
}

extension PersonQuerySortThenBy on QueryBuilder<Person, Person, QSortThenBy> {
  QueryBuilder<Person, Person, QAfterSortBy> thenByAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adult', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByAdultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adult', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByIsarPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarPersonId', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByIsarPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarPersonId', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByKnownForDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByKnownForDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByOriginalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByOriginalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByPopularityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'popularity', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByProfilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByProfilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByUniqueID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueID', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByUniqueIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uniqueID', Sort.desc);
    });
  }
}

extension PersonQueryWhereDistinct on QueryBuilder<Person, Person, QDistinct> {
  QueryBuilder<Person, Person, QDistinct> distinctByAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adult');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByKnownForDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'knownForDepartment');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaType');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByOriginalName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByPopularity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'popularity');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByProfilePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profilePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByUniqueID(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uniqueID', caseSensitive: caseSensitive);
    });
  }
}

extension PersonQueryProperty on QueryBuilder<Person, Person, QQueryProperty> {
  QueryBuilder<Person, int, QQueryOperations> isarPersonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarPersonId');
    });
  }

  QueryBuilder<Person, bool, QQueryOperations> adultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adult');
    });
  }

  QueryBuilder<Person, int, QQueryOperations> genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<Person, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Person, KnownForDepartment, QQueryOperations>
      knownForDepartmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'knownForDepartment');
    });
  }

  QueryBuilder<Person, MediaType, QQueryOperations> mediaTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaType');
    });
  }

  QueryBuilder<Person, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Person, String, QQueryOperations> originalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalName');
    });
  }

  QueryBuilder<Person, double, QQueryOperations> popularityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'popularity');
    });
  }

  QueryBuilder<Person, String?, QQueryOperations> profilePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profilePath');
    });
  }

  QueryBuilder<Person, String?, QQueryOperations> uniqueIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uniqueID');
    });
  }
}
