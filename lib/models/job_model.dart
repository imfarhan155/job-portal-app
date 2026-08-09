class JobModel {
  final String jobId;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String description;
  final String requirements;
  final String employerId;
  final DateTime deadline;
  final DateTime createdAt;

  const JobModel({
    required this.jobId,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.description,
    required this.requirements,
    required this.employerId,
    required this.deadline,
    required this.createdAt,
  });

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      jobId: map["jobId"] ?? "",
      title: map["title"] ?? "",
      company: map["company"] ?? "",
      location: map["location"] ?? "",
      salary: map["salary"] ?? "",
      description: map["description"] ?? "",
      requirements: map["requirements"] ?? "",
      employerId: map["employerId"] ?? "",
      deadline: DateTime.parse(map["deadline"]),
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "jobId": jobId,
      "title": title,
      "company": company,
      "location": location,
      "salary": salary,
      "description": description,
      "requirements": requirements,
      "employerId": employerId,
      "deadline": deadline.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
    };
  }

  JobModel copyWith({
    String? jobId,
    String? title,
    String? company,
    String? location,
    String? salary,
    String? description,
    String? requirements,
    String? employerId,
    DateTime? deadline,
    DateTime? createdAt,
  }) {
    return JobModel(
      jobId: jobId ?? this.jobId,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      employerId: employerId ?? this.employerId,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
