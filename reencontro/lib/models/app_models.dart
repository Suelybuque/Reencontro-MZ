class VolunteerProfile {
  const VolunteerProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;

  factory VolunteerProfile.fromMap(String id, Map<String, dynamic> map) {
    return VolunteerProfile(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'phone': phone, 'photoUrl': photoUrl};
  }
}

class MissingPersonCase {
  const MissingPersonCase({
    required this.id,
    required this.name,
    required this.age,
    required this.status,
    required this.location,
    required this.lastSeen,
    required this.description,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String age;
  final String status;
  final String location;
  final String lastSeen;
  final String description;
  final String imageUrl;

  factory MissingPersonCase.fromMap(String id, Map<String, dynamic> map) {
    return MissingPersonCase(
      id: id,
      name: map['name'] as String? ?? '',
      age: map['age'] as String? ?? '',
      status: map['status'] as String? ?? 'missing',
      location: map['location'] as String? ?? '',
      lastSeen: map['lastSeen'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }
}

class SupportCenter {
  const SupportCenter({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.distanceLabel,
    required this.status,
    required this.capacity,
    required this.occupancy,
    required this.latitude,
    required this.longitude,
    required this.description,
  });

  final String id;
  final String name;
  final String category;
  final String address;
  final String distanceLabel;
  final String status;
  final int capacity;
  final int occupancy;
  final double latitude;
  final double longitude;
  final String description;

  factory SupportCenter.fromMap(String id, Map<String, dynamic> map) {
    return SupportCenter(
      id: id,
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      address: map['address'] as String? ?? '',
      distanceLabel: map['distanceLabel'] as String? ?? '',
      status: map['status'] as String? ?? '',
      capacity: (map['capacity'] as num?)?.toInt() ?? 0,
      occupancy: (map['occupancy'] as num?)?.toInt() ?? 0,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      description: map['description'] as String? ?? '',
    );
  }
}

class UpdateItem {
  const UpdateItem({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.timeAgo,
    required this.imageUrl,
    required this.details,
  });

  final String id;
  final String name;
  final String location;
  final String status;
  final String timeAgo;
  final String imageUrl;
  final String details;

  factory UpdateItem.fromMap(String id, Map<String, dynamic> map) {
    return UpdateItem(
      id: id,
      name: map['name'] as String? ?? '',
      location: map['location'] as String? ?? '',
      status: map['status'] as String? ?? '',
      timeAgo: map['timeAgo'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      details: map['details'] as String? ?? '',
    );
  }
}
