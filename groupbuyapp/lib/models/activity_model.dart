class Activity {
  final String website;
  final bool isOrganiser;
  final DateTime time;
  final String originator; // from who did this activity come from?
  final String status;

  Activity(this.website, this.isOrganiser, this.time, this.originator, this.status);

}