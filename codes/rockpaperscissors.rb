class RockPaperScissors
  # Exceptions this class can raise:$
  class NoSuchStrategyError < StandardError ; end
  @@size = 0

  def self.winner(player1, player2)
    validate_player(player1)
    validate_player(player2)

    return player1 if player1[1] == player2[1]
    p1, p2 = player1[1].upcase, player2[1].upcase

    return player1 if (p1 == 'R' && p2 == 'S') || (p1 == 'P' && p2 == 'R') || (p1 == 'S' && p2 == 'P')
    return player2 if (p2 == 'R' && p1 == 'S') || (p2 == 'P' && p1 == 'R') || (p2 == 'S' && p1 == 'P')
  end

  def self.validate_player(p)
    if (p.nil? || p[1].nil? || !p[1].is_a?(String) || p[1].length != 1 || (p[1]=~/R|S|P/).nil?)
      raise NoSuchStrategyError, "Strategy must be one of R,P,S"
    end
  end

  def self.tournament_winner(tournament)
    return if !tournament.is_a?(Array)
    if !is_game?(tournament)
      tournament.map! do |k|
	    is_game?(k) ? k = winner(k[0], k[1]) : tournament_winner(k)
	  end
	else tournament = winner(tournament[0], tournament[1]); end;
	
	@@size = 0;
	if get_size(tournament) > 1
	  tournament = tournament_winner (tournament)
	end
	tournament
  end

  def self.get_size(ar)
    return 0 if !ar.is_a?(Array)
    @@size += 1

    ar.each do |i|
      next if !i.is_a?(Array)
      get_size(i)
    end
	@@size
  end

  def self.is_game?(g)
	if g.is_a?(Array) && g.length == 2 && g[0].is_a?(Array) && g[1].is_a?(Array)
		return false if !(g[0].length == 2 && g[0][0].is_a?(String) && g[0][1].is_a?(String))
		return false if !(g[1].length == 2 && g[1][0].is_a?(String) && g[1][1].is_a?(String))
		return true;
	else false; end;
  end
end