require 'json'
file = Rails.root.join('db', 'seeds', 'candidates.json')
data = JSON.parse(File.read(file))

puts "Deleting all candidates"

Candidate.delete_all

puts "Candidates deleted!"

data.each do |c|
  Candidate.create!(
    name: c["name"],
    title: c["title"],
    location: c["location"],
    availability: c["availability"],
    salary_expectation_eur: c["salaryExpectationEur"],
    years_exp: c["yearsExp"],
    skills: c["skills"] || [],
    languages: c["languages"] || []
  )
end

puts "Candidates created"
