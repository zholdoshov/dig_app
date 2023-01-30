enum TaskRelation {
  SubTask(" is subtask of "),
  ParentTask(" is parent of "),
  Clones(" clones "),
  Cloned(" is cloned by "),
  Blocked(" is blocked by "),
  Blocks(" blocks "),
  Alternative(" is alternative to "),
  Related(" is related to ");

  // can add more properties or getters/methods if needed
  final String value;

  // can use named parameters if you want
  const TaskRelation(this.value);
}

extension TaskRelationExtension on TaskRelation {
  TaskRelation get relationOpposite {
    switch (this) {
      case TaskRelation.SubTask:
        return TaskRelation.ParentTask;
      case TaskRelation.ParentTask:
        return TaskRelation.SubTask;
      case TaskRelation.Clones:
        return TaskRelation.Cloned;
      case TaskRelation.Cloned:
        return TaskRelation.Clones;
      case TaskRelation.Blocked:
        return TaskRelation.Blocks;
      case TaskRelation.Blocks:
        return TaskRelation.Blocked;
      case TaskRelation.Alternative:
        return TaskRelation.Alternative;
      case TaskRelation.Related:
        return TaskRelation.Related;
      default:
        throw new Exception("There's no opposite relation for " +  this.value);
    }
  }
}