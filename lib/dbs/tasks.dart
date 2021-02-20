class Tasks {
  // ignore: non_constant_identifier_names
  String task_name;
  int striked;

  Tasks(String name) {
    this.task_name = name;
    striked = 0;
  }

  Tasks.withstrike(String name, int strike) {
    task_name = name;
    striked = strike;
  }

  factory Tasks.fromMap(Map<String, dynamic> data) {
    return Tasks.withstrike(data['task'], data['strike']);
  }

  Map<String, dynamic> toMap() => {'task': task_name, 'strike': striked};
}
