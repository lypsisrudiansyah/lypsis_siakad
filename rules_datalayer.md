---
# 📦 Data Layer Rule (Clean Architecture - Feature First)

## 🎯 Purpose

Handles **external data access** (API/DB/storage), maps raw data to **Models**, and implements **domain repository interfaces**.

---

## ✅ Responsibilities

* Convert raw data → `Model`
* Implement domain `Repository` interface
* Return `Either<Failure, Model>`
* Map exceptions → `Failure`
* Create Datasource Class Abstraction and Impl

---

## 📂 Structure

```
feature/
└── user/
    └── data/
        ├── models/user_model.dart
        ├── datasources/user_remote_datasource.dart
        └── repositories/user_repository_impl.dart
```

---

## 🔍 Example

### Repository:

```dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      final result = await remote.getUserProfile();
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

### Model:

```dart
class UserModel {
  final String name, email;

  UserModel({required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(name: json['name'], email: json['email']);

  User toEntity() => User(name: name, email: email);
}
```

---

## ⚠️ Avoid

* ❌ Using domain `Entity` in data layer
* ❌ Business/UI logic here
* ❌ Unhandled exceptions

---

## ✅ TL;DR

| ✅ Do                            | ❌ Don't             |
| ------------------------------- | ------------------- |
| Return `Either<Failure, Model>` | Return raw API data |
| Map Model → Entity              | Use Entity in model |
| Handle & map errors             | Let errors bubble   |

---