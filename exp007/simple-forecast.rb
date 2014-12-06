require 'csv'

def get_simple_forecast
    rn = rand()
    if rn <= 0.48
        "DEFENDER"
    else
        "MIDFIELDER"
    end
end 

good_simple = 0
good_random = 0
positions = %w(DEFENDER MIDFIELDER FORWARD GOALKEEPER)

CSV.open("player-stats.csv").each do |row|
    position = row[30]
    forecast = get_simple_forecast
    if position.eql? forecast
        puts "SIMPLE OK"
        good_simple += 1
    else
        puts "SIMPLE NOK #{ position } #{ forecast }"
    end

    random_forecast = positions[rand(3)]
    if position.eql? random_forecast
        puts "RANDOM OK"
        good_random += 1
    else
        puts "RANDOM NOK #{ position } #{ forecast }"
    end
end

puts good_simple.to_f / 1800
puts good_random.to_f / 1800
