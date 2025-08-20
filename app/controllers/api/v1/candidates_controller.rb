class Api::V1::CandidatesController < ApplicationController
  def index
    candidates = Candidate.all

    if params[:q].present?
      q = "%#{params[:q].downcase}%"
      candidates = candidates.where(
        "LOWER(name) LIKE ? OR LOWER(title) LIKE ? OR EXISTS (
          SELECT 1 FROM unnest(skills) s WHERE LOWER(s) LIKE ?
        )",
        q, q, q
      )
    end

    if params[:location].present?
      loc = "%#{params[:location].downcase}%"
      candidates = candidates.where("LOWER(location) LIKE ?", loc)
    end

    if params[:min_exp].present?
      candidates = candidates.where("years_exp >= ?", params[:min_exp].to_i)
    end

    if params[:max_exp].present?
      candidates = candidates.where("years_exp <= ?", params[:max_exp].to_i)
    end

    if params[:skills].present?
      skills = params[:skills].split(",").map(&:downcase)
      candidates = candidates.where("EXISTS (SELECT 1 FROM unnest(skills) s WHERE LOWER(s) = ANY (ARRAY[?]))", skills)
    end

    if params[:languages].present?
      langs = params[:languages].split(",").map(&:downcase)
      candidates = candidates.where("EXISTS (SELECT 1 FROM unnest(languages) l WHERE LOWER(l) = ANY (ARRAY[?]))", langs)
    end

    if params[:availability].present?
      candidates = candidates.where(availability: params[:availability])
    end

    case params[:sort]
    when "exp"
      candidates = candidates.order(years_exp: :desc)
    when "avb"
      candidates = candidates.order(Arel.sql("CASE availability WHEN 'immediate' THEN 0 WHEN '1-3 months' THEN 1 ELSE 2 END"))
    else
      candidates = candidates.order(created_at: :desc)
    end

    render json: {
      candidates: candidates.as_json(only: [
        :id, :name, :title, :location, :availability,
        :salary_expectation_eur, :years_exp, :skills, :languages
      ]),
      meta: { total: candidates.count }
    }
  end
end
