

class Task{
  String? title;
  String? description;
  String? status;
  String? lastUpdatedTime;

  Task({
    this.title, this.description, this.status, this.lastUpdatedTime
  });

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    status = json['status'];
    lastUpdatedTime = json['lastUpdatedTime'];
  }
}

