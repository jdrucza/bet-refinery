export default {
  appliesToCountry: (promotion, country)->
    (not promotion.onlyCountries? or promotion.onlyCountries.length == 0) or country in promotion.onlyCountries and 
    (not promotion.exceptCountries? or promotion.exceptCountries.length == 0) or country not in promotion.exceptCountries
}