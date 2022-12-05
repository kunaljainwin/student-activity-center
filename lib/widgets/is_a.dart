String isA({required int rank}) {
  switch (rank) {
    case 0:
      return "Admin";
    case 1:
      return "Faculty";
    case 2:
      return "Event Coordinator";
    case 3:
      return "Student";
    default:
      return "Unknown";
  }
}
