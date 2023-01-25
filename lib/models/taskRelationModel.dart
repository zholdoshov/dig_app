enum TaskRelation {
  SubTask(" is subtask of "),
  Clones(" is cloned by "),
  Blocked(" is blocked by "),
  Alternative(" is alternative to "),
  Related(" is related to ");

  // can add more properties or getters/methods if needed
  final String value;

  // can use named parameters if you want
  const TaskRelation(this.value);
}