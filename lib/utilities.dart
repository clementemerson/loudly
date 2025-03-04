import 'package:loudly/providers/poll_option.dart';

int getTotalVotes(List<PollOption> options) {
  int sum = 0;
  for (PollOption option in options) {
    sum += option.openVotes;
  }
  return sum;
}
