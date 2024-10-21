import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_career_model.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_company_model.dart';
import 'package:showwcase_v3/features/roadmaps/data/models/roadmap_salary_model.dart';

class RoadmapInfoModel {
  RoadmapCompanyModel? jobs;
  String? title;
  RoadmapsCareerModel? career;
  RoadmapSalaryModel? salary;
  List<String>? skills;
  RoadmapCompanyModel? company;
  List<dynamic>? reviews;
  String? language;
  String? sourceUrl;
  String? difficulty;
  String? description;

  RoadmapInfoModel({
    this.jobs,
    this.title,
    this.career,
    this.salary,
    this.skills,
    this.company,
    this.reviews,
    this.language,
    this.sourceUrl,
    this.difficulty,
    this.description,
  });

  factory RoadmapInfoModel.fromJson(Map<String, dynamic> json) => RoadmapInfoModel(
    jobs: json["jobs"] == null ? null : RoadmapCompanyModel.fromJson(json["jobs"]),
    title: json["title"],
    career: json["career"] == null ? null : RoadmapsCareerModel.fromJson(json["career"]),
    salary: json["salary"] == null ? null : RoadmapSalaryModel.fromJson(json["salary"]),
    skills: json["skills"] == null ? [] : List<String>.from(json["skills"]!.map((x) => x)),
    company: json["company"] == null ? null : RoadmapCompanyModel.fromJson(json["company"]),
    reviews: json["reviews"] == null ? [] : List<dynamic>.from(json["reviews"]!.map((x) => x)),
    language: json["language"],
    sourceUrl: json["sourceUrl"],
    difficulty: json["difficulty"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "jobs": jobs?.toJson(),
    "title": title,
    "career": career?.toJson(),
    "salary": salary?.toJson(),
    "skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
    "company": company?.toJson(),
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x)),
    "language": language,
    "sourceUrl": sourceUrl,
    "difficulty": difficulty,
    "description": description,
  };
}