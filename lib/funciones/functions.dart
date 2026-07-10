List<String> getWinners(List<dynamic> sortedOptions, int winnerValue){
  
  List<String> winnersIds = [];
    
    for (var option in sortedOptions) {
      final votes = option.num_votes ?? 0;
      if (votes == winnerValue) {
        winnersIds.add(option.id);
      }
    } 

    return winnersIds;
}