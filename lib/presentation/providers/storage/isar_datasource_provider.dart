import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/infrastructure/datasources/isar_datasource.dart';

final isarSingleton = IsarDatasource(); 

final isarDatasourceProvider = Provider<IsarDatasource>((ref) => isarSingleton);
