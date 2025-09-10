class Api::V1::CandidatesController < ApplicationController
  def index
    where = {}

    query = params[:q].presence || "*"

    where[:location] = params[:location] if params[:location].present?

    if params[:min_exp].present? || params[:max_exp]
      rng = {}

      rng[:gte] = params[:min_exp] if params[:min_exp].present?

      rng[:lte] = params[:max_exp] if params[:max_exp].present?

      where[:years_exp] = rng
    end

    puts params[:skills] if params[:skills].present?

    if params[:skills].present?
      skills = params[:skills].split(",").map(&:strip)
      where[:skills] = { all: skills }
    end

    if params[:languages].present?
      langs = params[:languages].split(",").map(&:downcase)
      where[:languages] = langs
    end

    where[:salary_expectation_eur] = params[:salary_expectation_eur].to_i if params[:salary_expectation_eur].present?

    where[:availability] = params[:availability] if params[:availability].present?

    results = Candidate.search(
      query,
      where: where,
      order: { years_exp: :desc },
      fields: ["name^3", "title^2", "years_exp^2", "location", "skills"],
      match: :word_start,
      misspellings: { below: 3 }
    )

    render json: {
      candidates: results.map { |c| c.as_json(only: %i[id name title location salary_expectation_eur years_exp skills
                                                      languages ]) }
    }
  end
end
