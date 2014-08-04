#!/usr/bin/env ruby

require 'json'
require 'csv'
require 'net/http'

# This is much simpler and quicker than trying to implement a HTTP::Request
# because there are some redirections
player_data = %x{/usr/bin/curl -s "http://www.whoscored.com/stageplayerstatfeed/-1/Overall?field=2&isAscending=false&isMoreThanAvgApps=false&isOverall=true&numberOfPlayersToPick=1800&orderBy=Rating&page=1&stageId=-1&teamId=-1" -H "DNT: 1" -H "Accept-Encoding: gzip,deflate,sdch" -H "Accept: text/plain, */*; q=0.01" -H "Referer: http://www.whoscored.com/Statistics" -H "X-Requested-With: XMLHttpRequest" -H "Connection: keep-alive" --compressed}

players = JSON.parse(player_data)

stats = []

players[1].each do |p|
    stats << p.values
end


cols=%w(AccurateCrosses   AccurateLongBalls AccuratePasses     AccurateThroughBalls 
        AerialLost        AerialWon         Age                Assists 
        DateOfBirth       Dispossesed       Dribbles           FirstName 
        Fouls             GameStarted       Goals              Height 
        Interceptions     IsCurrentPlayer   KeyPasses          KnownName 
        LastName          ManOfTheMatch     Name               Offsides 
        OffsidesWon       OwnGoals          PlayedPositionsRaw PlayerId 
        PositionLong      PositionShort     PositionText       Ranking 
        Rating            Red               RegionCode         SecondYellow 
        ShotsBlocked      ShotsOnTarget     SubOff             SubOn 
        TeamId TeamName   TeamRegionCode    TotalClearances    TotalCrosses 
        TotalLongBalls    TotalPasses       TotalShots         TotalTackles 
        TotalThroughBalls Turnovers         WSName             WasDribbled 
        WasFouled         Weight Yellow ) 

csv = CSV.open("player-stats.csv", 'w')

csv << cols

players[1].each do |player|
    player.reject!{|k,v| k == "Field"}
    player_data = []
    player.keys.sort.each do |k|
        if player[k].is_a? String
          # avoid glitches in the data
          # e.g Obinze Ognonna is labeled as defender instead of Defender
          player_data << player[k].upcase
        else
          player_data << player[k]
        end
    end
    csv << player_data
end

