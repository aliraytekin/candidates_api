class Candidate < ApplicationRecord
  searchkick word_start: %i[name title location availability salary_expectation_eur
                            years_exp skills languages]

  def search_data
    {
      name: name,
      title: title,
      location: location,
      availability: availability,
      salary_expectation_eur: salary_expectation_eur,
      years_exp: years_exp,
      skills: skills,
      languages: languages
    }
  end
end
